import 'package:ekantin/models/product_model_A1.dart';

class CartItem {
  final ProductModel_A1 product;
  int quantity;
  bool isSelected;

  CartItem({required this.product, this.quantity = 1, this.isSelected = false});
}

class Cart {
  static List<CartItem> cart = [];

  // Add a product to the cart with stock limit
  static void add(ProductModel_A1 product) {
    for (var item in cart) {
      if (item.product.productId_A1 == product.productId_A1) {
        if (item.quantity < product.stock_A1) {
          item.quantity++;
        } else {
          // Stock limit reached
          print("Stock limit reached for ${product.productId_A1}");
        }
        return;
      }
    }
    // If not in cart yet, check stock first
    if (product.stock_A1 > 0) {
      cart.add(CartItem(product: product, quantity: 1));
    } else {
      print("${product.productId_A1} is out of stock!");
    }
  }

  // Remove one quantity of a product
  static void removeOne(ProductModel_A1 product) {
    for (int i = 0; i < cart.length; i++) {
      if (cart[i].product.productId_A1 == product.productId_A1) {
        cart[i].quantity--;
        if (cart[i].quantity <= 0) cart.removeAt(i);
        break;
      }
    }
  }

  // Remove all quantities of a product
  static void removeAll(ProductModel_A1 product) {
    cart.removeWhere((item) => item.product.productId_A1 == product.productId_A1);
  }

  // Clear the cart
  static void clear() {
    cart.clear();
  }

  // Total price
  static double totalPrice() {
    double total = 0;
    for (var item in cart) {
      total += item.product.productPrice * item.quantity;
    }
    return total;
  }

  // Total number of items
  static int totalItems() {
    int total = 0;
    for (var item in cart) {
      total += item.quantity;
    }
    return total;
  }
  static void removeCartItem(CartItem item) {
    cart.remove(item);
  }

static int getQuantity(ProductModel_A1 product) {
    for (var item in cart) {
      if (item.product.productId_A1 == product.productId_A1) {
        return item.quantity;
      }
    }
    return 0;
  }
  
}