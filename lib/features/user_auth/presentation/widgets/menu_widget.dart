import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, "/home");
            },
            child: const SizedBox(
              child: Center(
                child: Text(
                  "MONTO",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 12
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, "/objetivo");
            },
            child: const SizedBox(
              child: Center(
                child: Text(
                  "OBJETIVO",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 12
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              FirebaseAuth.instance.signOut();
              Navigator.pushNamed(context, "/login");
            },
            child: const SizedBox(
              child: Center(
                child: Text(
                  "LOG OUT",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 12
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
