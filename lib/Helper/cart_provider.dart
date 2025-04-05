import 'package:flutter/cupertino.dart';
import 'package:mfc/Helper/db_helper.dart';
import 'package:mfc/Models/cart_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartProvider with ChangeNotifier {
    DBHelper _db = DBHelper();
    int _counter = 0;
    double _totalPrice = 0.0;


    late Future<List<Cart>> _cart;
    Future<List<Cart>> get cart => _cart;

  Future<List<Cart>> getData() async {
   
      _cart =  _db.getCartList();
    
    return _cart;
  }

    void _setPrefItems() async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setInt('cart_item', _counter);
        prefs.setDouble('total_price', _totalPrice);
        notifyListeners();
    }

    Future<void> _getPrefItems() async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        _counter = prefs.getInt('cart_item') ?? 0;
        _totalPrice = prefs.getDouble('total_price') ?? 0.0;
        notifyListeners();
    }

    void addCounter() {
        _counter++;
        _setPrefItems();
        notifyListeners();
    }

    void removeCounter() {
        _counter--;
        _setPrefItems();
        notifyListeners();
    }

    int getCounterValue() {
         _getPrefItems();
        return _counter;
    }

    void addTotalPrice(double productPrice) {
        _totalPrice = _totalPrice + productPrice;
        _setPrefItems();
        _getPrefItems(); 
        print("🛑 Before notifyListeners()"); // Ensure updated value is retrieved
        notifyListeners();
        print("📢 notifyListeners() called! UI should update.");
        print("✅ Total Price Updated: $_totalPrice");
    }

    void removeTotalPrice(double productPrice) {
        _totalPrice = _totalPrice - productPrice;
        _setPrefItems();
        _getPrefItems();  // Ensure updated value is retrieved
        notifyListeners();
    }

    double getTotalPrice() {
         _getPrefItems();
         // Wait for updated value
        return _totalPrice;
        
    }

    
}
