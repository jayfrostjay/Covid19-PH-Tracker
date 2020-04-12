import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:phcovid19tracker/generated/i18n.dart';

class AboutPage extends StatelessWidget {
  Orientation currentOrientation;

  @protected
  Widget buildReferenceDataView(BuildContext context){
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          FaIcon(FontAwesomeIcons.link),
          RichText(
            text: TextSpan(text: S.of(context).LABEL_DATA_FROM, style: TextStyle(color: Colors.black, fontSize: 16.0), )
          ),
          RichText(
            text: TextSpan(text: S.of(context).LABEL_RAPID_API, style: TextStyle(color: Colors.black, fontSize: 16.0, decoration: TextDecoration.underline),
            recognizer: TapGestureRecognizer()
                ..onTap = () { launch(S.of(context).URL_RAPID_API); }
            )
          ) 
        ],
    );
  }

  @protected
  Widget buildAvatarAndDetails(BuildContext context){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CircleAvatar(
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
          child: new Text(S.of(context).APP_NAME, style: TextStyle(fontSize: 25.0),),
        ),
        new Padding(
          padding: EdgeInsets.fromLTRB(0, 5.0, 0, 0),
          child: new RichText(
            text: new TextSpan(
              children: [
                new TextSpan(
                  text: S.of(context).LABEL_DEVELOPED_USING,
                  style: new TextStyle(color: Colors.black, fontSize: 16.0)
                ),
                new TextSpan(
                  text: S.of(context).LABEL_FLUTTER,
                  style: new TextStyle(color: Colors.black, fontSize: 16.0, decoration: TextDecoration.underline),
                  recognizer: new TapGestureRecognizer()
                    ..onTap = () { launch(S.of(context).URL_FLUTTER); }
                )
              ]
            )
          )
        )
      ],
    );
  }

  @protected
  Widget buildVersionAndCopyrights(BuildContext context){
    String versionLabel = FlutterConfig.get('FLUTTER_VERSION').toString(); 
    if( FlutterConfig.get('FLUTTER_DEBUG').toString() == "true" ){
      versionLabel += S.of(context).LABEL_DEBUG;
    }

    return Column(
      children: [
        Text(S.of(context).LABEL_VERSION(versionLabel)),
        Text(S.of(context).LABEL_COPYRIGHTS)
      ],
    );
  }

  @protected
  Widget buildPortraitView(BuildContext context){
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
            buildAvatarAndDetails(context),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 50.0, 0, 0),
              child: buildReferenceDataView(context),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
              child: buildVersionAndCopyrights(context),
            ),
        ],
      ),
    );
  }

  @protected buildLandscapeView(BuildContext context){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        buildAvatarAndDetails(context),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            buildReferenceDataView(context),
            buildVersionAndCopyrights(context),
          ],
        )
      ],
    );
  }  

  @override
  Widget build(BuildContext context) {
    currentOrientation = MediaQuery.of(context).orientation;

    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).LABEL_ABOUT)
      ),
      body: (currentOrientation == Orientation.portrait) ? buildPortraitView(context) : buildLandscapeView(context)
    );
  }
} 