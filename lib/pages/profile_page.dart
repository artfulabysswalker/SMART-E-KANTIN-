import 'package:flutter/material.dart';

import '../Database/user_model.dart';


void profilepage(BuildContext context, UserModel user) {
  showDialog(
    context: context,
    barrierDismissible: true, // tap outside to close
    builder: (context) {
      return Center(
        child: Material(
          color: Colors.transparent, // make background transparent
          child: Container(
            width: 300,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min, // make the container hug content
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "User Info",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Text("UID: ${user.useruid}"),
                Text("Email: ${user.email}"),
                Text("Full Name: ${user.fullname}"),
                Text("NIM: ${user.usernim}"),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Close"),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
