import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mfc/Constants/colors.dart';
import 'package:mfc/Services/chatbot_service.dart';

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
  final ChatbotService _chatbotService = ChatbotService();
  bool _isTyping = false;

  // Maintain messages locally in memory (no Firestore)
  final List<Message> _messages = [];

  @override
  void initState() {
    super.initState();
    _showWelcomeMessage();
  }

  void _showWelcomeMessage() {
    setState(() {
      _messages.add(
        Message(
          text:
              "Hello! I can help you with:\n1. Finding our best-rated dishes based on customer feedback\n2. Recommending dishes based on your dietary requirements or health conditions\n\nWhat would you like to know?",
          isUser: false,
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  /// Send message, show typing, call API, add bot response locally
  void _sendMessage() async {
    final String text = _controller.text.trim();
    if (text.isEmpty) return;

    _controller.clear();

    setState(() {
      // Add user message locally
      _messages.add(Message(text: text, isUser: true));
      _isTyping = true;
    });

    try {
      // Get intelligent response using ChatbotService
      final botResponse = await _chatbotService.processMessage(text);

      setState(() {
        // Add bot response locally
        _messages.add(Message(text: botResponse, isUser: false));
        _isTyping = false;
      });
    } catch (e) {
      setState(() {
        _messages.add(
          Message(
            text: "I apologize, but I encountered an error. Please try again.",
            isUser: false,
          ),
        );
        _isTyping = false;
      });
    }

    // Scroll to bottom after a short delay
    await Future.delayed(const Duration(milliseconds: 100));
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
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
              controller: _scrollController,
              padding: const EdgeInsets.only(top: 12),
              itemCount: _messages.length + (_isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (_isTyping && index == _messages.length) {
                  return  ChatBubble(
                      message: Message(text: '...', isUser: false));
                }
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
                          hintText: 'Ask ...',
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
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:mfc/Constants/colors.dart';
// import 'package:mfc/Services/firestore_chat_service.dart';
// import 'package:mfc/Services/chatbot_service.dart';

// bool isDeleting = false;

// // Message Model
// class Message {
//   final String text;
//   final bool isUser;
//   Message({required this.text, required this.isUser});
// }

// // Chat Bubble Widget
// class ChatBubble extends StatelessWidget {
//   final Message message;
//   const ChatBubble({super.key, required this.message});

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
//   const ChatBotScreen({super.key});

//   @override
//   State<ChatBotScreen> createState() => _ChatBotScreenState();
// }

// class _ChatBotScreenState extends State<ChatBotScreen> {
//   final TextEditingController _controller = TextEditingController();
//   final ScrollController _scrollController = ScrollController();
//   final FirestoreChatService _firestoreService = FirestoreChatService();
//   final ChatbotService _chatbotService = ChatbotService();
//   bool _isTyping = false;

//   @override
//   void initState() {
//     super.initState();
//     _showWelcomeMessage();
//   }

//   void _showWelcomeMessage() async {
//     await _firestoreService.sendMessage(
//       text: "Hello! I can help you with:\n1. Finding our best-rated dishes based on customer feedback\n2. Recommending dishes based on your dietary requirements or health conditions\n\nWhat would you like to know?",
//       isUser: false
//     );
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     _scrollController.dispose();
//     super.dispose();
//   }

//   /// Send message, save to Firestore, show typing, call API, save bot response
//   void _sendMessage() async {
//     final String text = _controller.text.trim();
//     if (text.isEmpty) return;

//     _controller.clear();

//     // save user message
//     await _firestoreService.sendMessage(text: text, isUser: true);
    
//     // show typing indicator
//     setState(() => _isTyping = true);

//     try {
//       // Get intelligent response using ChatbotService
//       final botResponse = await _chatbotService.processMessage(text);
      
//       // save bot response
//       await _firestoreService.sendMessage(text: botResponse, isUser: false);
//     } catch (e) {
//       // Handle error
//       await _firestoreService.sendMessage(
//         text: "I apologize, but I encountered an error. Please try again.",
//         isUser: false
//       );
//     }

//     // hide typing indicator
//     setState(() => _isTyping = false);
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
//         // actions: [ElevatedButton(
//         //   onPressed: () async {
//         //     setState(() => isDeleting = true);
//         //     await _firestoreService.clearMessages();
//         //     setState(() => isDeleting = false);
//         //     _showWelcomeMessage();
//         //   },
//         //   child: Text('Clear Chat')
//         // )],
//       ),
//       body: Column(
//         children: [
//           isDeleting ? Center(
//             child: Column(
//               children: [
//                 CircularProgressIndicator(),
//                 SizedBox(height: 10),
//                 Text('Deleting your chat...'),
//               ],
//             ),
//           ) : Expanded(
//             child: StreamBuilder<QuerySnapshot>(
//               stream: _firestoreService.getMessagesStream(),
//               builder: (context, snapshot) {
//                 if (!snapshot.hasData) {
//                   return const Center(child: CircularProgressIndicator());
//                 }
//                 final docs = snapshot.data!.docs;
//                 final messages = docs
//                     .map((doc) => Message(
//                           text: doc['text'] as String,
//                           isUser: doc['isUser'] as bool,
//                         ))
//                     .toList();
//                 // after build, scroll to bottom
//                 WidgetsBinding.instance.addPostFrameCallback((_) {
//                   if (_scrollController.hasClients) {
//                     _scrollController.jumpTo(
//                       _scrollController.position.maxScrollExtent,
//                     );
//                   }
//                 });
//                 return ListView.builder(
//                   controller: _scrollController,
//                   padding: const EdgeInsets.only(top: 12),
//                   itemCount: messages.length + (_isTyping ? 1 : 0),
//                   itemBuilder: (context, index) {
//                     // if at end and typing, show placeholder
//                     if (_isTyping && index == messages.length) {
//                       return ChatBubble(
//                           message: Message(text: '...', isUser: false));
//                     }
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
//                           hintText: 'Ask ...',
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
