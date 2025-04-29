import 'package:flutter/material.dart';
import 'package:mfc/Utilities/ImageDecoder.dart';
import 'package:mfc/presentation/Customer%20UI/Home/Common/Singlepizza_screen.dart';

class FoodItemsCard extends StatelessWidget {
  final Map<String, dynamic> foodItems;

  const FoodItemsCard({super.key, required this.foodItems});
  

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
                  foodItems['image']!=null && foodItems['image'].isNotEmpty?
                   Image.memory(decodeImage(foodItems['image']),
    
    
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
                    Text(foodItems['name'],
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                    SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('\$${foodItems['price']}',
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
          child: Icon(
            Icons.favorite_border,
            color: Colors.white,
            size: 24,
          ),
        ),
      ],
    );
  }
}
