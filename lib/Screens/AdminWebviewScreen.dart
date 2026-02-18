import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:raheeb_deliverypartner/Screens/LoginScreen/LoginScreen.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// AdminWebViewScreen
/// URL  : https://admin.ecom.palqar.cloud/mobile/{accessToken}
/// Features:
///   • Full hardware/software back-button handling
///   • Native file upload (camera + gallery + file picker)
///   • Keyboard-safe layout (resizes body when keyboard appears)
///   • Auto-logout detection (redirected to /login)
///   • Pull-to-refresh
///   • Error page with retry
///   • Progress indicator
///   • No-network snackbar
/// ─────────────────────────────────────────────────────────────────────────────

class AdminWebViewScreen extends StatefulWidget {
  final String accessToken;

  const AdminWebViewScreen({super.key, required this.accessToken});

  @override
  State<AdminWebViewScreen> createState() => _AdminWebViewScreenState();
}

class _AdminWebViewScreenState extends State<AdminWebViewScreen>
    with WidgetsBindingObserver {
  late final WebViewController _controller;

  // ── State ──────────────────────────────────────────────────────────────────
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';
  int _loadingProgress = 0;
  bool _canGoBack = false;
  bool _isLoggedOut = false;
  String _currentUrl = '';

  // ── Constants ──────────────────────────────────────────────────────────────
  static const String _baseUrl = 'https://admin.ecom.palqar.cloud';
  static const String _loginPath = '/login';

  String get _initialUrl => '$_baseUrl/mobile/${widget.accessToken}';

  // ── Lifecycle ──────────────────────────────────────────────────────────────
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initWebView();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // ── WebView Initialization ─────────────────────────────────────────────────
  void _initWebView() {
    late final PlatformWebViewControllerCreationParams params;

    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      // iOS
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    _controller = WebViewController.fromPlatformCreationParams(params)
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..enableZoom(true)
      ..setNavigationDelegate(_buildNavigationDelegate())
      ..addJavaScriptChannel(
        'FlutterBridge',
        onMessageReceived: _onJsMessage,
      )
      ..loadRequest(Uri.parse(_initialUrl));

    // ── Android-specific settings ──────────────────────────────────────────
    if (_controller.platform is AndroidWebViewController) {
      final androidController =
          _controller.platform as AndroidWebViewController;
      androidController
        ..setMediaPlaybackRequiresUserGesture(false)
        ..setGeolocationPermissionsPromptCallbacks(
          onShowPrompt: (request) async {
            final granted = await _requestPermission(Permission.location);
            return GeolocationPermissionsResponse(
              allow: granted,
              retain: false,
            );
          },
          onHidePrompt: () {},
        )
        ..setOnShowFileSelector(_androidFileSelector);
    }
  }

  // ── Navigation Delegate ────────────────────────────────────────────────────
  NavigationDelegate _buildNavigationDelegate() {
    return NavigationDelegate(
      onPageStarted: (url) {
        setState(() {
          _isLoading = true;
          _hasError = false;
          _currentUrl = url;
          _isLoggedOut = _isLoginUrl(url);
        });
        _updateCanGoBack();
      },
      onProgress: (progress) {
        setState(() => _loadingProgress = progress);
      },
      onPageFinished: (url) async {
        setState(() {
          _isLoading = false;
          _currentUrl = url;
          _isLoggedOut = _isLoginUrl(url);
        });
        _updateCanGoBack();

        if (_isLoggedOut) {
          _handleLogout();
        }

        // Inject JS helpers (file upload, keyboard)
        await _injectHelpers();
      },
      onWebResourceError: (error) {
        // Ignore sub-resource errors (ads, analytics)
        if (error.isForMainFrame ?? true) {
          setState(() {
            _isLoading = false;
            _hasError = true;
            _errorMessage = _friendlyError(error.description);
          });
        }
      },
     onNavigationRequest: (request) {
  final url = request.url;

  /// ✅ Detect logout BEFORE loading login page
  if (_isLoginUrl(url)) {
    _handleLogout();
    return NavigationDecision.prevent; // stop WebView loading login page
  }

  final uri = Uri.tryParse(url);
  if (uri == null) return NavigationDecision.prevent;

  /// Allow internal navigation
  if (url.startsWith(_baseUrl)) {
    return NavigationDecision.navigate;
  }

  /// External links open browser
  _launchExternalUrl(url);
  return NavigationDecision.prevent;
},
    );
  }

  // ── Android File Selector ──────────────────────────────────────────────────
  Future<List<String>> _androidFileSelector(
      FileSelectorParams params) async {
    final acceptTypes = params.acceptTypes;
    final isImage = acceptTypes.any((t) => t.contains('image'));
    final isVideo = acceptTypes.any((t) => t.contains('video'));
    final isMedia = isImage || isVideo;

    if (isMedia) {
      final choice = await _showMediaPickerDialog(isImage: isImage);
      if (choice == null) return [];
      return choice;
    }

    // Generic file picker
    return _pickGenericFile();
  }

  Future<List<String>> _showMediaPickerDialog(
      {required bool isImage}) async {
    final result = await showModalBottomSheet<List<String>>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _MediaPickerSheet(isImage: isImage),
    );
    return result ?? [];
  }

  Future<List<String>> _pickGenericFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        withData: false,
      );
      if (result == null || result.files.isEmpty) return [];
      final path = result.files.single.path;
      return path != null ? [path] : [];
    } catch (_) {
      return [];
    }
  }

  // ── JS Helpers ─────────────────────────────────────────────────────────────
  Future<void> _injectHelpers() async {
    // Ensure viewport is responsive & keyboard-aware
    await _controller.runJavaScript('''
      (function() {
        var meta = document.querySelector('meta[name="viewport"]');
        if (!meta) {
          meta = document.createElement('meta');
          meta.name = 'viewport';
          document.head.appendChild(meta);
        }
        meta.content = 'width=device-width, initial-scale=1.0, maximum-scale=5.0, user-scalable=yes';

        // Scroll focused element into view when keyboard opens
        document.addEventListener('focusin', function(e) {
          setTimeout(function() {
            if (e.target && e.target.scrollIntoView) {
              e.target.scrollIntoView({ behavior: 'smooth', block: 'center' });
            }
          }, 300);
        });
      })();
    ''');
  }

  // ── JS Channel Messages ────────────────────────────────────────────────────
  void _onJsMessage(JavaScriptMessage message) {
    final data = message.message;
    if (data == 'logout') {
      _handleLogout();
    }
  }

  // ── Helpers ────────────────────────────────────────────────────────────────
  bool _isLoginUrl(String url) =>
      url.startsWith('$_baseUrl$_loginPath') ||
      url.contains('/login');

 void _handleLogout() {
  if (!mounted) return;

  Future.delayed(const Duration(milliseconds: 300), () {
    if (!mounted) return;
      Get.to(() => const EmailLoginScreen());

  });
}
  Future<void> _updateCanGoBack() async {
    final canGoBack = await _controller.canGoBack();
    if (mounted) setState(() => _canGoBack = canGoBack);
  }

  Future<bool> _requestPermission(Permission permission) async {
    var status = await permission.status;
    if (status.isDenied) status = await permission.request();
    return status.isGranted;
  }

  Future<void> _launchExternalUrl(String url) async {
    final uri = Uri.tryParse(url);
    if (uri != null && await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  String _friendlyError(String raw) {
    if (raw.contains('net::ERR_INTERNET_DISCONNECTED') ||
        raw.contains('net::ERR_NAME_NOT_RESOLVED')) {
      return 'No internet connection. Please check your network and try again.';
    }
    if (raw.contains('net::ERR_CONNECTION_TIMED_OUT')) {
      return 'Connection timed out. The server took too long to respond.';
    }
    if (raw.contains('net::ERR_CONNECTION_REFUSED')) {
      return 'Connection refused. The server may be down.';
    }
    return 'Something went wrong. Please try again.';
  }

  // ── Actions ────────────────────────────────────────────────────────────────
  Future<bool> _onWillPop() async {
    if (_canGoBack) {
      await _controller.goBack();
      return false;
    }
    return true; // Let the OS close/pop the screen
  }

  void _refresh() {
    setState(() {
      _hasError = false;
      _isLoading = true;
    });
    _controller.reload();
  }

  // ── Build ──────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              // Progress bar
              if (_isLoading && _loadingProgress < 100)
                LinearProgressIndicator(
                  value: _loadingProgress / 100,
                  minHeight: 3,
                  backgroundColor: Colors.grey.shade200,
                  color: const Color(0xFF1A73E8),
                ),

              // Logout banner
              if (_isLoggedOut)
                _LogoutBanner(onDismiss: () => Navigator.of(context).pop('logout')),

              // Main content
              Expanded(
                child: Stack(
                  children: [
                    // WebView (always present to keep state)
                    RefreshIndicator(
                      onRefresh: () async => _refresh(),
                      child: WebViewWidget(controller: _controller),
                    ),

                    // Error overlay
                    if (_hasError)
                      _ErrorOverlay(
                        message: _errorMessage,
                        onRetry: _refresh,
                      ),

                    // Initial loading spinner (before first paint)
                    if (_isLoading && _loadingProgress == 0)
                      const _LoadingPlaceholder(),
                  ],
                ),
              ),

              // Bottom navigation bar (back / forward / refresh / home)
              _BottomNavBar(
                canGoBack: _canGoBack,
                isLoading: _isLoading,
                onBack: () async {
                  if (await _controller.canGoBack()) _controller.goBack();
                },
                onForward: () async {
                  if (await _controller.canGoForward()) _controller.goForward();
                },
                onRefresh: _refresh,
                onHome: () => _controller.loadRequest(Uri.parse(_initialUrl)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Sub-widgets
// ─────────────────────────────────────────────────────────────────────────────

class _BottomNavBar extends StatelessWidget {
  final bool canGoBack;
  final bool isLoading;
  final VoidCallback onBack;
  final VoidCallback onForward;
  final VoidCallback onRefresh;
  final VoidCallback onHome;

  const _BottomNavBar({
    required this.canGoBack,
    required this.isLoading,
    required this.onBack,
    required this.onForward,
    required this.onRefresh,
    required this.onHome,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            onPressed: canGoBack ? onBack : null,
            tooltip: 'Back',
          ),
          IconButton(
            icon: const Icon(Icons.arrow_forward_ios_rounded),
            onPressed: onForward,
            tooltip: 'Forward',
          ),
          IconButton(
            icon: isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.refresh_rounded),
            onPressed: onRefresh,
            tooltip: 'Refresh',
          ),
          IconButton(
            icon: const Icon(Icons.home_rounded),
            onPressed: onHome,
            tooltip: 'Home',
          ),
        ],
      ),
    );
  }
}

class _ErrorOverlay extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorOverlay({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.wifi_off_rounded,
                  size: 72, color: Colors.grey.shade400),
              const SizedBox(height: 20),
              Text(
                'Connection Problem',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 12),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey.shade600, height: 1.5),
              ),
              const SizedBox(height: 28),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Try Again'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A73E8),
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LoadingPlaceholder extends StatelessWidget {
  const _LoadingPlaceholder();

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: Colors.white,
      child: Center(
        child: CircularProgressIndicator(color: Color(0xFF1A73E8)),
      ),
    );
  }
}

class _LogoutBanner extends StatelessWidget {
  final VoidCallback onDismiss;
  const _LogoutBanner({required this.onDismiss});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFFFF3CD),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            const Icon(Icons.warning_amber_rounded,
                color: Color(0xFF856404), size: 20),
            const SizedBox(width: 8),
            const Expanded(
              child: Text(
                'Session expired. You have been logged out.',
                style: TextStyle(
                    color: Color(0xFF856404), fontWeight: FontWeight.w500),
              ),
            ),
            TextButton(
              onPressed: onDismiss,
              child: const Text('OK',
                  style: TextStyle(color: Color(0xFF856404))),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Media Picker Sheet (iOS-style)
// ─────────────────────────────────────────────────────────────────────────────

class _MediaPickerSheet extends StatelessWidget {
  final bool isImage;
  const _MediaPickerSheet({required this.isImage});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 8),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            isImage ? 'Select Image' : 'Select File',
            style: const TextStyle(
                fontSize: 17, fontWeight: FontWeight.w600),
          ),
          const Divider(height: 24),
          _SheetTile(
            icon: Icons.camera_alt_rounded,
            label: 'Camera',
            onTap: () async {
              final picker = ImagePicker();
              final XFile? file = isImage
                  ? await picker.pickImage(source: ImageSource.camera)
                  : await picker.pickVideo(source: ImageSource.camera);
              Navigator.of(context).pop(file != null ? [file.path] : <String>[]);
            },
          ),
          _SheetTile(
            icon: Icons.photo_library_rounded,
            label: 'Gallery',
            onTap: () async {
              final picker = ImagePicker();
              final XFile? file = isImage
                  ? await picker.pickImage(source: ImageSource.gallery)
                  : await picker.pickVideo(source: ImageSource.gallery);
              Navigator.of(context).pop(file != null ? [file.path] : <String>[]);
            },
          ),
          _SheetTile(
            icon: Icons.folder_rounded,
            label: 'Browse Files',
            onTap: () async {
              final result = await FilePicker.platform.pickFiles();
              final path = result?.files.single.path;
              Navigator.of(context)
                  .pop(path != null ? [path] : <String>[]);
            },
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () => Navigator.of(context).pop(<String>[]),
                child: const Text('Cancel',
                    style: TextStyle(fontSize: 16, color: Colors.red)),
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _SheetTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _SheetTile(
      {required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: const Color(0xFF1A73E8).withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: const Color(0xFF1A73E8)),
      ),
      title: Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
      trailing: const Icon(Icons.chevron_right_rounded, color: Colors.grey),
      onTap: onTap,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Usage example (entry point)
// ─────────────────────────────────────────────────────────────────────────────
//
//  Navigator.push(
//    context,
//    MaterialPageRoute(
//      builder: (_) => AdminWebViewScreen(accessToken: 'your_token_here'),
//    ),
//  ).then((result) {
//    if (result == 'logout') {
//      // Navigate to your login screen
//    }
//  });