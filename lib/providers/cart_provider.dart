// cart_provider_D4.dart

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../models/product_model_A1.dart'; 


// Data Model sederhana untuk item di keranjang (D4)
class CartItem_hillmi {
  final String productId;
  final String name;
  final double price;
  int quantity;

  CartItem_hillmi({required this.productId, required this.name, required this.price, this.quantity = 1});
}

// Watermark Code: class name with suffix
class CartProvider_D4 with ChangeNotifier {
  final Map<String, CartItem_hillmi> _items_D4 = {};
  double _subTotal_D4 = 0.0;
  double _shippingFee_D4 = 15000.0; 

  List<CartItem_hillmi> get items_D4 => _items_D4.values.toList();
  double get subTotal_D4 => _subTotal_D4;
  double get shippingFee_D4 => _shippingFee_D4;

  void _calculateSubTotal_D4() {
    _subTotal_D4 = 0.0;
    for (var item in _items_D4.values) {
      _subTotal_D4 += item.price * item.quantity;
    }
  }

  // LOGIKA ADD / REMOVE CART 
  void addItem_D4(ProductModel_A1 product) {
    if (_items_D4.containsKey(product.productId_A1)) {
      _items_D4.update(product.productId_A1, (existingItem) {
        existingItem.quantity += 1;
        return existingItem;
      });
    } else {
      _items_D4.putIfAbsent(
        product.productId_A1, 
        () => CartItem_hillmi(
          productId: product.productId_A1, 
          name: product.name_A1, 
          price: product.price_A1
        )
      );
    }
    _calculateSubTotal_D4();
    notifyListeners();
  }

  void removeItem_D4(String productId) {
    if (!_items_D4.containsKey(productId)) return;

    if (_items_D4[productId]!.quantity > 1) {
      _items_D4.update(productId, (existingItem) {
        existingItem.quantity -= 1;
        return existingItem;
      });
    } else {
      _items_D4.remove(productId);
    }
    
    _calculateSubTotal_D4();
    notifyListeners();
  }

  void clearCart_D4() {
    _items_D4.clear();
    _subTotal_D4 = 0.0;
    _shippingFee_D4 = 15000.0;
    notifyListeners();
  }


  // LOGIC TRAP: DISKON NIM 
  double calculateFinalTotal_D4(String userNIM) {
    double finalTotal_D4 = _subTotal_D4;
    _shippingFee_D4 = 15000.0; 
    
    final lastDigitString = userNIM.substring(userNIM.length - 1);
    final lastDigit_D4 = int.tryParse(lastDigitString) ?? 0;
    
    if (lastDigit_D4 % 2 != 0) {
      // Ganjil: Diskon 5%
      double discount_D4 = finalTotal_D4 * 0.05;
      finalTotal_D4 -= discount_D4;
    } else {
      // Genap: Gratis Ongkir
      _shippingFee_D4 = 0.0;
    }

    finalTotal_D4 += _shippingFee_D4;
    
    return finalTotal_D4; 
  }
}