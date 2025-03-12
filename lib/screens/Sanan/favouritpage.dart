import 'package:flutter/material.dart';
import 'package:mfc/screens/Sanan/signup_login_page.dart';

class FavouritePage extends StatelessWidget {
  final List<Map<String, dynamic>> favoriteItems = List.generate(
    10,
        (index) => {
      "name": "Pizza",
      "description": "Spicy pizza gladiola is a fan",
      "price": "RS 1050.00",
      "image": "assets/pizza-pic.png",
      "quantity": 2,
    },
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Favorite Page", style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white)),
        backgroundColor: Color(0xFF6A0202),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Your Favorite Food is here",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: favoriteItems.length,
                itemBuilder: (context, index) {
                  final item = favoriteItems[index];
                  return Container(
                    margin: EdgeInsets.only(bottom: 10),
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      //color: Color(0xFF570101),
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFF570101), // Dark Red
                          Color(0xFF750202), // Slightly lighter red
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),

                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            item["image"],
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item["name"],
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                item["description"],
                                style: TextStyle(color: Colors.white70, fontSize: 12),
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 6),
                              Text(
                                item["price"],
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,

                          children: [
                            SizedBox(width: 5,),
                            GestureDetector(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=> LoginPage()));
                                },
                                child: Icon(Icons.delete_outline, color: Colors.white)),
                            SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                    onTap: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=> LoginPage()));
                                    },
                                    child: Icon(Icons.add_circle, color: Colors.white)),
                                SizedBox(width: 5),
                                Text(
                                  item["quantity"].toString(),
                                  style: TextStyle(
                                      color: Colors.white, fontWeight: FontWeight.bold),
                                ),
                                SizedBox(width: 5),
                                GestureDetector(
                                    onTap: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=> LoginPage()));
                                    },
                                    child: Icon(Icons.remove_circle, color: Colors.white)),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}