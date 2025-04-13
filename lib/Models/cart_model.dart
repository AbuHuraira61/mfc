class Cart{
  late final String? id;
  final String? productName;
  final double? initialPrice;
  final double? productPrice;
  final int? quantity;
  final String? image;

  Cart({
    required this.id,
    required this.image,
    required this.initialPrice,
    required this.productName,
    required this.productPrice,
    required this.quantity,
  });

 Cart.fromMap(Map<dynamic, dynamic> res)
 : id = res['id'],
 productName = res['productName'],
 initialPrice = res['initialPrice'],
 productPrice = res['productPrice'],
 quantity = res['quantity'],
 image = res['image'];

 Map<String, Object?> toMap(){
  return {
  'id': id,
  'productName': productName,
  'initialPrice': initialPrice,
  'productPrice': productPrice,
  'quantity': quantity,
  'image': image,
  };
 }


}