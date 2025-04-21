import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mfc/Constants/colors.dart';
import 'package:mfc/Services/firestore_chat_service.dart';
import 'package:mfc/services/groq_service.dart'; // import your GroqService file


bool isDeleting = false;

// Message Model
class Message {
  final String text;
  final bool isUser;
  Message({required this.text, required this.isUser});
}

// Chat Bubble Widget
class ChatBubble extends StatelessWidget {
  final Message message;
  const ChatBubble({super.key, required this.message});

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
  const ChatBotScreen({super.key});

  @override
  State<ChatBotScreen> createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends State<ChatBotScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FirestoreChatService _firestoreService = FirestoreChatService();
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  /// Fetch response using your external GroqService
  Future<String> fetchGroqReply(String userMessage) async {
    try {
      final groq = GroqService();
      return await groq.getChatResponse(userMessage);
    } catch (e) {
      return 'Error: \$e';
    }
  }

  /// Send message, save to Firestore, show typing, call API, save bot response
  void _sendMessage() async {
    final String text = _controller.text.trim();
    if (text.isEmpty) return;

    _controller.clear();

    // save user message
    _firestoreService.sendMessage(text: text, isUser: true);
    // show typing indicator
    setState(() => _isTyping = true);

    // call AI
    final botResponse = await fetchGroqReply(text);

    // save bot response
    _firestoreService.sendMessage(isUser: false,text: botResponse);

    // hide typing indicator
    setState(() => _isTyping = false);
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
        actions: [ElevatedButton(onPressed: () async {
          setState(() => isDeleting = true);
          _firestoreService.clearMessages();
          setState(() => isDeleting = false);
        }, child: Text('Clear Chat'))],
      ),
      body: Column(
        children: [
          isDeleting ? Center(
            child: Column(
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 10),
                Text('Deleting your chat...'),
              ],
            ),
          ) : Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestoreService.getMessagesStream(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final docs = snapshot.data!.docs;
                final messages = docs
                    .map((doc) => Message(
                          text: doc['text'] as String,
                          isUser: doc['isUser'] as bool,
                        ))
                    .toList();
                // after build, scroll to bottom
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (_scrollController.hasClients) {
                    _scrollController.jumpTo(
                      _scrollController.position.maxScrollExtent,
                    );
                  }
                });
                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.only(top: 12),
                  itemCount: messages.length + (_isTyping ? 1 : 0),
                  itemBuilder: (context, index) {
                    // if at end and typing, show placeholder
                    if (_isTyping && index == messages.length) {
                      return ChatBubble(
                          message: Message(text: '...', isUser: false));
                    }
                    return ChatBubble(message: messages[index]);
                  },
                );
              },
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16, left: 12, right: 12),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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





// import 'dart:async';
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:mfc/Constants/colors.dart';
// import 'package:mfc/services/groq_service.dart'; // import your GroqService file

// // Message Model
// class Message {
//   final String text;
//   final bool isUser;
//   Message({required this.text, required this.isUser});
// }

// // Chat Bubble Widget
// class ChatBubble extends StatelessWidget {
//   final Message message;
//   const ChatBubble({Key? key, required this.message}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final bool isUser = message.isUser;
//     return Align(
//       alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
//       child: Container(
//         margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
//         padding: const EdgeInsets.all(12),
//         decoration: BoxDecoration(
//           color: isUser ? primaryColor : Colors.white,
//           borderRadius: BorderRadius.circular(16),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.shade300,
//               blurRadius: 6,
//               offset: const Offset(2, 2),
//             ),
//           ],
//         ),
//         child: Text(
//           message.text,
//           style: TextStyle(
//             color: isUser ? Colors.white : Colors.black87,
//           ),
//         ),
//       ),
//     );
//   }
// }

// // ChatBot Screen
// class ChatBotScreen extends StatefulWidget {
//   const ChatBotScreen({Key? key}) : super(key: key);

//   @override
//   State<ChatBotScreen> createState() => _ChatBotScreenState();
// }

// class _ChatBotScreenState extends State<ChatBotScreen> {
//   final TextEditingController _controller = TextEditingController();
//   final List<Message> _messages = [
//     Message(
//       text: 'Hello! Ask me about any dish, ingredients, or diet tips.',
//       isUser: false,
//     ),
//     Message(
//       text: 'What is the best dish for someone on a diet?',
//       isUser: true,
//     ),
//   ];

//   // Stream controller for live messages
//   final StreamController<List<Message>> _messagesController = StreamController<List<Message>>.broadcast();

//   @override
//   void initState() {
//     super.initState();
//     // Emit initial messages
//     _messagesController.add(List.from(_messages));
//   }

//   @override
//   void dispose() {
//     _messagesController.close();
//     _controller.dispose();
//     super.dispose();
//   }

//   /// Fetch response using your external GroqService
//   Future<String> fetchGroqReply(String userMessage) async {
//     try {
//       final groq = GroqService();
//       return await groq.getChatResponse(userMessage);
//     } catch (e) {
//       return 'Error: $e';
//     }
//   }

//   /// Send message, call external service, and add bot response
//   void _sendMessage() async {
//     final String text = _controller.text.trim();
//     if (text.isEmpty) return;

//     // Add user message
//     setState(() {
//       _messages.add(Message(text: text, isUser: true));
//     });
//     _messagesController.add(List.from(_messages));
//     _controller.clear();

//     // Fetch and add bot response
//     final botResponse = await fetchGroqReply(text);
//     setState(() {
//       _messages.add(Message(text: botResponse, isUser: false));
//     });
//     _messagesController.add(List.from(_messages));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset: true,
//       backgroundColor: Colors.grey.shade100,
//       appBar: AppBar(
//         backgroundColor: primaryColor,
//         title: const Text('AI ChatBot', style: TextStyle(color: Colors.white)),
//         centerTitle: true,
//         elevation: 0,
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: StreamBuilder<List<Message>>(
//               stream: _messagesController.stream,
//               initialData: List.from(_messages),
//               builder: (context, snapshot) {
//                 final messages = snapshot.data!;
//                 return ListView.builder(
//                   padding: const EdgeInsets.only(top: 12),
//                   itemCount: messages.length,
//                   itemBuilder: (context, index) {
//                     return ChatBubble(message: messages[index]);
//                   },
//                 );
//               },
//             ),
//           ),
//           SafeArea(
//             child: Padding(
//               padding: const EdgeInsets.only(bottom: 16, left: 12, right: 12),
//               child: Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(30),
//                   boxShadow: [
//                     BoxShadow(color: Colors.black12, blurRadius: 4),
//                   ],
//                 ),
//                 child: Row(
//                   children: [
//                     Expanded(
//                       child: TextField(
//                         controller: _controller,
//                         minLines: 1,
//                         maxLines: 5,
//                         decoration: const InputDecoration.collapsed(
//                           hintText: 'Ask about food, ingredients, calories...',
//                         ),
//                       ),
//                     ),
//                     IconButton(
//                       icon: const Icon(Icons.send, color: primaryColor),
//                       onPressed: _sendMessage,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
