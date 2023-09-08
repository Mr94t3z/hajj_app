import 'package:flutter/material.dart';
import 'package:hajj_app/widgets/components/bottom_nav_bar.dart';
import 'package:hajj_app/widgets/pages/first.dart';
import 'package:hajj_app/widgets/pages/second.dart';
import 'package:hajj_app/widgets/pages/third.dart';
import 'package:hajj_app/widgets/pages/fourth.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  int _currentIndex = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: const [
          FirstWidget(),
          SecondWidget(),
          ThirdWidget(),
          FourthWidget(),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
