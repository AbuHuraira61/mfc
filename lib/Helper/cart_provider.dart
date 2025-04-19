


import 'package:flutter/cupertino.dart';
import 'package:mfc/Helper/db_helper.dart';
import 'package:mfc/Models/cart_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartProvider with ChangeNotifier {
  final DBHelper _db = DBHelper();
  List<Cart> _cart = [];
  int _counter = 0;
  double _totalPrice = 0.0;

  // Exposed getters
  List<Cart> get cart => _cart;
  int get counter => _counter;
  double get totalPrice => _totalPrice;

  CartProvider() {
    _loadCart(); // initialize on creation
  }

  /// Load all items from DB, recalc totals, and notify listeners
  Future<void> _loadCart() async {
    _cart = await _db.getCartList();
    _recalculate();
  }

  /// Public method to refresh data
  Future<List<Cart>> getData() async {
    _cart = await _db.getCartList();
    _recalculate();
    return _cart;
  }

  /// Add an item price and quantity to totals
  void addTotalPrice(double productPrice) {
    _totalPrice += productPrice;
    _counter++;
    _setPrefItems();
    notifyListeners();
  }

  /// Remove an item price and quantity from totals
  void removeTotalPrice(double productPrice) {
    _totalPrice -= productPrice;
    if (_counter > 0) _counter--;
    _setPrefItems();
    notifyListeners();
  }

  /// Clear all cart data
  Future<void> clearCartData() async {
    _cart.clear();
    _counter = 0;
    _totalPrice = 0.0;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('cart_item', _counter);
    await prefs.setDouble('total_price', _totalPrice);
    notifyListeners();
  }

  /// Persist totals to SharedPreferences
  Future<void> _setPrefItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('cart_item', _counter);
    await prefs.setDouble('total_price', _totalPrice);
  }

  /// (Optional) Restore totals from SharedPreferences
  Future<void> restoreFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _counter = prefs.getInt('cart_item') ?? 0;
    _totalPrice = prefs.getDouble('total_price') ?? 0.0;
    notifyListeners();
  }

  /// Internal: recalc both counter and total price
  void _recalculate() {
    _totalPrice = 0.0;
    _counter = 0;
    for (var item in _cart) {
      _totalPrice += item.productPrice!;
      _counter += item.quantity!;
    }
    _setPrefItems();
    notifyListeners();
  }
}



























// import 'package:flutter/cupertino.dart';
// import 'package:mfc/Helper/db_helper.dart';
// import 'package:mfc/Models/cart_model.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class CartProvider with ChangeNotifier {
//     DBHelper _db = DBHelper();
//     int _counter = 0;
//     double _totalPrice = 0.0;


//     late Future<List<Cart>> _cart;
//     Future<List<Cart>> get cart => _cart;

//   Future<List<Cart>> getData() async {
   
//       _cart =  _db.getCartList();
    
//     return _cart;
//   }

//     void _setPrefItems() async {
//         SharedPreferences prefs = await SharedPreferences.getInstance();
//         prefs.setInt('cart_item', _counter);
//         prefs.setDouble('total_price', _totalPrice);
//         notifyListeners();
//     }

//     Future<void> _getPrefItems() async {
//         SharedPreferences prefs = await SharedPreferences.getInstance();
//         _counter = prefs.getInt('cart_item') ?? 0;
//         _totalPrice = prefs.getDouble('total_price') ?? 0.0;
//         notifyListeners();
//     }

//     void addCounter() {
//         _counter++;
//         _setPrefItems();
//         notifyListeners();
//     }

//     void removeCounter() {
//         _counter--;
//         _setPrefItems();
//         notifyListeners();
//     }

//     int getCounterValue() {
//          _getPrefItems();
//         return _counter;
//     }

//     void addTotalPrice(double productPrice) {
//         _totalPrice = _totalPrice + productPrice;
//         _setPrefItems();
//         _getPrefItems(); 
//         print("🛑 Before notifyListeners()"); // Ensure updated value is retrieved
//         notifyListeners();
//         print("📢 notifyListeners() called! UI should update.");
//         print("✅ Total Price Updated: $_totalPrice");
//     }

//     void removeTotalPrice(double productPrice) {
//         _totalPrice = _totalPrice - productPrice;
//         _setPrefItems();
//         _getPrefItems();  // Ensure updated value is retrieved
//         notifyListeners();
//     }

//     double getTotalPrice() {
//          _getPrefItems();
//          // Wait for updated value
//         return _totalPrice;
        
//     }

//     void clearCartData() async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   _counter = 0;
//   _totalPrice = 0.0;
//   await prefs.setInt('cart_item', _counter);
//   await prefs.setDouble('total_price', _totalPrice);
//   notifyListeners();
// }

    
// }
