import 'package:mfc/Models/cart_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io' as io;
import 'package:path/path.dart';




class DBHelper {
static Database? _db;

Future<Database?> get db async{
  if(_db!=null){
    return _db!;
  }
  _db = await initDatabase();
  return _db;
 

}

initDatabase() async {
io.Directory documentDirectory = await getApplicationDocumentsDirectory();
String path = join(documentDirectory.path, 'cart.db');
var db = await openDatabase(path, version: 1, onCreate: _onCreate);
return db;
}


_onCreate(Database db, int version)async{
  
  await db.execute('CREATE TABLE cart (id STRING PRIMARY KEY ,productName TEXT,initialPrice REAL, productPrice REAL , quantity INTEGER,image TEXT )');
}


Future<Cart> insert(Cart cart)async{

var dbClient = await db;
await dbClient!.insert('cart', cart.toMap());
return cart;
}

Future<List<Cart>> getCartList()async{
var dbClient = await db;
final List<Map<String, Object?>> queryResult = await dbClient!.query('cart');
print("Databse query result ${queryResult}");
return queryResult.map((e) => Cart.fromMap(e),).toList();

}

Future<int> delete(String id) async{
  var dbClient = await db;
 return await dbClient!.delete(
  'cart',
  where: 'id = ?',
   whereArgs: [id]
   );


}

Future<int> updateQuantity(Cart cart) async{
  var dbClient = await db;
    return await dbClient!.update(
    'cart',
    cart.toMap(),
     where: 'id = ?',
   whereArgs: [cart.id]  
    );
  

}

}
