import 'package:flutter/material.dart';
import 'package:flutter_application_febri/data/survey_data.dart';
import 'package:flutter_application_febri/screens/profile/profil_page.dart';
import 'package:flutter_application_febri/screens/riwayat/laporan_page.dart';

import '../models/survey_data.dart';
import '../screens/home/home_page.dart';
import '../screens/survey/survey_page.dart';
import '../screens/laporan/laporan_page.dart';
import '../screens/profile/profile_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int selectedIndex = 0;

  List<SurveyData> surveys = [];

  List<Widget> get pages => [
        const HomePage(),
        SurveyPage(
          onSurveySaved: (survey) {
            setState(() {
              surveys.add(survey);
            });
          },
        ),
        LaporanPage(
          surveys: surveys,
        ),
        const ProfilePage(),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text(
          'Dashboard',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: pages[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Survey',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.description),
            label: 'Laporan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
