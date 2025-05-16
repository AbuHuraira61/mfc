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
      
      // Fetch food items from main categories
      final foodCategories = ['Pizza', 'Burger', 'Fries', 'Chicken Roll', 'Hot Wings', 'Pasta', 'Sandwich', 'Broast Chicken'];
      
      for (var category in foodCategories) {
        try {
          final itemsSnapshot = await _firestore
              .collection('food_items')
              .doc(category)
              .collection('items')
              .get();
              
          for (var item in itemsSnapshot.docs) {
            final data = item.data();
            data['category'] = category;
            data['id'] = item.id;
            allItems.add(data);
          }
        } catch (e) {
          print('Error fetching items for category $category: $e');
          continue; // Skip this category if there's an error
        }
      }

      // Fetch deals
      final dealTypes = ['One Person Deal', 'Two Person Deals', 'Student Deals', 'Special Pizza Deals', 'Family Deals', 'Lunch Night Deals'];
      
      for (var dealType in dealTypes) {
        try {
          final dealItems = await _firestore
              .collection('deals')
              .doc(dealType)
              .collection('deal')
              .get();
              
          for (var deal in dealItems.docs) {
            final data = deal.data();
            data['category'] = 'Deals - $dealType';
            data['id'] = deal.id;
            allItems.add(data);
          }
        } catch (e) {
          print('Error fetching deals for type $dealType: $e');
          continue; // Skip this deal type if there's an error
        }
      }

      if (allItems.isEmpty) {
        throw Exception('No menu items found in any category');
      }

      return allItems;
    } catch (e) {
      print('Error in getAllFoodItems: $e');
      throw Exception('Failed to load menu items: $e');
    }
  }

  // Process user message and get appropriate response
  Future<String> processMessage(String userMessage) async {
    final lowerMessage = userMessage.toLowerCase();
    try {
      if (lowerMessage.contains('best') || lowerMessage.contains('popular') || 
          lowerMessage.contains('recommend') || lowerMessage.contains('top rated')) {
        try {
          // Feedback-based
          final foodItems = await getAllFoodItems();
          final feedbacks = await getAllFeedback();
          
          if (feedbacks.isEmpty) {
            return "Abhi tak kisi customer ne feedback nahi diya, is liye hum best-rated dish recommend nahi kar sakte. Lekin main aap ko hamare menu se kuch popular dishes bata sakta hoon:\n\n" + 
                   _getPopularItems(foodItems);
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
        } catch (e) {
          print('Error processing menu recommendation: $e');
          return "Maaf kijiye, menu ki maloomat hasil karne mein masla aa gaya hai. Kya aap thodi dair baad dobara koshish kar sakte hain?";
        }
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
        try {
          final items = (feedback['items'] as List?)?.map((item) => item['name'])?.join(', ') ?? 'Unknown items';
          // Safely handle feedback data which might be a string or a map
          var rating = 'No rating';
          var review = 'No review';
          
          if (feedback['feedback'] is Map) {
            final feedbackData = feedback['feedback'] as Map<String, dynamic>;
            rating = feedbackData['rating']?.toString() ?? 'No rating';
            review = feedbackData['review']?.toString() ?? 'No review';
          } else if (feedback['feedback'] is String) {
            review = feedback['feedback'];
          }
          
          return "Items: $items\nRating: $rating\nReview: $review\n";
        } catch (e) {
          print('Error processing individual feedback: $e');
          return "Error processing feedback entry\n";
        }
      }).join('\n');
    } catch (e) {
      print('Error in _formatFeedbackForPrompt: $e');
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

  String _getPopularItems(List<Map<String, dynamic>> foodItems) {
    // Get a few items from different categories
    final categories = foodItems.map((item) => item['category']).toSet();
    final popularItems = <String>[];
    
    for (var category in categories) {
      final categoryItems = foodItems.where((item) => item['category'] == category).toList();
      if (categoryItems.isNotEmpty) {
        popularItems.add("${categoryItems[0]['name']} (${category})");
      }
      if (popularItems.length >= 5) break; // Limit to 5 items
    }
    
    return popularItems.map((item) => "• $item").join("\n");
  }
} 