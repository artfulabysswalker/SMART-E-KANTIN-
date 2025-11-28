import 'package:flutter/material.dart';
import '../pages/homepage.dart'; // Impor model MenuItem

// Model untuk item di dalam keranjang
class CartItem {
  final MenuItem menuItem;
  int quantity;

  CartItem({required this.menuItem, this.quantity = 1});

  // Fungsi untuk mengubah harga string "Rp 25.000" menjadi double 25000
  double get price {
    // Menghapus 'Rp ', spasi, dan titik sebagai pemisah ribuan
    final cleanPrice = menuItem.price.replaceAll('Rp ', '').replaceAll('.', '');
    return double.tryParse(cleanPrice) ?? 0.0;
  }
}

// Service untuk mengelola state keranjang
class CartService with ChangeNotifier {
  final Map<String, CartItem> _items = {};

  Map<String, CartItem> get items => {..._items};

  // Memperbaiki itemCount agar menghitung jumlah JENIS item, bukan total kuantitas.
  int get itemCount {
    return _items.length;
  }

  // Menambahkan item ke keranjang
  void addItem(MenuItem menuItem) {
    if (_items.containsKey(menuItem.title)) {
      // jika sudah ada, tambah quantity
      _items.update(
        menuItem.title,
        (existingCartItem) => CartItem(
          menuItem: existingCartItem.menuItem,
          quantity: existingCartItem.quantity + 1,
        ),
      );
    } else {
      // jika belum ada, tambahkan item baru
      _items.putIfAbsent(menuItem.title, () => CartItem(menuItem: menuItem));
    }
    // Beri tahu listener bahwa ada perubahan
    notifyListeners();
  }

  // Mengurangi kuantitas item
  void decreaseItemQuantity(String menuItemTitle) {
    if (!_items.containsKey(menuItemTitle)) return;

    if (_items[menuItemTitle]!.quantity > 1) {
      _items.update(
        menuItemTitle,
        (existing) => CartItem(
          menuItem: existing.menuItem,
          quantity: existing.quantity - 1,
        ),
      );
    } else {
      // Jika kuantitas 1, hapus item
      _items.remove(menuItemTitle);
    }
    notifyListeners();
  }

  // Menghitung total harga
  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  // Mengosongkan keranjang
  void clear() {
    _items.clear();
    notifyListeners();
  }
}
