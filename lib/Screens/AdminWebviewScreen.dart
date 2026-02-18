import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:raheeb_deliverypartner/Screens/LoginScreen/LoginScreen.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class AdminWebViewScreen extends StatefulWidget {
  final String accessToken;

  const AdminWebViewScreen({super.key, required this.accessToken});

  @override
  State<AdminWebViewScreen> createState() => _AdminWebViewScreenState();
}

class _AdminWebViewScreenState extends State<AdminWebViewScreen> {
  late final WebViewController _controller;

  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = "";
  int _progress = 0;
  bool _logoutHandled = false;

  static const String baseUrl = "https://admin.ecom.palqar.cloud";

  String get initialUrl => "$baseUrl/mobile/${widget.accessToken}";

  @override
  void initState() {
    super.initState();
    _initWebView();
  }

  /// INIT WEBVIEW
  void _initWebView() {
    late PlatformWebViewControllerCreationParams params;

    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const {},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    _controller = WebViewController.fromPlatformCreationParams(params);

    _controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..enableZoom(false)
      ..setNavigationDelegate(_navigationDelegate)
      ..addJavaScriptChannel("FlutterBridge", onMessageReceived: _onJsMessage)
      ..loadRequest(Uri.parse(initialUrl));

    /// Android specific
    if (_controller.platform is AndroidWebViewController) {
      final androidController =
          _controller.platform as AndroidWebViewController;

      AndroidWebViewController.enableDebugging(false);

      androidController
        ..enableZoom(false)
        ..setMediaPlaybackRequiresUserGesture(false)
        ..setOnShowFileSelector(_androidFilePicker)
        ..setOverScrollMode(WebViewOverScrollMode.never)
        ..setGeolocationPermissionsPromptCallbacks(
          onShowPrompt: (request) async {
            final granted = await Permission.location.request().isGranted;

            return GeolocationPermissionsResponse(
              allow: granted,
              retain: false,
            );
          },
        );
    }
  }

  /// NAVIGATION
  NavigationDelegate get _navigationDelegate => NavigationDelegate(
    onProgress: (progress) {
      setState(() {
        _progress = progress;
      });
    },
    onPageStarted: (url) {
      log("Started: $url");

      setState(() {
        _isLoading = true;
        _hasError = false;
      });
    },
    onPageFinished: (url) async {
      log("Finished: $url");

      setState(() {
        _isLoading = false;
      });

      await _injectWebFixes();

      if (_isLoginUrl(url)) {
        _handleLogout();
      }
    },
    onNavigationRequest: (request) {
      final url = request.url;

      if (_isLoginUrl(url)) {
        _handleLogout();
        return NavigationDecision.prevent;
      }

      if (url.startsWith(baseUrl)) {
        return NavigationDecision.navigate;
      }

      _openExternal(url);

      return NavigationDecision.prevent;
    },
    onWebResourceError: (error) {
      if (error.isForMainFrame ?? true) {
        setState(() {
          _hasError = true;
          _isLoading = false;
          _errorMessage = error.description;
        });
      }
    },
  );

  /// JS MESSAGE
  void _onJsMessage(JavaScriptMessage message) {
    final data = message.message;

    log("JS: $data");

    if (data == "LOGOUT") {
      _handleLogout();
      return;
    }

    if (_isLoginUrl(data)) {
      _handleLogout();
    }
  }

  /// INJECT WEB FIXES
  Future<void> _injectWebFixes() async {
    await _controller.runJavaScript('''
      (function() {

        // Viewport fix
        var meta = document.querySelector('meta[name="viewport"]');

        if (!meta) {
          meta = document.createElement('meta');
          meta.name = 'viewport';
          document.head.appendChild(meta);
        }

        meta.content =
          'width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no';

        // Disable horizontal scroll only
        var style = document.createElement('style');

        style.innerHTML = `
          html, body {
            width: 100% !important;
            max-width: 100% !important;
            overflow-x: hidden !important;
            overflow-y: auto !important;
          }

          * {
            max-width: 100% !important;
            box-sizing: border-box !important;
          }
        `;

        document.head.appendChild(style);

        document.body.style.overflowX = "hidden";
        document.body.style.overflowY = "auto";

        document.documentElement.style.overflowX = "hidden";
        document.documentElement.style.overflowY = "auto";

        // Prevent zoom
        document.addEventListener('gesturestart', function(e) {
          e.preventDefault();
        });

        document.addEventListener('dblclick', function(e) {
          e.preventDefault();
        });

        // Route detection
        function notifyFlutter() {

          var url = window.location.href;

          FlutterBridge.postMessage(url);

          if (url.includes('/login')) {
            FlutterBridge.postMessage('LOGOUT');
          }
        }

        notifyFlutter();

        var pushState = history.pushState;

        history.pushState = function() {
          pushState.apply(history, arguments);
          notifyFlutter();
        };

        var replaceState = history.replaceState;

        history.replaceState = function() {
          replaceState.apply(history, arguments);
          notifyFlutter();
        };

        window.addEventListener('popstate', notifyFlutter);

      })();
    ''');
  }

  /// FILE PICKER
  Future<List<String>> _androidFilePicker(FileSelectorParams params) async {
    final result = await FilePicker.platform.pickFiles();

    if (result == null) return [];

    return [result.files.single.path!];
  }

  /// LOGOUT
  void _handleLogout() {
    if (_logoutHandled) return;

    _logoutHandled = true;

    Get.offAll(() => const EmailLoginScreen());
  }

  bool _isLoginUrl(String url) {
    try {
      return Uri.parse(url).path == "/login";
    } catch (_) {
      return false;
    }
  }

  /// OPEN EXTERNAL
  Future<void> _openExternal(String url) async {
    final uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  /// BACK BUTTON
  Future<bool> _onBackPressed() async {
    if (await _controller.canGoBack()) {
      _controller.goBack();
      return false;
    }

    return true;
  }

  /// REFRESH
  Future<void> _refresh() async {
    _controller.reload();
  }

  /// UI
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Stack(
            children: [
              /// WEBVIEW
              RefreshIndicator(
                onRefresh: _refresh,
                child: WebViewWidget(controller: _controller),
              ),

              /// PROGRESS BAR
              if (_isLoading)
                LinearProgressIndicator(value: _progress / 100, minHeight: 3),

              /// ERROR VIEW
              if (_hasError)
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.wifi_off, size: 60),
                      const SizedBox(height: 16),
                      Text(_errorMessage),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _refresh,
                        child: const Text("Retry"),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
