import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatefulWidget {
  const WebViewPage({super.key});

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();

    // String HTML yang ingin ditampilkan
    const String htmlContent = """
    <!DOCTYPE html>
    <html>
    <head>
      <title>Contoh HTML</title>
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <style>
        body { font-family: sans-serif; padding: 16px; background-color: #f0f0f0; }
        h1 { color: #005c2d; }
        p { font-size: 16px; }
        .highlight { background-color: yellow; }
      </style>
    </head>
    <body>
      <h1>Halo dari HTML!</h1>
      <p>Ini adalah konten HTML yang dirender di dalam aplikasi Flutter menggunakan <span class="highlight">WebView</span>.</p>
      <button onclick="alert('Tombol diklik!')">Klik Saya</button>
    </body>
    </html>
    """;

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadHtmlString(htmlContent);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WebView HTML'),
      ),
      body: WebViewWidget(
        controller: _controller,
      ),
    );
  }
}
