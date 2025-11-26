import 'package:flutter/material.dart';

class ItemPage extends StatelessWidget {
  const ItemPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Item Page'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.shopping_bag, size: 80, color: Colors.green),
            const SizedBox(height: 20),
            const Text(
              'Item Details',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Here you can see the details of the selected item.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 30),
            Card(
              elevation: 2,
              child: ListTile(
                leading: const Icon(Icons.label),
                title: const Text('Item Name'),
                subtitle: const Text('Description of the item goes here.'),
              ),
            ),
          ],
        ),
      ),
        );
      }
    }