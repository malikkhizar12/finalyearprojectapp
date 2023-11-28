import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RatingsPage extends StatefulWidget {
  @override
  _RatingsPageState createState() => _RatingsPageState();
}

class _RatingsPageState extends State<RatingsPage> {
  int loginCount = 0;
  bool hasGivenRatings = false;

  @override
  void initState() {
    super.initState();
    checkLoginCountAndRatingsStatus();
  }

  void checkLoginCountAndRatingsStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    loginCount = prefs.getInt('loginCount') ?? 0;
    hasGivenRatings = prefs.getBool('hasGivenRatings') ?? false;

    if (loginCount >= 3 && !hasGivenRatings) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Rate Our App'),
            content: Text('How helpful was our App?'),
            actions: <Widget>[
              ElevatedButton(
                child: Text('Later'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              ElevatedButton(
                child: Text('Rate Now'),
                onPressed: () {
                  // Handle the action to open a ratings page or store the rating
                  // Once the user rates, set hasGivenRatings to true and save it
                  // in SharedPreferences.
                  // Then, you can close the dialog.
                  setState(() {
                    hasGivenRatings = true;
                  });
                  prefs.setBool('hasGivenRatings', true);
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ratings Page'),
      ),
      body: Center(
        child: Text('Ratings Page Content'),
      ),
    );
  }
}
