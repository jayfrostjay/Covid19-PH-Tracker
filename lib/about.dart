import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatelessWidget {
  final String title;

  AboutPage(this.title);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(title)
      ),
      body: Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
              new CircleAvatar(
                radius: 80.0,
                backgroundColor: Colors.blue,
                child: new Text("JG", style: TextStyle(fontSize: 50.0),)
              ),
              new Padding(
                padding: EdgeInsets.fromLTRB(0, 20.0, 0, 0),
                child: new Text("Covid-19 PH Tracker", style: TextStyle(fontSize: 25.0),),
              ),
              new Padding(
                padding: EdgeInsets.fromLTRB(0, 5.0, 0, 0),
                child: new RichText(
                  text: new TextSpan(
                    children: [
                      new TextSpan(
                        text: 'Developed using ',
                        style: new TextStyle(color: Colors.black, fontSize: 15.0)
                      ),
                      new TextSpan(
                        text: 'Flutter',
                        style: new TextStyle(color: Colors.black, fontSize: 15.0),
                        recognizer: new TapGestureRecognizer()
                          ..onTap = () { launch('https://flutter.dev'); }
                      )
                    ]
                  )
                )
              )
          ],
        ),
      )
    );
  }

}