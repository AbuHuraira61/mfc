import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mfc/Utilities/ImageDecoder.dart';
import 'package:mfc/presentation/Customer%20UI/Home/Common/single_item_detail_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
        "description": doc["description"],
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
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SingleItemDetailScreen(singleBurger: foods[index]),
                  ),
                );
              },
              child: OtherItemsCard(food: foods[index]),
            );
          },
        );
      },
    );
  }
}

class OtherItemsCard extends StatefulWidget {
  final Map<String, dynamic> food;

  const OtherItemsCard({Key? key, required this.food}) : super(key: key);

  @override
  State<OtherItemsCard> createState() => _OtherItemsCardState();
}

class _OtherItemsCardState extends State<OtherItemsCard> {
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
          .where('itemId', isEqualTo: widget.food['id'])
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
          .doc(widget.food['id'])
          .set({
        'uid': user.uid,
        'itemId': widget.food['id'],
        'name': widget.food['name'],
        'image': widget.food['image'],
        'price': widget.food['price'],
        'description': widget.food['description'],
        'timestamp': FieldValue.serverTimestamp(),
      });
    } else {
      // Remove from favorites using item's ID
      await FirebaseFirestore.instance
          .collection('favorites')
          .doc(widget.food['id'])
          .delete();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
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
                widget.food['image']!=null && widget.food['image'].isNotEmpty?
                 Image.memory(decodeImage(widget.food['image']),
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
                      widget.food['name'] ?? "Food Item",
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
                          '\Rs.${widget.food['price']}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Icon(Icons.shopping_cart, color: Colors.white, size: 24),
                      ],
                    ),
                  ],
                ),
              ),
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
