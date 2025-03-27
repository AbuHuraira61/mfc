import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mfc/presentation/Customer%20UI/screens/Hassan/Cart_screen.dart';
import 'package:mfc/presentation/Customer%20UI/screens/Hassan/FourPersonDeal.dart';
import 'package:mfc/presentation/Customer%20UI/screens/Hassan/OnePersonDeal.dart';
import 'package:mfc/presentation/Customer%20UI/screens/Hassan/Pizza_screen.dart';
import 'package:mfc/presentation/Customer%20UI/screens/Sanan/BurgerScreen.dart';
import 'package:mfc/presentation/Customer%20UI/screens/Sanan/FavouritePage.dart';
import 'package:mfc/presentation/Customer%20UI/screens/Hassan/ThreePersonDeal.dart';
import 'package:mfc/presentation/Customer%20UI/screens/Hassan/TwoPersonDeal.dart';
import 'package:mfc/presentation/Customer%20UI/screens/Hassan/Orderstatus_screen.dart';
import 'package:mfc/presentation/Customer%20UI/screens/Hassan/Singleburger_screen.dart';
import 'package:mfc/presentation/Customer%20UI/screens/Hassan/Singlepizza_screen.dart';
import 'package:mfc/auth/LoginSignUpScreen/LoginSignUpScreen.dart';
import 'package:carousel_slider/carousel_slider.dart';

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
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedCategoryIndex = -1;

  final List<Map<String, dynamic>> categories = [
    {'title': 'All', 'image': 'assets/platter.png'},
    {'title': 'Pizza', 'image': 'assets/largepizza.png'},
    {'title': 'Burger', 'image': 'assets/beefburger.png'},
    {'title': 'Deserts', 'image': 'assets/desert.png'},
  ];

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
                    _buildDrawerItem(Icons.list_alt, 'Orders', () {}),
                    _buildDrawerItem(Icons.location_on, 'Address', () {}),
                    _buildDrawerItem(Icons.favorite, 'Favorite', () {}),
                    _buildDrawerItem(Icons.shopping_cart, 'Cart', () {}),
                    _buildDrawerItem(
                        Icons.article, 'Terms or Conditions', () {}),
                    _buildDrawerItem(Icons.chat, 'Chat with us', () {}),
                    _buildDrawerItem(Icons.logout, 'Log out', () {
                      FirebaseAuth.instance.signOut();
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginSignUpScreen()),
                        (route) => false,
                      );
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
                      decoration: InputDecoration(
                        hintText: 'Search',
                        prefixIcon: Icon(Icons.search, color: Colors.grey),
                        border: InputBorder.none,
                        contentPadding:
                            EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                      ),
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
      bottomNavigationBar: BottomNavBar(selectedIndex: 0),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, VoidCallback onTap) {
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
                if (category['title'] == "All") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BurgerScreen()),
                  );
                } else if (category['title'] == "Pizza") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PizzaScreen()),
                  );
                } else if (category['title'] == "Burger") {
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
    {"id": 1, "image_path": 'assets/banner4.png', "route": OnePersonDeal()},
    {"id": 2, "image_path": 'assets/banner1.png', "route": TwoPersonDeal()},
    {"id": 3, "image_path": 'assets/banner3.png', "route": ThreePersonDeal()},
    {"id": 4, "image_path": 'assets/banner2.png', "route": FourPersonDeal()},
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
                          currentIndex == entry.key ? Colors.red : Colors.teal,
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

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: PopularItem(
                'Beef Burger',
                20,
                'assets/beefburger.png',
                imageHeight: screenWidth * 0.5,
              ),
            ),
            SizedBox(width: screenWidth * 0.02),
            Expanded(
              child: PopularItem(
                'Special Pizza',
                32,
                'assets/largepizza.png',
                imageHeight: screenWidth * 0.3,
              ),
            ),
          ],
        ),
        SizedBox(height: screenWidth * 0.04),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: PopularItem(
                'Beef Burger',
                20,
                'assets/beefburger.png',
                imageHeight: screenWidth * 0.3,
              ),
            ),
            SizedBox(width: screenWidth * 0.02),
            Expanded(
              child: PopularItem(
                'Special Pizza',
                32,
                'assets/largepizza.png',
                imageHeight: screenWidth * 0.3,
              ),
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
  final double? imageHeight;

  const PopularItem(this.name, this.price, this.imagePath,
      {super.key, this.imageHeight});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double defaultHeight = screenWidth * 0.3;

    return GestureDetector(
      onTap: () {
        if (name.toLowerCase().contains('burger')) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SingleBurgerScreen(),
            ),
          );
        } else if (name.toLowerCase().contains('pizza')) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SinglePizzaScreen(),
            ),
          );
        }
      },
      child: Container(
        width: double.infinity,
        height: screenWidth * 0.55,
        padding: EdgeInsets.all(screenWidth * 0.02),
        decoration: BoxDecoration(
          color: Color(0xff570101),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: screenWidth * 0.01),
                SizedBox(
                  height: screenWidth * 0.36,
                  child: Center(
                    child: Image.asset(
                      imagePath,
                      height: imageHeight ?? defaultHeight,
                    ),
                  ),
                ),
                Text(
                  name,
                  style: TextStyle(
                      color: Colors.white, fontSize: screenWidth * 0.04),
                ),
                Text(
                  '\$$price',
                  style: TextStyle(
                      color: Colors.white, fontSize: screenWidth * 0.035),
                ),
              ],
            ),
            Positioned(
              top: screenWidth * -0.02,
              right: screenWidth * -0.02,
              child: IconButton(
                icon: Icon(Icons.favorite_border, color: Colors.white),
                onPressed: () {
                  Navigator.pushNamed(context, '/favorites',
                      arguments: {'name': name});
                },
              ),
            ),
            Positioned(
              bottom: screenWidth * 0.01,
              right: screenWidth * -0.02,
              child: IconButton(
                icon: Icon(Icons.shopping_cart, color: Colors.white),
                onPressed: () {
                  Navigator.pushNamed(context, '/cart',
                      arguments: {'name': name, 'price': price});
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

  const BottomNavBar({super.key, required this.selectedIndex});

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.selectedIndex;
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
        _buildNavItem(Icons.shopping_bag_outlined, 2),
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
          size: isSelected ? 32 : 24,
        ),
      ),
      label: '',
    );
  }
}
