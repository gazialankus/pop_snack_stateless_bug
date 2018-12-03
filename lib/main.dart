import 'package:flutter/material.dart';

// This bug did not manifest with two pages.
// I had to create three pages for this to happen.
// Here's what to do to reproduce this bug:
// 1. Press the button twice to get to the third page, which contains a TextField and a Button.
// 2. Write something in that text field and hit that button.
// 3. Surprise! Only then _scaffoldKey.currentState becomes null...

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weird bug',
      home: Page1(),
    );
  }
}

class Page1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (BuildContext context2) {
          return SafeArea(
            child: RaisedButton(
              child: Text("Push me"),
              onPressed: () async {
                await Navigator.push(context2, new MaterialPageRoute(
                  builder: (BuildContext context3) {
                    return Page2();
                  }
                ));
              },
            ),
          );
        },
      )
    );
  }
}


class Page2 extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Builder(
        builder: (BuildContext context2) {
          return SafeArea(
            child: RaisedButton(
              child: Text("Push me, too"),
              onPressed: () async {
                var msg = await Navigator.push(context2, new MaterialPageRoute<String>(
                  builder: (BuildContext context3) {
                    return Page3();
                  }
                ));
                _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(msg)));
              },
            ),
          );
        },
      )
    );
  }
}

class Page3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            TextField(),
            RaisedButton(
              child: Text("If you tap the TextField above before you push me, the bug will manifest."),
              onPressed: () {
                Navigator.pop(context, "hello");
              },
            ),
            RaisedButton(
              child: Text("aa"),
              onPressed: () {
                print("hele");

              },
            ),
          ],
        ),
      )
    );
  }
}
