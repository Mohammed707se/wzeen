// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:file_picker/file_picker.dart';
import '../providers/chat_provider.dart';
import '../widgets/chat_message_widget.dart';
import '../widgets/chat_messages.dart';
import '../widgets/file_upload_widget.dart';
import '../widgets/message_input.dart';
import '../widgets/web_message_input.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'المحلل المالي',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Column(
        children: const [
          FileUploadWidget(),
          Expanded(child: ChatMessages()),
          if (kIsWeb) const WebMessageInput() else const MessageInput(),
        ],
      ),
    );
  }
}
