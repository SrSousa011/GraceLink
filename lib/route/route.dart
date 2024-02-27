import 'package:flutter/material.dart';

// Define Routes
import 'package:named_route/views/home.dart';
import 'package:named_route/views/login.dart';
import 'package:named_route/views/settings.dart';

// Route Names
const String loginPage = 'login';
const String homePage = 'home';
const String settingsPage = 'settings';

// Control our page route flow
Route<dynamic> controller(RouteSettings settings) {
  switch (settings.name) {
    case loginPage:
      return MaterialPageRoute(builder: (context) => LoginPage());
    case homePage:
      return MaterialPageRoute(builder: (context) => HomePage());
    case settingsPage:
      return MaterialPageRoute(builder: (context) => SettingsPage());
    default:
      throw ('This route name does not exit');
  }
}
