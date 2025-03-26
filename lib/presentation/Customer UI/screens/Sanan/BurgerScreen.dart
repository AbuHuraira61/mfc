import 'package:flutter/material.dart';
import 'package:mfc/presentation/Customer%20UI/Common/CustomCard.dart';

class BurgerScreen extends StatelessWidget {
  final List<Map<String, String>> burgers = List.generate(
    10,
    (index) => {
      "name": "Beef Burger",
      "price": "\$20",
      "image": "assets/burger.png",
    },
  );

  BurgerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFF570101),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {},
        ),
        title: Text("Burgers",
            style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(12),
        child: GridView.builder(
          itemCount: burgers.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.75,
          ),
          itemBuilder: (context, index) {
            return CustomCard(
              name: burgers[index]["name"]!,
              price: burgers[index]["price"]!,
              image: burgers[index]["image"]!,
              imageHeight: 80,
              imageWidth: 80,
            );
          },
        ),
      ),
    );
  }
}
