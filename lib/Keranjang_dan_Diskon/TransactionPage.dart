import 'package:ekantin/Keranjang_dan_Diskon/cart.dart';
import 'package:ekantin/models/user_model_A1.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'discount.dart';
import 'PointPage.dart';
import 'Cart_page.dart';


class TransactionPage extends StatefulWidget {
  final List<CartItem> cartItems;
  final double total;

  const TransactionPage({
    super.key,
    required this.cartItems,
    required this.total,
  });

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  UserModel_A1? currentUser;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
  }

  Future<void> _loadCurrentUser() async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
        final doc = await FirebaseFirestore.instance
          .collection("mahasiswa")
          .doc(firebaseUser.uid)
          .get();

      if (doc.exists) {
        currentUser = UserModel_A1.fromJson_A1(doc.data()!);
      } else {
        currentUser = UserModel_A1(
          useru: firebaseUser.uid,
          usernim: "N/A",
          email_A1: firebaseUser.email ?? "",
          fullName_A1: firebaseUser.displayName ?? "Unknown",
          point: 0,
        );
      }
    }
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (currentUser == null) {
      return const Scaffold(
        body: Center(child: Text("User not found")),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Payment Methods"),
        backgroundColor: Colors.orange,
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text("Pay with Points"),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PointsPage(
                    cartItems: widget.cartItems,
                    total: widget.total,
                    user: currentUser!,
                  ),
                ),
              );
            },
          ),
          ListTile(
            title: const Text("Apply NIM Discount"),
            subtitle: const Text('Diskon ganjil/genap berdasarkan NIM pengguna'),
            trailing: const Icon(Icons.local_offer),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DiscountPage(
                    cartItems: widget.cartItems,
                    total: widget.total,
                    user: currentUser!,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}