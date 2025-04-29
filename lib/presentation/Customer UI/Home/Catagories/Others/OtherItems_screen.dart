import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mfc/Utilities/ImageDecoder.dart';
import 'package:mfc/presentation/Customer%20UI/Home/Common/Singleburger_screen.dart';

class OtherItemsScreen extends StatefulWidget {
  @override
  _OtherItemsScreenState createState() => _OtherItemsScreenState();
}

class _OtherItemsScreenState extends State<OtherItemsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Other Items Screen",
            style: TextStyle(
              color: Colors.white,
            )),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Color(0xff570101),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          isScrollable: true,
          labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          tabs: [
            Tab(text: "Fries"),
            Tab(text: "Chicken Roll"),
            Tab(text: "Hot Wings"),
            Tab(text: "Pasta"),
            Tab(text: "Sandwich"),
            Tab(text: "Broast Chicken"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          FriesScreen(),
          ChickenRollScreen(),
          HotWingsScreen(),
          PastaScreen(),
          SandwichScreen(),
          BroastChickenScreen(),
        ],
      ),
    );
  }
}



class FriesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OtherItemsList(category: "Fries");
  }
}

class ChickenRollScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OtherItemsList(category: "Chicken Roll");
  }
}

class HotWingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OtherItemsList(category: "Hot Wings");
  }
}

class PastaScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OtherItemsList(category: "Pasta");
  }
}

class SandwichScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OtherItemsList(category: "Sandwich");
  }
}

class BroastChickenScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OtherItemsList(category: "Broast Chicken");
  }
}

class OtherItemsList extends StatelessWidget {
  final String category;

  OtherItemsList({required this.category});

  final List<Map<String, dynamic>> sampleFoods = [
    {"name": "Crispy Fries", "price": "5.99"},
    {"name": "Cheese Roll", "price": "6.49"},
    {"name": "Spicy Wings", "price": "7.99"},
    {"name": "Pasta Alfredo", "price": "8.99"},
    {"name": "Grilled Sandwich", "price": "6.99"},
    {"name": "Broast Chicken", "price": "9.99"},
    {"name": "Spicy Wings", "price": "7.99"},
    {"name": "Pasta Alfredo", "price": "8.99"},
    {"name": "Grilled Sandwich", "price": "6.99"},
    {"name": "Broast Chicken", "price": "9.99"},
  ];

  Future<List<Map<String, dynamic>>> fetchBurgerData() async {
    // ✅ Use await to wait for data before accessing .docs
    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
        .collection("food_items")
        .doc(category)
        .collection("items") 
        .get();

    // ✅ Properly return the list after mapping
    return snapshot.docs.map((doc) {
      return {
        "id": doc.id,
        "name": doc["name"],
        "image": doc["image"],
        "price": doc["price"],
        "description":doc["description"],
      };
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: fetchBurgerData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No items available'));
        }
        var foods = snapshot.data!;

        return GridView.builder(
          padding: EdgeInsets.all(10),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.7,
          ),
          itemCount: foods.length,
          itemBuilder: (context, index) {
            return OtherItemsCard(food: foods[index]);
          },
        );
      },
    );
    
    
    
   
  }
}

class OtherItemsCard extends StatelessWidget {
  final Map<String, dynamic> food;

  OtherItemsCard({required this.food});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Handle item tap
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SingleBurgerScreen(singleBurger: food),
          ),
        );
      },
      child: Stack(
        children: [
          Container(
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
                  food['image']!=null && food['image'].isNotEmpty?
                   Image.memory(decodeImage(food['image']),
    
    
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
                      Text(
                        food['name'] ?? "Food Item",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '\$${food['price'] ?? "--"}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Icon(
                            Icons.shopping_cart,
                            color: Colors.white,
                            size: 24,
                          ),
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
      ),
    );
  }
}
