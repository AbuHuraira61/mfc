import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mfc/presentation/Customer%20UI/Home/Catagories/Common/foodItemCard.dart';

class BurgerScreen extends StatefulWidget {
 
  @override
  State<BurgerScreen> createState() => _BurgerScreenState();
}

class _BurgerScreenState extends State<BurgerScreen> {
  Future<List<Map<String, dynamic>>> fetchBurgerData() async {
    // ✅ Use await to wait for data before accessing .docs
    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
        .collection("food_items")
        .doc("Burger")
        .collection("items") 
        .get();

    // ✅ Properly return the list after mapping
    return snapshot.docs.map((doc) {
      return {
        "id": doc.id,
        "name": doc["name"],
        "image": doc["image"],
        "prices": doc["price"],
        "description":doc["description"],
      };
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        backgroundColor: Color(0xFF570101),

        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: Text(
          "Burger Screen",
          style: TextStyle(color: Colors.white),
        ),
       
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchBurgerData(),
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting){
            return Center(child: CircularProgressIndicator(),);
          }
          if(snapshot.hasData || snapshot.data!.isEmpty){
            return Center(child: Text('Burgers aare not avialable'),);
          }
          var burgers = snapshot.data;

          return GridView.builder(
      padding: EdgeInsets.all(10),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.8,
      ),
      itemCount: burgers!.length,
      itemBuilder: (context, index) {
        return FoodItemsCard(foodItems: burgers![index]);
      },
    );
        }, )


      // GridView.builder(
      //   padding: EdgeInsets.all(10),
      //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      //     crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
      //     crossAxisSpacing: 10,
      //     mainAxisSpacing: 10,
      //     childAspectRatio: 0.8,
      //   ),
      //   itemCount: burgers.length,
      //   itemBuilder: (context, index) {
      //     return GestureDetector(
      //       onTap: () {
      //         Navigator.push(
      //           context,
      //           MaterialPageRoute(
      //             builder: (context) => SingleBurgerScreen(),
      //           ),
      //         );
      //       },
      //       child: FoodItemsCard(foodItems: burgers[index]),
      //     );
      //   },
      // ),
    );
  }
}

