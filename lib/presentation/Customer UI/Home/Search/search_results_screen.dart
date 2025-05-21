import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mfc/Constants/colors.dart';
import 'package:mfc/Models/cart_model.dart';
import 'package:mfc/Helper/cart_provider.dart';
import 'package:mfc/Helper/db_helper.dart';
import 'package:provider/provider.dart';
import 'package:mfc/Utilities/ImageDecoder.dart';

class SearchResultsScreen extends StatelessWidget {
  final List<QueryDocumentSnapshot> searchResults;

  const SearchResultsScreen({Key? key, required this.searchResults}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: Text('Search Results', style: TextStyle(color: secondaryColor),),
        backgroundColor: Color(0xff570101),
      ),
      body: searchResults.isEmpty
          ? Center(
              child: Text(
                'No items found',
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              itemCount: searchResults.length,
              itemBuilder: (context, index) {
                final item = searchResults[index];
                return _buildItemCard(context, item);
              },
            ),
    );
  }

  Widget _buildItemCard(BuildContext context, QueryDocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final bool isPizza = data.containsKey('prices') || 
                        (data.containsKey('smallPrice') && data.containsKey('mediumPrice'));
    
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      elevation: 3,
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Row(
          children: [
            // Image
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: data['image'] != null && data['image'].isNotEmpty
                  ? Image.memory(
                      decodeImage(data['image']),
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    )
                  : Image.asset(
                      "assets/default-food.png",
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
            ),
            SizedBox(width: 15),
            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data['name'] ?? '',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    data['description'] ?? '',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 8),
                  if (isPizza) ...[
                    // Pizza prices
                    Text(
                      'Small: Rs. ${_getPizzaPrice(data, 'small')}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xff570101),
                      ),
                    ),
                    Text(
                      'Medium: Rs. ${_getPizzaPrice(data, 'medium')}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xff570101),
                      ),
                    ),
                    Text(
                      'Large: Rs. ${_getPizzaPrice(data, 'large')}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xff570101),
                      ),
                    ),
                    Text(
                      'Family: Rs. ${_getPizzaPrice(data, 'family')}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xff570101),
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: () => _showPizzaSizeDialog(context, data),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xff570101),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Text(
                            'Select Size',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ] else ...[
                    // Regular item price
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Rs. ${data['price']}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff570101),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () => _addToCart(context, data),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xff570101),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Text(
                            'Add to Cart',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getPizzaPrice(Map<String, dynamic> data, String size) {
    if (data.containsKey('prices')) {
      // New structure
      return (data['prices'][size] ?? '0').toString();
    } else {
      // Old structure
      return (data['${size}Price'] ?? '0').toString();
    }
  }

  void _showPizzaSizeDialog(BuildContext context, Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Select Pizza Size'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildSizeButton(context, item, 'Small', 'small'),
            _buildSizeButton(context, item, 'Medium', 'medium'),
            _buildSizeButton(context, item, 'Large', 'large'),
            _buildSizeButton(context, item, 'Family', 'family'),
          ],
        ),
      ),
    );
  }

  Widget _buildSizeButton(BuildContext context, Map<String, dynamic> item, String label, String size) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: ElevatedButton(
        onPressed: () {
          Navigator.pop(context); // Close dialog
          _addPizzaToCart(context, item, size);
          
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xff570101),
          minimumSize: Size(double.infinity, 40),
        ),
        child: Text('$label - Rs. ${_getPizzaPrice(item, size)}',style: TextStyle(color: secondaryColor),),
      ),
    );
  }

  void _addPizzaToCart(BuildContext context, Map<String, dynamic> item, String size) async {
    DBHelper dbHelper = DBHelper();
    double price = double.parse(_getPizzaPrice(item, size));
    
    final cart = Cart(
      id: DateTime.now().toString(),
      productName: "${item['name']} ($size)",
      initialPrice: price,
      productPrice: price,
      quantity: 1,
      image: item['image'] ?? '',
    );

    await dbHelper.insert(cart);
    
    if (context.mounted) {
      Provider.of<CartProvider>(context, listen: false).addTotalPrice(price);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Pizza added to cart'),
          duration: Duration(seconds: 2),
          backgroundColor: Color(0xff570101),
        ),
      );
    }
  }

  void _addToCart(BuildContext context, Map<String, dynamic> item) async {
    DBHelper dbHelper = DBHelper();
    double price = double.parse(item['price'].toString());
    
    final cart = Cart(
      id: DateTime.now().toString(),
      productName: item['name'] ?? '',
      initialPrice: price,
      productPrice: price,
      quantity: 1,
      image: item['image'] ?? '',
    );

    await dbHelper.insert(cart);
    
    if (context.mounted) {
      Provider.of<CartProvider>(context, listen: false).addTotalPrice(price);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Item added to cart'),
          duration: Duration(seconds: 2),
          backgroundColor: Color(0xff570101),
        ),
      );
    }
  }
} 