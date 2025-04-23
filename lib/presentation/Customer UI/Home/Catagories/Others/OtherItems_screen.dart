import 'package:flutter/material.dart';

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
            Tab(text: "Crispy Fries"),
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

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.all(10),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.8,
      ),
      itemCount: sampleFoods.length,
      itemBuilder: (context, index) {
        return OtherItemsCard(food: sampleFoods[index]);
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
      onTap: () {},
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
                    child: Image.asset(
                      "assets/largepizza.png",
                      width: 100,
                      height: 100,
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
