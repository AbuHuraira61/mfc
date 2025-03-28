import 'package:flutter/material.dart';
import 'package:mfc/presentation/Customer%20UI/screens/Home/Common/Singlepizza_screen.dart';

class PizzaScreen extends StatefulWidget {
  @override
  _PizzaScreenState createState() => _PizzaScreenState();
}

class _PizzaScreenState extends State<PizzaScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Pizza Screen",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Color(0xff570101),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: [
            Tab(text: "New"),
            Tab(text: "Special"),
            Tab(text: "Standard"),
            Tab(text: "Premium"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          PizzaList(category: "New Addition"),
          PizzaList(category: "Special Pizzas"),
          PizzaList(category: "Standard Pizzas"),
          PizzaList(category: "Premium Pizzas"),
        ],
      ),
    );
  }
}

class PizzaList extends StatelessWidget {
  final String category;

  PizzaList({required this.category});

  final List<Map<String, dynamic>> pizzas = List.generate(
      12,
      (index) => {
            "name": "Pizza ${index + 1}",
            "price": 20 + index,
            "image": "assets/largepizza.png"
          });

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
      itemCount: pizzas.length,
      itemBuilder: (context, index) {
        return PizzaCard(pizza: pizzas[index]);
      },
    );
  }
}

class PizzaCard extends StatelessWidget {
  final Map<String, dynamic> pizza;

  PizzaCard({required this.pizza});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SinglePizzaScreen(), // No arguments passed
          ),
        );
      },
      child: Stack(
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
                    child: Image.asset(pizza['image'],
                        fit: BoxFit.cover, height: 100, width: 100),
                  ),
                ),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(pizza['name'],
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold)),
                      SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('\$${pizza['price']}',
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
      ),
    );
  }
}
