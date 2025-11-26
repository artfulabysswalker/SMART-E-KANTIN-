import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final String nama;
  final String nim;

  const HomePage({super.key, required this.nama, required this.nim});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home Page'), centerTitle: true),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
         
            Image.asset(
              'assets/images/logoo.png', 
              width: 150,
            ),
            const SizedBox(height: 20),
            Text(
              'Welcome, $nama!',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text('NIM: $nim', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            const Text('welcome to ekanti.', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/item');
              },
              child: const Text('Go to Item Page'),
            ),
          ],
        ),
      ),
    );
  }
}
