// lib/widgets/web_message_input.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:html' as html;
// تحديث الاستيراد لاستخدام ui_web
import 'dart:ui_web' as ui_web;
import '../providers/chat_provider.dart';

class WebMessageInput extends StatefulWidget {
  const WebMessageInput({Key? key}) : super(key: key);

  @override
  State<WebMessageInput> createState() => _WebMessageInputState();
}

class _WebMessageInputState extends State<WebMessageInput> {
  late final String _viewId;
  late final html.DivElement _inputElement;

  @override
  void initState() {
    super.initState();
    _setupWebInput();
  }

  void _setupWebInput() {
    _viewId = 'web-input-${DateTime.now().millisecondsSinceEpoch}';

    final styleElement = html.StyleElement();
    styleElement.text = '''
  #$_viewId {
    width: 100%;
    min-height: 40px;
    max-height: 100px;
    overflow-y: auto;
    padding: 8px 12px;
    border: 1px solid #e0e0e0;
    border-radius: 20px;
    background-color: #f5f5f5;
    outline: none;
    font-size: 16px;
    line-height: 1.4;
    direction: rtl;
    margin-left: -20px; /* أضف هذا السطر لتوجيه العنصر إلى اليسار */
  }
  #$_viewId:empty:before {
    content: 'اكتب سؤالك هنا...';
    color: #999;
  }
  #$_viewId:focus {
    border-color: #6857E9;
    background-color: #ffffff;
  }
''';

    html.document.head?.append(styleElement);

    _inputElement = html.DivElement()
      ..id = _viewId
      ..contentEditable = 'true'
      ..style.width = '100%';

    _inputElement.onKeyPress.listen((event) {
      if (event.keyCode == 13 && !event.shiftKey) {
        event.preventDefault();
        _sendMessage();
      }
    });

    // استخدام ui_web بدلاً من ui
    ui_web.platformViewRegistry
        .registerViewFactory(_viewId, (int viewId) => _inputElement);
  }

  void _sendMessage() {
    final message = _inputElement.innerText.trim();
    if (message.isNotEmpty) {
      Provider.of<ChatProvider>(context, listen: false).sendMessage(message);
      _inputElement.innerText = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, -2),
            blurRadius: 4,
            color: Colors.black.withOpacity(0.1),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 40,
                child: HtmlElementView(viewType: _viewId),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                onPressed: _sendMessage,
                icon: const Icon(Icons.send),
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
