import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mfc/Utilities/ImageDecoder.dart';
import 'package:mfc/presentation/Customer%20UI/Home/Common/Singlepizza_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PizzaGrid extends StatefulWidget {
  @override
  _PizzaGridState createState() => _PizzaGridState();
}

class _PizzaGridState extends State<PizzaGrid>
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
            Tab(text: "Standard"),
            Tab(text: "Premium"),
            Tab(text: "New"),
            Tab(text: "Matka"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          PizzaList(category: "Standard"),
          PizzaList(category: "Premium"),
          PizzaList(category: "New Addition"),
          PizzaList(category: "Matka Pizza"),
        ],
      ),
    );
  }
}

class PizzaList extends StatefulWidget {
  final String category;

  PizzaList({required this.category});

  @override
  State<PizzaList> createState() => _PizzaListState();
}

class _PizzaListState extends State<PizzaList> {
 Future<List<Map<String, dynamic>>> fetchPizzaData() async {
    // ✅ Use await to wait for data before accessing .docs
    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
        .collection("food_items")
        .doc("Pizza")
        .collection("items")
        .where("pizzaType", isEqualTo: widget.category)
        .get();

    // ✅ Properly return the list after mapping
    return snapshot.docs.map((doc) {
      return {
        "id": doc.id,
        "name": doc["name"],
        "image": doc["image"],
        "prices": doc["prices"],
        "description": doc["description"],
      };
    }).toList();
  }

  @override
  Widget build(BuildContext context) {

   return FutureBuilder<List<Map<String, dynamic>>>(
    future: fetchPizzaData(), 
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting){
        return Center(child: CircularProgressIndicator(),);
      }
      if(!snapshot.hasData || snapshot.data!.isEmpty){

        return Center(child: Text("No ${widget.category} Pizzas Available!"),);
      }
      
      var pizzas = snapshot.data!;

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
        Map<String, dynamic> pizzaData = {...pizzas[index]};
        // Don't simplify the price structure
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SinglePizzaScreen(singlePizza: pizzaData),
              ),
            );
          },
          child: PizzaCard(pizza: pizzaData),
        );
      },
    );
    },);
  }
}

class PizzaCard extends StatefulWidget {
  final Map<String, dynamic> pizza;

  const PizzaCard({Key? key, required this.pizza}) : super(key: key);

  @override
  State<PizzaCard> createState() => _PizzaCardState();
}

class _PizzaCardState extends State<PizzaCard> {
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
          .where('itemId', isEqualTo: widget.pizza['id'])
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
          .doc(widget.pizza['id'])
          .set({
        'uid': user.uid,
        'itemId': widget.pizza['id'],
        'name': widget.pizza['name'],
        'image': widget.pizza['image'],
        'prices': widget.pizza['prices'], // Save all price categories
        'description': widget.pizza['description'],
        'timestamp': FieldValue.serverTimestamp(),
      });
    } else {
      // Remove from favorites using item's ID
      await FirebaseFirestore.instance
          .collection('favorites')
          .doc(widget.pizza['id'])
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
                  widget.pizza['image']!=null && widget.pizza['image'].isNotEmpty?
                   Image.memory(decodeImage(widget.pizza['image']),
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
                    Text(widget.pizza['name'],
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                    SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('\$${widget.pizza['prices']['small']}',
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
