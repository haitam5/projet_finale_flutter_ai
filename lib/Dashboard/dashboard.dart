import 'package:flutter/material.dart';
import 'package:projet_finale_mathieu/Dashboard/AjoutActivite.dart';
import 'package:projet_finale_mathieu/Dashboard/ListeActivite.dart';
import 'package:projet_finale_mathieu/Dashboard/Profil.dart';
import 'package:projet_finale_mathieu/ModelD/modelActivity.dart';
//import acceuil activity
//import 'package:projet/ListActivite.dart';
//import 'package:projet/MyProfile.dart';
class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _MyNavBarButtomState();
}

class _MyNavBarButtomState extends State<Dashboard> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const ListeActivite(),
    const AjoutActivite(),
     Profil(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Activités',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Ajouter',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      body: _pages[_currentIndex],
    );
  }
}
