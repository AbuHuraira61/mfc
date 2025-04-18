import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatBotScreen extends StatefulWidget {
  @override
  _ChatBotScreenState createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends State<ChatBotScreen> {
  TextEditingController _controller = TextEditingController();
  List<Map<String, String>> messages = [];
  bool isLoading = false;

  void handleMessage(String msg) {
    setState(() {
      messages.add({"sender": "user", "text": msg});
    });

    if (msg.toLowerCase().contains("best dish")) {
      getBestDish();
    } else {
      setState(() {
        messages.add({
          "sender": "bot",
          "text": "Aap mujhse pooch sakte hain: 'Best dish kya hai?'"
        });
      });
    }

    _controller.clear();
  }

  void getBestDish() async {
    setState(() => isLoading = true);

    var orders = await FirebaseFirestore.instance.collection('orders').get();

    Map<String, List<double>> dishRatings = {};

    for (var doc in orders.docs) {
      var data = doc.data();

      if (data.containsKey('name') &&
          data.containsKey('feedback') &&
          data['feedback'] != null &&
          data['feedback'].containsKey('rating')) {
        String dishName = data['name'];

        var ratingValue = data['feedback']['rating'];
        if (ratingValue != null) {
          double rating = ratingValue is int
              ? ratingValue.toDouble()
              : ratingValue.toDouble();
          dishRatings.putIfAbsent(dishName, () => []).add(rating);
        }
      }
    }

    if (dishRatings.isEmpty) {
      setState(() {
        messages.add(
            {"sender": "bot", "text": "Koi dish feedback mein nahi mili."});
        isLoading = false;
      });
      return;
    }

    String bestDish = "";
    double highestAvg = 0;

    dishRatings.forEach((dish, ratings) {
      double avg = ratings.reduce((a, b) => a + b) / ratings.length;
      if (avg > highestAvg) {
        highestAvg = avg;
        bestDish = dish;
      }
    });

    // Ingredients search
    String foundIngredients = "";
    bool found = false;

    var categories =
        await FirebaseFirestore.instance.collection('food-items').get();

    for (var category in categories.docs) {
      var items = await category.reference
          .collection('items')
          .where('name', isEqualTo: bestDish)
          .get();

      if (items.docs.isNotEmpty) {
        List ingredients = items.docs.first['ingredients'];
        foundIngredients = ingredients.join(', ');
        found = true;
        break;
      }
    }

    setState(() {
      if (found) {
        messages.add({
          "sender": "bot",
          "text":
              "$bestDish sabse pasandida dish hai.\nTaste bohat lazeez hai.\nIngredients: $foundIngredients"
        });
      } else {
        messages.add({
          "sender": "bot",
          "text": "Best dish mil gayi: $bestDish, lekin ingredients nahi milay."
        });
      }
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("ChatBot")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(10),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                var msg = messages[index];
                bool isUser = msg["sender"] == "user";
                return Align(
                  alignment:
                      isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isUser ? Colors.green[100] : Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(msg["text"] ?? ""),
                  ),
                );
              },
            ),
          ),
          if (isLoading) CircularProgressIndicator(),
          Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "Type your message...",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () => handleMessage(_controller.text.trim()),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
