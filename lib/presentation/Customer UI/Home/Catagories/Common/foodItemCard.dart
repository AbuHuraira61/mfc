import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mfc/Utilities/ImageDecoder.dart';
import 'package:mfc/presentation/Customer%20UI/Home/Common/Singlepizza_screen.dart';

class FoodItemsCard extends StatefulWidget {
  final Map<String, dynamic> foodItems;

  const FoodItemsCard({Key? key, required this.foodItems}) : super(key: key);

  @override
  State<FoodItemsCard> createState() => _FoodItemsCardState();
}

class _FoodItemsCardState extends State<FoodItemsCard> {
  bool isFavorite = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    checkIfFavorite();
  }

  Future<void> checkIfFavorite() async {
    final user = _auth.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance
          .collection('favorites')
          .where('uid', isEqualTo: user.uid)
          .where('itemId', isEqualTo: widget.foodItems['id'])
          .get();
      
      setState(() {
        isFavorite = doc.docs.isNotEmpty;
      });
    }
  }

  Future<void> toggleFavorite() async {
    final user = _auth.currentUser;
    if (user == null) return;

    setState(() {
      isFavorite = !isFavorite;
    });

    if (isFavorite) {
      // Add to favorites using item's ID as document ID
      await FirebaseFirestore.instance
          .collection('favorites')
          .doc(widget.foodItems['id'])
          .set({
        'uid': user.uid,
        'itemId': widget.foodItems['id'],
        'name': widget.foodItems['name'],
        'image': widget.foodItems['image'],
        'price': widget.foodItems['price'],
        'description': widget.foodItems['description'],
        'timestamp': FieldValue.serverTimestamp(),
      });
    } else {
      // Remove from favorites using item's ID
      await FirebaseFirestore.instance
          .collection('favorites')
          .doc(widget.foodItems['id'])
          .delete();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedContainer(
          duration: Duration(milliseconds: 300),
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Color(0xff570101),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Spacer(),
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child:
                  widget.foodItems['image']!=null && widget.foodItems['image'].isNotEmpty?
                   Image.memory(decodeImage(widget.foodItems['image']),
    
    
                      fit: BoxFit.cover, height: 100, width: 100):
                       Image.asset(
                  "assets/default-food.png",
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
                ),
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.foodItems['name'],
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                    SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('\Rs.${widget.foodItems['price']}',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold)),
                        Icon(Icons.shopping_cart,
                            color: Colors.white, size: 24),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        Positioned(
          top: 5,
          right: 5,
          child: GestureDetector(
            onTap: toggleFavorite,
            child: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : Colors.white,
              size: 24,
            ),
          ),
        ),
      ],
    );
  }
}
