import 'package:flutter/material.dart';
import 'package:mfc/Constants/colors.dart';

// Message Model
class Message {
  final String text;
  final bool isUser;
  Message({required this.text, required this.isUser});
}

// Chat Bubble Widget
class ChatBubble extends StatelessWidget {
  final Message message;
  const ChatBubble({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isUser = message.isUser;
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isUser ? primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              blurRadius: 6,
              offset: const Offset(2, 2),
            ),
          ],
        ),
        child: Text(
          message.text,
          style: TextStyle(
            color: isUser ? Colors.white : Colors.black87,
          ),
        ),
      ),
    );
  }
}

// ChatBot Screen
class ChatBotScreen extends StatefulWidget {
  const ChatBotScreen({Key? key}) : super(key: key);

  @override
  State<ChatBotScreen> createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends State<ChatBotScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Message> _messages = [
    Message(
      text: 'Hello! Ask me about any dish, ingredients, or diet tips.',
      isUser: false,
    ),
    Message(
      text: 'What is the best dish for someone on a diet?',
      isUser: true,
    ),
  ];

  void _sendMessage() {
    final String text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add(Message(text: text, isUser: true));
      // TODO: Call the API (Groq or Firebase), await response, then:
      // _messages.add(Message(text: botResponse, isUser: false));
    });
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text('AI ChatBot', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 12),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return ChatBubble(message: _messages[index]);
              },
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16, left: 12, right: 12),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(color: Colors.black12, blurRadius: 4),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        minLines: 1,
                        maxLines: 5,
                        decoration: const InputDecoration.collapsed(
                          hintText: 'Ask about food, ingredients, calories...',
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.send, color: primaryColor),
                      onPressed: _sendMessage,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:mfc/Constants/colors.dart';

// class ChatBotScreen extends StatelessWidget {
//   const ChatBotScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey.shade100,
//       appBar: AppBar(
//         backgroundColor: primaryColor,
//         title: const Text('AI ChatBot', style: TextStyle(color: Colors.white)),
//         centerTitle: true,
//         elevation: 0,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.only(bottom: 20),
//         child: Column(
//           children: [
//             Expanded(
//               child: ListView.builder(
//                 padding: const EdgeInsets.all(12),
//                 itemCount: messages.length,
//                 itemBuilder: (context, index) {
//                   final message = messages[index];
//                   final isUser = message['sender'] == 'user';
//                   return Align(
//                     alignment:
//                         isUser ? Alignment.centerRight : Alignment.centerLeft,
//                     child: Container(
//                       margin: const EdgeInsets.symmetric(vertical: 6),
//                       padding: const EdgeInsets.all(12),
//                       decoration: BoxDecoration(
//                         color: isUser ? primaryColor : Colors.white,
//                         borderRadius: BorderRadius.circular(16),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.grey.shade300,
//                             blurRadius: 6,
//                             offset: const Offset(2, 2),
//                           )
//                         ],
//                       ),
//                       child: Text(
//                         message['text']!,
//                         style: TextStyle(
//                             color: isUser ? Colors.white : Colors.black87),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 border: Border(top: BorderSide(color: Colors.grey.shade300)),
//               ),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: TextField(
//                       controller: _controller,
//                       decoration: const InputDecoration(
//                         hintText: 'Ask about food, ingredients, calories...',
//                         border: InputBorder.none,
//                       ),
//                     ),
//                   ),
//                   IconButton(
//                     icon: const Icon(Icons.send, color: primaryColor),
//                     onPressed: () {
//                       // TODO: Add send logic using Groq or Firebase
//                     },
//                   )
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // Dummy data and controller
// final TextEditingController _controller = TextEditingController();

// final List<Map<String, String>> messages = [
//   {
//     'sender': 'bot',
//     'text': 'Hello! Ask me about any dish, ingredients, or diet tips.'
//   },
//   {'sender': 'user', 'text': 'What is the best dish for someone on a diet?'}
// ];
