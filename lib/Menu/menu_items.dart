import 'package:flutter/material.dart';
import 'package:flutter_desktop_sqlite_app/Menu/Pages/Notification.dart';
import 'package:flutter_desktop_sqlite_app/Menu/Pages/accounts.dart';
import 'package:flutter_desktop_sqlite_app/Menu/Pages/dashboard.dart';
import 'package:flutter_desktop_sqlite_app/Menu/Pages/settings.dart';
import 'Pages/reports.dart';
import 'menu_details.dart';


 class MenuItems{
   List<MenuDetails> items = [
     MenuDetails(title: "Dashboard", icon: Icons.home, page: const Dashboard()),
     MenuDetails(title: "Accounts", icon: Icons.account_circle_rounded, page: const Accounts()),
     MenuDetails(title: "Notifications", icon: Icons.notification_important_rounded, page: const Notifications()),
     MenuDetails(title: "Reports", icon: Icons.add_chart, page: const Reports()),
     MenuDetails(title: "Settings", icon: Icons.settings, page: const Settings()),

   ];
 }