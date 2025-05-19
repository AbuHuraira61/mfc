import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mfc/Chatbot/ChatbotScreeen.dart';
import 'package:mfc/Helper/cart_provider.dart';
import 'package:mfc/Helper/db_helper.dart';
import 'package:mfc/Models/cart_model.dart';
import 'package:mfc/auth/SplashScreen/splashscreen.dart';
import 'package:mfc/auth/UserProfile.dart';
import 'package:mfc/presentation/Customer%20UI/Home/Cart/Cart_screen.dart';
import 'package:mfc/presentation/Customer%20UI/Home/Catagories/Others/OtherItems_screen.dart';
import 'package:mfc/presentation/Customer%20UI/Home/Deals%20Screen/DealsList.dart';
import 'package:mfc/presentation/Customer%20UI/Home/Catagories/Pizza%20Screen/pizza_grid.dart';
import 'package:mfc/presentation/Customer%20UI/Home/Catagories/Burger%20Screen/burger_grid.dart';
import 'package:mfc/presentation/Customer%20UI/Favorite/FavouritePage.dart';
import 'package:mfc/presentation/Customer%20UI/Home/Search/search_results_screen.dart';
import 'package:mfc/presentation/Customer%20UI/Orders/Order%20Status/Orderstatus_screen.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:mfc/Utilities/ImageDecoder.dart';
import 'package:mfc/presentation/Customer%20UI/Home/Common/single_item_detail_screen.dart';
import 'package:mfc/presentation/Customer%20UI/Home/Common/Singlepizza_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: HomeScreen());
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  final List<Widget> _screens = [
    HomeContent(),
    FavouritePage(),
    OrderStatusScreen(),
    UserProfileScreen(),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
      _pageController.jumpToPage(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xff570101),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey[400],
        showSelectedLabels: true,
        showUnselectedLabels: true,
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        items: [
          _buildNavItem(Icons.home, "Home", 0),
          _buildNavItem(Icons.favorite, "Favorite", 1),
          _buildNavItem(Icons.shopping_bag_outlined, "Orders", 2),
          _buildNavItem(Icons.person, "Profile", 3),
        ],
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem(
      IconData icon, String label, int index) {
    bool isSelected = _currentIndex == index;
    return BottomNavigationBarItem(
      icon: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: Matrix4.translationValues(0, isSelected ? -4 : 0, 0),
        child: Icon(
          icon,
          size: isSelected ? 30 : 22,
        ),
      ),
      label: label,
    );
  }
}

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  HomeContentState createState() => HomeContentState();
}

class HomeContentState extends State<HomeContent> {
  int selectedCategoryIndex = -1;
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  bool _isLoggingOut = false;

  final List<Map<String, dynamic>> categories = [
    {'title': 'Pizza', 'image': 'assets/largepizza.png'},
    {'title': 'Burger', 'image': 'assets/beefburger.png'},
    {'title': 'Others', 'image': 'assets/platter.png'},
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _performSearch(String query) async {
    if (query.trim().isEmpty) return;

    setState(() => _isSearching = true);

    try {
      List<QueryDocumentSnapshot> results = [];

      // Search in Pizza collection
      var pizzaSnapshot = await FirebaseFirestore.instance
          .collection('food_items')
          .doc('Pizza')
          .collection('items')
          .get();

      results.addAll(pizzaSnapshot.docs.where((doc) {
        final data = doc.data() as Map<String, dynamic>;
        final name = (data['name'] ?? '').toString().toLowerCase();
        return name.contains(query.toLowerCase());
      }));

      // Search in Burger collection
      var burgerSnapshot = await FirebaseFirestore.instance
          .collection('food_items')
          .doc('Burger')
          .collection('items')
          .get();

      results.addAll(burgerSnapshot.docs.where((doc) {
        final data = doc.data() as Map<String, dynamic>;
        final name = (data['name'] ?? '').toString().toLowerCase();
        return name.contains(query.toLowerCase());
      }));

      // Search in Others collection
      var otherCategories = [
        'Fries',
        'Chicken Roll',
        'Hot Wings',
        'Pasta',
        'Sandwich',
        'Broast Chicken'
      ];

      for (var category in otherCategories) {
        var othersSnapshot = await FirebaseFirestore.instance
            .collection('food_items')
            .doc(category)
            .collection('items')
            .get();

        results.addAll(othersSnapshot.docs.where((doc) {
          final data = doc.data() as Map<String, dynamic>;
          final name = (data['name'] ?? '').toString().toLowerCase();
          return name.contains(query.toLowerCase());
        }));
      }

      // Search in Deals collection
      var dealTypes = [
        'One Person Deal',
        'Two Person Deals',
        'Student Deals',
        'Special Pizza Deals',
        'Family Deals',
        'Lunch Night Deals'
      ];

      for (var dealType in dealTypes) {
        var dealsSnapshot = await FirebaseFirestore.instance
            .collection('deals')
            .doc(dealType)
            .collection('deal')
            .get();

        results.addAll(dealsSnapshot.docs.where((doc) {
          final data = doc.data() as Map<String, dynamic>;
          final name = (data['name'] ?? '').toString().toLowerCase();
          return name.contains(query.toLowerCase());
        }));
      }

      print('Found ${results.length} total results');

      if (mounted) {
        setState(() => _isSearching = false);

        if (results.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('No items found matching "$query"'),
              backgroundColor: Colors.orange,
            ),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SearchResultsScreen(searchResults: results),
            ),
          );
        }
      }
    } catch (e) {
      print('Search error: $e');
      if (mounted) {
        setState(() => _isSearching = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error searching products: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            Container(
              color: Color(0xff570101),
              padding: EdgeInsets.only(
                  top: screenHeight * 0.05, bottom: screenHeight * 0.03),
              width: double.infinity,
              child: Column(
                children: [
                  CircleAvatar(
                    radius: screenWidth * 0.1,
                    backgroundImage: AssetImage('assets/gentle.png'),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  Text(
                    'Ali Hassan',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: screenWidth * 0.05,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.white,
                child: ListView(
                  children: [
                    _buildDrawerItem(Icons.local_offer, 'Deals', () {}),
                    _buildDrawerItem(Icons.list_alt, 'Orders', () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return OrderStatusScreen();
                        },
                      ));
                    }),
                    _buildDrawerItem(Icons.location_on, 'Address', () {}),
                    _buildDrawerItem(Icons.favorite, 'Favorite', () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => FavouritePage()),
                      );
                    }),
                    _buildDrawerItem(Icons.shopping_cart, 'Cart', () {}),
                    _buildDrawerItem(
                        Icons.article, 'Terms or Conditions', () {}),
                    _buildDrawerItem(Icons.chat, 'Chat with us', () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return ChatBotScreen();
                        },
                      ));
                    }),
                    _buildDrawerItem(Icons.logout, 'Log out', () async {
                      try {
                        setState(() => _isLoggingOut = true);

                        DBHelper dbHelper = DBHelper();
                        DocumentReference orderRef = FirebaseFirestore.instance
                            .collection("orders")
                            .doc();
                        List<Cart> cartItems = await dbHelper.getCartList();

                        // Clear the cart
                        for (var item in cartItems) {
                          await dbHelper.delete(item.id.toString());
                        }

                        String? getCurrentUserId() {
                          final FirebaseAuth auth = FirebaseAuth.instance;
                          final User? user = auth.currentUser;
                          if (user != null) {
                            String uid = user.uid;
                            print("Current User ID: $uid");
                            return uid;
                          } else {
                            print("No user is currently signed in.");
                            return null;
                          }
                        }

                        String? userId = getCurrentUserId();
                        if (userId != null) {
                          DocumentReference userRef = FirebaseFirestore.instance
                              .collection("users")
                              .doc(userId);
                          await userRef.set({
                            "orderId": FieldValue.arrayUnion([orderRef.id]),
                          }, SetOptions(merge: true));
                        }

                        if (mounted) {
                          Provider.of<CartProvider>(context, listen: false)
                              .clearCartData();
                        }

                        await FirebaseAuth.instance.signOut();

                        if (mounted) {
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (context) {
                            return SplashScreen();
                          }));
                        }
                      } catch (e) {
                        print("Logout error: $e");
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Error during logout: $e'),
                              backgroundColor: Colors.red,
                            ),
                          );
                          setState(() => _isLoggingOut = false);
                        }
                      }
                    }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: screenHeight * 0.2,
            floating: false,
            pinned: false,
            backgroundColor: Color(0xff570101),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
            ),
            leading: Builder(
              builder: (context) => IconButton(
                icon: Icon(Icons.menu,
                    color: Colors.white, size: screenWidth * 0.07),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              ),
            ),
            flexibleSpace: Stack(
              children: [
                Positioned(
                  top: screenHeight * 0.14,
                  left: screenWidth * 0.5 - (screenWidth * 0.45),
                  child: Container(
                    width: screenWidth * 0.9,
                    height: screenHeight * 0.07,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search products...',
                        prefixIcon: Icon(Icons.search, color: Colors.grey),
                        suffixIcon: _isSearching
                            ? Padding(
                                padding: EdgeInsets.all(10),
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Color(0xff570101),
                                ),
                              )
                            : _searchController.text.isNotEmpty
                                ? IconButton(
                                    icon: Icon(Icons.clear),
                                    onPressed: () {
                                      _searchController.clear();
                                      setState(() {});
                                    },
                                  )
                                : null,
                        border: InputBorder.none,
                        contentPadding:
                            EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                      ),
                      onSubmitted: _performSearch,
                      textInputAction: TextInputAction.search,
                      onChanged: (value) => setState(() {}),
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.shopping_cart,
                    color: Colors.white, size: screenWidth * 0.07),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => CartScreen()));
                },
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(screenWidth * 0.04),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('Categories', screenWidth),
                  SizedBox(height: screenHeight * 0.015),
                  CategorySection(
                    categories: categories,
                    selectedIndex: selectedCategoryIndex,
                    onCategorySelected: (index) {
                      setState(() {
                        selectedCategoryIndex = index;
                      });
                    },
                  ),
                  SizedBox(height: screenHeight * 0.03),
                  _buildSectionTitle('Deals and Discounts', screenWidth),
                  SizedBox(height: screenHeight * 0.015),
                  SliderSection(),
                  SizedBox(height: screenHeight * 0.03),
                  _buildSectionTitle('Popular', screenWidth),
                  SizedBox(height: screenHeight * 0.015),
                  PopularSection(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, VoidCallback onTap) {
    if (title == 'Log out' && _isLoggingOut) {
      return ListTile(
        leading: Icon(icon, color: Colors.black),
        title: Row(
          children: [
            Text(title),
            SizedBox(width: 10),
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xff570101)),
              ),
            ),
          ],
        ),
        enabled: false,
      );
    }
    return ListTile(
      leading: Icon(icon, color: Colors.black),
      title: Text(title),
      onTap: onTap,
    );
  }

  Widget _buildSectionTitle(String title, double screenWidth) {
    return Text(
      title,
      style:
          TextStyle(fontSize: screenWidth * 0.05, fontWeight: FontWeight.bold),
    );
  }
}

class CategorySection extends StatelessWidget {
  final List<Map<String, dynamic>> categories;
  final int selectedIndex;
  final Function(int) onCategorySelected;

  const CategorySection({
    super.key,
    required this.categories,
    required this.selectedIndex,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: categories.asMap().entries.map((entry) {
        int index = entry.key;
        var category = entry.value;

        double imageSize =
            (index == 0 || index == categories.length - 1) ? 60 : 50;

        return Column(
          children: [
            GestureDetector(
              onTap: () {
                onCategorySelected(index);
                // Navigate using Navigator
                if (category['title'] == "Pizza") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PizzaGrid()),
                  );
                } else if (category['title'] == "Burger") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BurgerGrid()),
                  );
                } else if (category['title'] == "Others") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => OtherItemsScreen()),
                  );
                }
              },
              child: Container(
                width: 75,
                height: 75,
                decoration: BoxDecoration(
                  color: selectedIndex == index
                      ? Color(0xff570101)
                      : Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Image.asset(category['image'], height: imageSize),
                ),
              ),
            ),
            SizedBox(height: 5),
            Text(
              category['title'],
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
}

class SliderSection extends StatefulWidget {
  const SliderSection({super.key});

  @override
  State<SliderSection> createState() => _SliderSectionState();
}

class _SliderSectionState extends State<SliderSection> {
  List<Map<String, dynamic>> imageList = [
    {
      "id": 1,
      "image_path": 'assets/oneperson.png',
      "route": DealsList(
        dealName: 'One Person Deal',
      )
    },
    {
      "id": 2,
      "image_path": 'assets/twoperson.png',
      "route": DealsList(dealName: 'Two Person Deals')
    },
    {
      "id": 3,
      "image_path": 'assets/student.png',
      "route": DealsList(dealName: 'Student Deals')
    },
    {
      "id": 4,
      "image_path": 'assets/pizzadeal.png',
      "route": DealsList(dealName: 'Special Pizza Deals')
    },
    {
      "id": 5,
      "image_path": 'assets/familydeals.png',
      "route": DealsList(dealName: 'Family Deals')
    },
    {
      "id": 6,
      "image_path": 'assets/midnight.png',
      "route": DealsList(dealName: 'Lunch & Night Deals')
    },
  ];

  final CarouselSliderController carouselController =
      CarouselSliderController();
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Stack(
        children: [
          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => imageList[currentIndex]['route']));
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CarouselSlider.builder(
                itemCount: imageList.length,
                itemBuilder: (context, index, realIndex) {
                  return Image.asset(
                    imageList[index]['image_path'],
                    fit: BoxFit.cover,
                    width: double.infinity,
                  );
                },
                carouselController: carouselController,
                options: CarouselOptions(
                  scrollPhysics: const BouncingScrollPhysics(),
                  autoPlay: true,
                  aspectRatio: 2,
                  viewportFraction: 1,
                  onPageChanged: (index, reason) {
                    setState(() {
                      currentIndex = index;
                    });
                  },
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 10,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: imageList.asMap().entries.map((entry) {
                return GestureDetector(
                  onTap: () => carouselController.jumpToPage(entry.key),
                  child: Container(
                    width: currentIndex == entry.key ? 17 : 7,
                    height: 7.0,
                    margin: const EdgeInsets.symmetric(horizontal: 3.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color:
                          currentIndex == entry.key ? Colors.red : Colors.black,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    ]);
  }
}

class PopularSection extends StatelessWidget {
  const PopularSection({super.key});

  Future<List<Map<String, dynamic>>> _fetchPopularItems() async {
    try {
      List<Map<String, dynamic>> finalItems = [];
      var collections = [
        'Pizza',
        'Burger',
        'Fries',
        'Chicken Roll',
        'Hot Wings',
        'Pasta',
        'Sandwich',
        'Broast Chicken'
      ];

      // First try to get items with order count
      var ordersSnapshot =
          await FirebaseFirestore.instance.collection('orders').get();

      // Create a map to count item occurrences
      Map<String, int> itemOrderCount = {};

      // Count occurrences of each item in orders
      for (var order in ordersSnapshot.docs) {
        var items = order.data()['items'] as List<dynamic>?;
        if (items != null) {
          for (var item in items) {
            String itemId = item['id'];
            itemOrderCount[itemId] = (itemOrderCount[itemId] ?? 0) + 1;
          }
        }
      }

      // If we have ordered items, get them first
      if (itemOrderCount.isNotEmpty) {
        // Sort items by order count
        var sortedItems = itemOrderCount.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value));

        // Get top item IDs
        var topItemIds = sortedItems.map((e) => e.key).toList();

        // Fetch the actual item details
        for (var collection in collections) {
          if (finalItems.length >= 4) break;

          var snapshot = await FirebaseFirestore.instance
              .collection('food_items')
              .doc(collection)
              .collection('items')
              .where(FieldPath.documentId, whereIn: topItemIds)
              .get();

          finalItems.addAll(snapshot.docs.map(
              (doc) => {...doc.data(), 'id': doc.id, 'category': collection}));
        }
      }

      // If we don't have enough items from orders, get random items to fill up to 4
      if (finalItems.length < 4) {
        for (var collection in collections) {
          if (finalItems.length >= 4) break;

          var snapshot = await FirebaseFirestore.instance
              .collection('food_items')
              .doc(collection)
              .collection('items')
              .get();

          var availableItems = snapshot.docs
              .where((doc) => !finalItems.any((item) => item['id'] == doc.id))
              .map((doc) =>
                  {...doc.data(), 'id': doc.id, 'category': collection})
              .toList();

          // Shuffle to get random items
          availableItems.shuffle();

          // Add items until we have 4 or run out of items
          finalItems.addAll(availableItems.take(4 - finalItems.length));
        }
      }

      // Take exactly 4 items
      return finalItems.take(4).toList();
    } catch (e) {
      print('Error fetching popular items: $e');

      // If there's an error, try to get just random items
      try {
        List<Map<String, dynamic>> randomItems = [];
        var collections = [
          'Pizza',
          'Burger',
          'Fries',
          'Chicken Roll',
          'Hot Wings',
          'Pasta',
          'Sandwich',
          'Broast Chicken'
        ];

        for (var collection in collections) {
          if (randomItems.length >= 4) break;

          var snapshot = await FirebaseFirestore.instance
              .collection('food_items')
              .doc(collection)
              .collection('items')
              .get();

          var items = snapshot.docs
              .map((doc) =>
                  {...doc.data(), 'id': doc.id, 'category': collection})
              .toList();

          items.shuffle();
          randomItems.addAll(items.take(4 - randomItems.length));
        }

        return randomItems.take(4).toList();
      } catch (e) {
        print('Error fetching random items: $e');
        return [];
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _fetchPopularItems(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildShimmerLoading();
        }

        if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No items available'));
        }

        final items = snapshot.data!;
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: PopularItem(
                    items[0]['name'],
                    _getItemPrice(items[0]),
                    items[0]['image'],
                    itemData: items[0],
                  ),
                ),
                SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                Expanded(
                  child: PopularItem(
                    items[1]['name'],
                    _getItemPrice(items[1]),
                    items[1]['image'],
                    itemData: items[1],
                  ),
                ),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.width * 0.04),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: PopularItem(
                    items[2]['name'],
                    _getItemPrice(items[2]),
                    items[2]['image'],
                    itemData: items[2],
                  ),
                ),
                SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                Expanded(
                  child: PopularItem(
                    items[3]['name'],
                    _getItemPrice(items[3]),
                    items[3]['image'],
                    itemData: items[3],
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  // Helper method to get item price based on item type
  double _getItemPrice(Map<String, dynamic> item) {
    try {
      // For pizza items with multiple prices
      if (item.containsKey('prices')) {
        // Get the smallest price from available sizes
        var prices = item['prices'] as Map<String, dynamic>;
        return prices.values
            .map((price) => double.tryParse(price.toString()) ?? 0.0)
            .reduce((a, b) => a < b ? a : b);
      }
      // For pizza items with old price structure
      else if (item.containsKey('smallPrice')) {
        return double.tryParse(item['smallPrice'].toString()) ?? 0.0;
      }
      // For regular items with single price
      else if (item.containsKey('price')) {
        return double.tryParse(item['price'].toString()) ?? 0.0;
      }
      // Default price if no price found
      return 0.0;
    } catch (e) {
      print('Error parsing price for item ${item['name']}: $e');
      return 0.0;
    }
  }

  Widget _buildShimmerLoading() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(child: _buildShimmerItem()),
              SizedBox(width: 8),
              Expanded(child: _buildShimmerItem()),
            ],
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(child: _buildShimmerItem()),
              SizedBox(width: 8),
              Expanded(child: _buildShimmerItem()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerItem() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
    );
  }
}

class PopularItem extends StatelessWidget {
  final String name;
  final double price;
  final String? image;
  final Map<String, dynamic> itemData;

  const PopularItem(
    this.name,
    this.price,
    this.image, {
    super.key,
    required this.itemData,
  });

  void _navigateToDetail(BuildContext context) {
    // Get the category from itemData
    String category = itemData['category'] ?? '';

    if (category.toLowerCase() == 'pizza') {
      // For Pizza items, use SinglePizzaScreen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SinglePizzaScreen(singlePizza: itemData),
        ),
      );
    } else {
      // For all other items (Burger, Others), use SingleItemDetailScreen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SingleItemDetailScreen(singleBurger: itemData),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    // Calculate responsive dimensions
    double cardHeight = screenHeight * 0.25;
    double cardPadding = screenWidth * 0.02;
    double imageSize = screenWidth * 0.25;
    double iconSize = screenWidth * 0.055;

    return GestureDetector(
      onTap: () => _navigateToDetail(context),
      child: Container(
        width: double.infinity,
        height: cardHeight,
        padding: EdgeInsets.all(cardPadding),
        decoration: BoxDecoration(
          color: Color(0xff570101),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Stack(
          children: [
            Column(
              children: [
                // Image Container
                Expanded(
                  flex: 3,
                  child: Center(
                    child: Container(
                      width: imageSize,
                      height: imageSize,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: image != null && image!.isNotEmpty
                            ? Image.memory(
                                decodeImage(image!),
                                fit: BoxFit.cover,
                              )
                            : Image.asset(
                                "assets/default-food.png",
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                  ),
                ),
                // Text Content
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: cardPadding,
                      vertical: cardPadding * 0.5,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Product Name
                        Text(
                          name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: screenWidth * 0.035,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        // Price
                        Text(
                          'Rs. ${price.toStringAsFixed(0)}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: screenWidth * 0.032,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            // Cart Icon
            Positioned(
              bottom: 0,
              right: 0,
              child: IconButton(
                icon: Icon(
                  Icons.shopping_cart,
                  color: Colors.white,
                  size: iconSize,
                ),
                onPressed: () {
                  // Handle add to cart
                },
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
