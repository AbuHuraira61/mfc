import 'package:flutter/material.dart';
import 'package:mfc/Constants/colors.dart';
import 'package:mfc/screens/Sanan/favouritpage.dart';
import 'package:mfc/screens/burgerpage.dart';
import 'package:mfc/screens/singleburger_screen.dart';
import 'package:mfc/screens/singlepizza_screen.dart';
import 'orderstatus_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: HomeScreen());
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedCategoryIndex = -1;

  final List<Map<String, dynamic>> categories = [
    {'title': 'All', 'image': 'assets/food-banner.png'},
    {'title': 'Pizza', 'image': 'assets/largepizza.png'},
    {'title': 'Burger', 'image': 'assets/burger.png'},
    {'title': 'Deserts', 'image': 'assets/desert.png'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            Container(
              color: Color(0xff570101), // Dark red background for profile section
              padding: EdgeInsets.only(top: 40, bottom: 20),
              width: double.infinity,
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage('assets/gentle.webp'),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Ali Hassan',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.white, // White background for menu items
                child: ListView(
                  children: [
                    ListTile(
                      leading: Icon(Icons.local_offer, color: Colors.black),
                      title: Text('Deals'),
                      onTap: () {},
                    ),
                    ListTile(
                      leading: Icon(Icons.list_alt, color: Colors.black),
                      title: Text('Orders'),
                      onTap: () {},
                    ),
                    ListTile(
                      leading: Icon(Icons.location_on, color: Colors.black),
                      title: Text('Address'),
                      onTap: () {},
                    ),
                    ListTile(
                      leading: Icon(Icons.favorite, color: Colors.black),
                      title: Text('Favorite'),
                      onTap: () {},
                    ),
                    ListTile(
                      leading: Icon(Icons.shopping_cart, color: Colors.black),
                      title: Text('Cart'),
                      onTap: () {},
                    ),
                    ListTile(
                      leading: Icon(Icons.article, color: Colors.black),
                      title: Text('Terms or Conditions'),
                      onTap: () {},
                    ),
                    ListTile(
                      leading: Icon(Icons.chat, color: Colors.black),
                      title: Text('Chat with us'),
                      onTap: () {},
                    ),
                    ListTile(
                      leading: Icon(Icons.logout, color: Colors.black),
                      title: Text('Log out'),
                      onTap: () {},
                    ),
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
            expandedHeight: 150, // ✅ Increased height by 20px
            floating: false,
            pinned: false,
            backgroundColor: Color(0xff570101),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
            ),
            leading: Builder(
              builder: (context) => IconButton(
                icon: Icon(Icons.menu, color: Colors.white, size: 27), // ✅ Increased size
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              ),
            ),
            flexibleSpace: Stack(
              children: [
                Positioned(
                  top: 110, // ✅ Added 10px extra margin (originally 70, now 80)
                  left: MediaQuery.of(context).size.width * 0.5 - 168, // Centers the search bar
                  child: Container(
                    width: 336,
                    height: 53,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search',
                        prefixIcon: Icon(Icons.search, color: Colors.grey),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 15),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.shopping_cart, color: Colors.white, size: 27), // ✅ Increased size
                onPressed: () {},
              ),
            ],
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Categories',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  CategorySection(
                    categories: categories,
                    selectedIndex: selectedCategoryIndex,
                    onCategorySelected: (index) {
                      setState(() {
                        selectedCategoryIndex = index;
                      });
                    },
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Promotion',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  PromotionSection(),
                  SizedBox(height: 20),
                  Text(
                    'Popular',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  PopularSection(),
                ],
              ),
            ),
          ),
        ],
      ),

      bottomNavigationBar: BottomNavBar(selectedIndex: 0),
    );
  }
}

class CategorySection extends StatelessWidget {
  final List<Map<String, dynamic>> categories;
  final int selectedIndex;
  final Function(int) onCategorySelected;

  CategorySection({
    required this.categories,
    required this.selectedIndex,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children:
      categories.asMap().entries.map((entry) {
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
                if (category['title'] == "Burger") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BurgerScreen()),
                  );
                } else if (category['title'] == "Pizza") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BurgerScreen()),
                  );
                }
              },
              child: Container(
                width: 75,
                height: 75,
                decoration: BoxDecoration(
                  color:
                  selectedIndex == index
                      ? Color(0xff570101)
                      : Colors.grey[300],
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

class PromotionSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        12,
        15,
        12,
        15,
      ), // Added 15 padding from top and bottom
      decoration: BoxDecoration(
        color: primaryColor, // Adjusted red shade
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 6),
              Text(
                "Today's Offer",
                style: TextStyle(
                  color: secondaryColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 4),
              Text(
                "Free Box of Fries",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 6),
              Text(
                "and Free Home Delivery\non all Orders above 150\$.",
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: 6),
            ],
          ),
          Positioned(
            top: -52,
            left: 160,
            child: Image.asset('assets/fries.png', height: 100),
          ),
        ],
      ),
    );
  }
}

class PopularSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: PopularItem(
                'Beef Burger',
                20,
                'assets/burger.png',
                imageHeight: 180,
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: PopularItem('Special Pizza', 32, 'assets/largepizza.png'),
            ),
          ],
        ),
        SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: PopularItem('Beef Burger', 20, 'assets/burger.png'),
            ),
            SizedBox(width: 10),
            Expanded(
              child: PopularItem('Special Pizza', 32, 'assets/largepizza.png'),
            ),
          ],
        ),
      ],
    );
  }
}

class PopularItem extends StatelessWidget {
  final String name;
  final int price;
  final String imagePath;
  final double? imageHeight; // Optional image height parameter

  PopularItem(this.name, this.price, this.imagePath, {this.imageHeight});

  @override
  Widget build(BuildContext context) {
    double defaultHeight = 110; // Default height

    // Set default size based on food type
    if (name.toLowerCase().contains('burger')) {
      defaultHeight = 150;
    } else if (name.toLowerCase().contains('pizza')) {
      defaultHeight = 110;
    }

    return GestureDetector(
      onTap: () {
        // Navigate based on item name
        if (name.toLowerCase().contains('burger')) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SingleBurgerScreen()),
          );
        } else if (name.toLowerCase().contains('pizza')) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SinglePizzaScreen()),
          );
        }
      },
      child: Container(
        width: double.infinity,
        height: 200,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Color(0xff570101),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start, // Align text to left
              children: [
                SizedBox(height: 5),
                SizedBox(
                  height: 110,
                  child: Center(
                    child: Image.asset(
                      imagePath,
                      height: imageHeight ?? defaultHeight, // Use provided height or default
                    ),
                  ),
                ),
                SizedBox(height: 5),
                Text(name, style: TextStyle(color: Colors.white, fontSize: 16)),
                Text(
                  '\$$price',
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
              ],
            ),
            Positioned(
              top: -10,
              right: -5,
              child: IconButton(
                icon: Icon(Icons.favorite_border, color: Colors.white),
                onPressed: () {
                  Navigator.pushNamed(context, '/favorites', arguments: {'name': name});
                },
              ),
            ),
            Positioned(
              bottom: -5,
              right: -5,
              child: IconButton(
                icon: Icon(Icons.shopping_cart, color: Colors.white),
                onPressed: () {
                  Navigator.pushNamed(context, '/cart', arguments: {'name': name, 'price': price});
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class BottomNavBar extends StatefulWidget {
  final int selectedIndex;

  const BottomNavBar({Key? key, required this.selectedIndex}) : super(key: key);

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.selectedIndex; // Initialize with passed value
  }

  void _onItemTapped(int index) {
    if (index == _currentIndex) return;

    setState(() {
      _currentIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
        break;
      case 1:
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => FavouritePage()),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => OrderStatusScreen()),
        );
        break;
      case 3:
      // Future: Add navigation for Favorite, Cart, Profile
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: const Color(0xff570101),
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      currentIndex: _currentIndex,
      onTap: _onItemTapped,
      items: [
        _buildNavItem(Icons.home, 0),
        _buildNavItem(Icons.favorite, 1),
        _buildNavItem(Icons.shopping_basket, 2),
        _buildNavItem(Icons.person, 3),
      ],
    );
  }

  BottomNavigationBarItem _buildNavItem(IconData icon, int index) {
    bool isSelected = _currentIndex == index;
    return BottomNavigationBarItem(
      icon: AnimatedContainer(
        duration: const Duration(milliseconds: 20),
        transform: Matrix4.translationValues(0, isSelected ? -4 : 0, 0),
        child: Icon(
          icon,
          size: isSelected ? 32 : 24, // Increase size by 4 when selected
        ),
      ),
      label: '',
    );
  }
}
