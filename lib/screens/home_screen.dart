import 'package:flutter/material.dart';
import 'package:sqlite_implementation/constants.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Provide total height and width of the screen
    Size size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        backgroundColor: kBackgroundColor,
        body: Column(
          children: [
            Container(
              child: Center(child: Image.asset('images/logo.png')),
              height: size.height * 0.15,
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.only(top: 14, bottom: 20),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  color: kPrimaryColor,
                ),
                child: Container(
                  child: Expanded(
                    child: ListView(
                      padding: const EdgeInsets.all(8),
                      children: <Widget>[
                        Card(
                          color: Colors.white,
                          elevation: 6,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: ListTile(
                            title: const Text(
                              'XI RPL Basis Data',
                              style: TextStyle(
                                  color: kDarkColor,
                                  fontWeight: FontWeight.w700),
                            ),
                            subtitle: Text('2019-2020'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Text('24'),
                                Icon(
                                  Icons.people,
                                  color: kDarkColor,
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          backgroundColor: kDarkColor,
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
