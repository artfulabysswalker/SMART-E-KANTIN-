class ProductModel {
  final String productId;
  final String productImageUrl;
  final String productName;
  final double productPrice;
  final int stock;
  final String productDescription;

  ProductModel({
    required this.productId,
    required this.productImageUrl,
    required this.productName,
    required this.productPrice,
    required this.stock,
    required this.productDescription,
  });

  factory ProductModel.fromJson(String id, Map<String, dynamic> map) {
    return ProductModel(
      productId: id, 
      productImageUrl: map['productImageUrl'] ?? '',
      productName: map['productName'] ?? '',
      productPrice: (map['productPrice'] ?? 0).toDouble(),
      stock: map['stock'] ?? 0,
      productDescription: map['productDescription'] ?? '',
    );
  }
}

double toDouble(dynamic value) {
  if (value == null) return 0;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  return double.tryParse(value.toString()) ?? 0;
}
