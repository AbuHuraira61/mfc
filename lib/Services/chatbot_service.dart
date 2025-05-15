import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mfc/Services/groq_service.dart';

class ChatbotService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GroqService _groqService = GroqService();

  // Fetch all feedback data
  Future<List<Map<String, dynamic>>> getAllFeedback() async {
    try {
      final QuerySnapshot feedbackSnapshot = await _firestore
          .collection('orders')
          .where('feedback', isNull: false)
          .get();

      return feedbackSnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        final feedback = data['feedback'];
        final items = data['items'];
        return {
          'feedback': feedback,
          'items': items,
        };
      }).toList();
    } catch (e) {
      return [];
    }
  }

  // Fetch all food items with their ingredients
  Future<List<Map<String, dynamic>>> getAllFoodItems() async {
    try {
      List<Map<String, dynamic>> allItems = [];
      final categoriesSnapshot = await _firestore.collection('food_items').get();
      for (var category in categoriesSnapshot.docs) {
        final itemsSnapshot = await category.reference.collection('items').get();
        for (var item in itemsSnapshot.docs) {
          final data = item.data();
          data['category'] = category.id;
          data['id'] = item.id;
          allItems.add(data);
        }
      }
      // Deals
      try {
        final dealsSnapshot = await _firestore.collection('deals').get();
        for (var dealType in dealsSnapshot.docs) {
          final dealItems = await dealType.reference.collection('deal').get();
          for (var deal in dealItems.docs) {
            final data = deal.data();
            data['category'] = 'Deals';
            data['id'] = deal.id;
            allItems.add(data);
          }
        }
      } catch (e) {}
      return allItems;
    } catch (e) {
      return [];
    }
  }

  // Process user message and get appropriate response
  Future<String> processMessage(String userMessage) async {
    final lowerMessage = userMessage.toLowerCase();
    try {
      if (lowerMessage.contains('best') || lowerMessage.contains('popular') || 
          lowerMessage.contains('recommend') || lowerMessage.contains('top rated')) {
        // Feedback-based
        final feedbacks = await getAllFeedback();
        final foodItems = await getAllFoodItems();
        if (foodItems.isEmpty) {
          return "Hamare menu ki maloomat abhi load nahi ho pa rahi. Barah-e-karam thodi dair baad dobara koshish karein.";
        }
        if (feedbacks.isEmpty) {
          return "Abhi tak kisi customer ne feedback nahi diya, is liye hum best-rated dish recommend nahi kar sakte. Jaise hi feedback milega, main aap ko recommend kar sakta hoon. Filhal aap menu se koi bhi dish try kar sakte hain!";
        }
        final prompt = '''You are a restaurant chatbot for MFC. Based on the following menu items and customer feedback data, recommend items from our menu. Only recommend items that are listed in the MENU ITEMS section below.

USER QUESTION: "${userMessage}"

MENU ITEMS:
${_formatFoodItemsForPrompt(foodItems)}

CUSTOMER FEEDBACK:
${_formatFeedbackForPrompt(feedbacks)}

Instructions:
1. ONLY recommend items that are listed in the MENU ITEMS section above
2. DO NOT make up or suggest items that are not in our menu
3. Base your recommendations on actual customer ratings and reviews
4. Include the rating if available
5. Keep the response concise and friendly
6. If you can't find relevant feedback, recommend based on menu categories but mention that it's not based on feedback''';
        return await _groqService.getChatResponse(prompt);
      } 
      else if (lowerMessage.contains('health') || lowerMessage.contains('diet') || 
               lowerMessage.contains('allergy') || lowerMessage.contains('nutrition')) {
        final foodItems = await getAllFoodItems();
        if (foodItems.isEmpty) {
          return "Hamare menu ki maloomat abhi load nahi ho pa rahi. Barah-e-karam thodi dair baad dobara koshish karein.";
        }
        final prompt = '''You are a restaurant chatbot for MFC. Based on our menu items and their ingredients listed below, recommend suitable items for the customer's dietary needs. Only recommend items that are listed in the MENU ITEMS section.

USER QUESTION: "${userMessage}"

MENU ITEMS:
${_formatFoodItemsForPrompt(foodItems)}

Instructions:
1. ONLY recommend items that are listed in the MENU ITEMS section above
2. DO NOT make up or suggest items that are not in our menu
3. Analyze the ingredients carefully to match dietary requirements
4. If unsure about an ingredient's effects on health conditions, err on the side of caution
5. Keep the response concise and friendly
6. If no suitable items are found, politely inform the user and suggest consulting with staff for customizations
7. Include a health disclaimer when appropriate''';
        return await _groqService.getChatResponse(prompt);
      }
      else {
        return "I can help you with:\n1. Finding our best-rated dishes based on customer feedback\n2. Recommending dishes from our menu based on your dietary requirements or health conditions\n\nPlease ask me about either of these topics!";
      }
    } catch (e) {
      return "Kuch masla aa gaya hai. Barah-e-karam dobara koshish karein ya staff se raabta karein.";
    }
  }

  String _formatFeedbackForPrompt(List<Map<String, dynamic>> feedbacks) {
    try {
      if (feedbacks.isEmpty) {
        return "No customer feedback available yet.";
      }
      return feedbacks.map((feedback) {
        final items = (feedback['items'] as List?)?.map((item) => item['name'])?.join(', ') ?? 'Unknown items';
        final feedbackData = feedback['feedback'] as Map<String, dynamic>?;
        final rating = feedbackData?['rating'] ?? 'No rating';
        final review = feedbackData?['review'] ?? 'No review';
        return "Items: $items\nRating: $rating\nReview: $review\n";
      }).join('\n');
    } catch (e) {
      return "Error formatting feedback data";
    }
  }

  String _formatFoodItemsForPrompt(List<Map<String, dynamic>> foodItems) {
    try {
      if (foodItems.isEmpty) {
        return "No menu items available.";
      }
      return foodItems.map((item) {
        final name = item['name'] ?? 'Unnamed item';
        final ingredients = item['ingredients'] ?? 'No ingredients listed';
        final category = item['category'] ?? 'Uncategorized';
        final price = item['price'] ?? (item['prices'] != null ? 'Multiple size options available' : 'Price not listed');
        return "Name: $name\nCategory: $category\nPrice: $price\nIngredients: $ingredients\n";
      }).join('\n');
    } catch (e) {
      return "Error formatting menu items";
    }
  }
} 