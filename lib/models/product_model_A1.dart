// product_model_A1.dart

class ProductModel_A1 {
  final String productId_A1; 
  final String name_A1;      
  final double price_A1;     
  final int stock_A1;        
  final String imageUrl_A1;  

  ProductModel_A1({
    required this.productId_A1,
    required this.name_A1,
    required this.price_A1,
    required this.stock_A1,
    required this.imageUrl_A1,
  });

  factory ProductModel_A1.fromJson_A1(Map<String, dynamic> json) {
    return ProductModel_A1(
      productId_A1: json['product_id'] as String,
      name_A1: json['name'] as String,
      price_A1: (json['price'] as num).toDouble(), 
      stock_A1: (json['stock'] as num).toInt(),
      imageUrl_A1: json['image_url'] as String,
    );
  }

  get productPrice => null;

  String? get productName => null;

  Map<String, dynamic> toJson_A1() {
    return {
      'product_id': productId_A1,
      'name': name_A1,
      'price': price_A1,
      'stock': stock_A1,
      'image_url': imageUrl_A1,
    };
  }
}