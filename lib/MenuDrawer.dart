import 'package:flutter/material.dart';

class MenuDrawer extends StatelessWidget {
  const MenuDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'Menu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            title: const Text('Home'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/Home');
            },
          ),
          ListTile(
            title: const Text('User Profile'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/UserProfile');
            },
          ),
          ListTile(
            title: const Text('Sign Up'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/SignUp');
            },
          ),
          ListTile(
            title: const Text('Login'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/Login');
            },
          ),
        ],
      ),
    );
  }
}
