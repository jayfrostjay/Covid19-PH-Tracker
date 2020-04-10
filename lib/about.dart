import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_config/flutter_config.dart';

class AboutPage extends StatelessWidget {
  final String title;

  AboutPage({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String isDebug = ""; 
    if( FlutterConfig.get('FLUTTER_DEBUG').toString() == "true" ){
      isDebug = " - Debug";
    }
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
                radius: 100.0,
                backgroundColor: Colors.blue,
                // child: new Text("PH", style: TextStyle(fontSize: 50.0, color: Colors.white),)
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100.0),
                  child: Image.asset('assets/images/test.jpg'),
                )
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
                        style: new TextStyle(color: Colors.black, fontSize: 16.0)
                      ),
                      new TextSpan(
                        text: 'Flutter',
                        style: new TextStyle(color: Colors.black, fontSize: 16.0, decoration: TextDecoration.underline),
                        recognizer: new TapGestureRecognizer()
                          ..onTap = () { launch('https://flutter.dev'); }
                      )
                    ]
                  )
                )
              ),
              new Padding(
                padding: EdgeInsets.fromLTRB(0, 50.0, 0, 0),
                child: new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new FaIcon(FontAwesomeIcons.link),
                      new RichText(text: new TextSpan(
                          text: " Data from ",
                          style: new TextStyle(color: Colors.black, fontSize: 16.0),
                        )
                      ),
                      new RichText(
                        text: new TextSpan(
                          text: "RapidAPI",
                          style: new TextStyle(color: Colors.black, fontSize: 16.0, decoration: TextDecoration.underline),
                          recognizer: new TapGestureRecognizer()
                            ..onTap = () { launch('https://rapidapi.com/astsiatsko/api/coronavirus-monitor'); }
                        )
                      ) 
                    ],
                )
              ),
              Padding(padding: EdgeInsets.fromLTRB(0, 20, 0, 0),),
              Text('Version: ' + FlutterConfig.get('FLUTTER_VERSION').toString() + isDebug ),
              Text('Copyright 2020. All rights reseved.')
          ],
        ),
      )
    );
  }

}