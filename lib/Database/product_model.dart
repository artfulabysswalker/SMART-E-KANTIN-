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
      productId: id, // <-- Use Firestore document ID
      productImageUrl: map['productImageUrl'] ?? '',
      productName: map['productName'] ?? '',
      productPrice: (map['productPrice'] ?? 0).toDouble(),
      stock: map['stock'] ?? 0,
      productDescription: map['productDescription'] ?? '',
    );
  }
}
