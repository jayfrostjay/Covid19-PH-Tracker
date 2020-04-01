import 'dart:async';
import 'dart:convert' show json;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:intl/number_symbols.dart';
import 'package:progress_dialog/progress_dialog.dart';

class CovidTracker extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return CovidTrackerState();
  }
}

class CovidTrackerState extends State<CovidTracker> {
  var confirmed, recovered, deaths, total_population, location, showLoader;
  ProgressDialog progressDialog;

  @override
  void initState(){
    super.initState();
    defaultState();
    showLoader = false;
    Future.delayed(const Duration(milliseconds: 500), pullDataFromServer);
  }

  defaultState(){
    confirmed = 0;
    recovered = 0;
    deaths = 0;
    total_population = 0;
    location = "Philippines";
  }

  Future<void> fetchData() async {
    final response = await http.get(
    Uri.encodeFull('https://coronavirus-tracker-api.herokuapp.com/v2/locations/182'),
      headers: { 
        "Accept" : "application/json"
      }
    );

    if( response.statusCode == 200 ){
        showLoader = true;
        var data = json.decode(response.body);
        var latestData = data["location"]["latest"];
        setState(() {
          confirmed = latestData["confirmed"];
          deaths = latestData["deaths"];
          recovered = latestData["recovered"];
          total_population = data["location"]["country_population"];
          showLoader = false;
        });
    }else{
      throw Exception('Failed to load data....');
    }
  }

  Widget buildCardEntry(context, type, data){
    var title = "Confirmed";
    var icon = Icons.trending_up;
    var cardColor = Colors.yellow;
    switch(type.toString().toLowerCase()){
      case "deaths":
        icon = Icons.warning;
        title = "Deaths";
        cardColor = Colors.red;
        break;
      case "recovered":
        icon = Icons.transfer_within_a_station;
        title = "Recovered";
        cardColor = Colors.green;
        break;
      case "total_population":
        icon = Icons.people;
        title = "Total Population";
        cardColor = Colors.blue;
        break;
    } 

    var wrapperIcon = Icon(icon, size: 30.0);
    var numberFormatter = NumberFormat('#,###', 'en_US');
    var toStringData = numberFormatter.format((data)).toString();

    return new Card(
      color: cardColor,
      elevation: 10.0,
      child : Column (
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          new Row(
            children: <Widget>[
              new Expanded(
                child: Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.fromLTRB(10.0, 25.0, 10.0, 25.0),
                  child: new Row(
                    children: <Widget>[
                      new Container(
                        padding: EdgeInsets.fromLTRB(10.0, 0, 40.0, 0),
                        child: wrapperIcon,
                      ),
                      new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          new Container(
                            alignment: Alignment.centerLeft,
                            child: new Text(toStringData, textAlign: TextAlign.left, style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),),
                          ),
                          new Text(title, textAlign: TextAlign.left)
                        ],
                      )
                    ],
                  )
                )
              )
            ],
          )
        ],
      )
    );
  }
  
  buildProgressDialog(BuildContext context, bool show){
    progressDialog = new ProgressDialog(context, type: ProgressDialogType.Normal, isDismissible: false, showLogs: false);
    progressDialog.style(
      message: "Pulling Data from Server....",
      borderRadius: 10.0,
      backgroundColor: Colors.white,
      progressWidget: CircularProgressIndicator(),
      elevation: 10.0,
      insetAnimCurve: Curves.easeInOut,
      progress: 0.0,
      maxProgress: 100.0,
      progressTextStyle: TextStyle(
        color: Colors.black, fontSize: 8.0, fontWeight: FontWeight.w400)
    );

    if( show ){
      setState(() {
        defaultState();
      });
      progressDialog.show();
    }
  }

  pullDataFromServer() async {
      buildProgressDialog(context, true);
      await fetchData();
      if( !(showLoader) ){
        progressDialog.hide();
      }
  }

  @override
  Widget build(BuildContext context) { 
    return Scaffold(
        appBar: AppBar(
          title: Text("Covid-19 PH Tracker"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: pullDataFromServer
            )
          ],
          ), 
        body: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              new Container(
                padding: const EdgeInsets.all(20.0),
                alignment: Alignment.centerLeft,
                child: new Text("Location: " + location, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0), textAlign: TextAlign.left,),
              ),
              new Container(
                padding: const EdgeInsets.all(10.0),
                child: buildCardEntry(context, "confirmed", confirmed),
              ),
              new Container(
                padding: const EdgeInsets.all(10.0),
                child: buildCardEntry(context, "recovered", recovered),
              ),
              new Container(
                padding: const EdgeInsets.all(10.0),
                child: buildCardEntry(context, "deaths", deaths),
              ),
              new Container(
                padding: const EdgeInsets.all(10.0),
                child: buildCardEntry(context, "total_population", total_population),
              ),
            ],
          )
        ),
        drawer: new Drawer(
          child: new ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              new UserAccountsDrawerHeader(
                accountName: new Text("Jayson Garcia"), 
                accountEmail: new Text("jayfrostgarcia@gmail.com"),
                currentAccountPicture: new CircleAvatar(
                  child: new Text("JG")
                ),
              ),
              new ListTile(
                title: new Container(
                  alignment: Alignment.centerLeft,
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      new Container(
                        alignment: Alignment.centerLeft,
                        child: new Icon(Icons.track_changes),
                      ),
                      new Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.fromLTRB(20.0, 0.0, 0.0, 0.0),
                        child: new Text('Tracker'),
                      )
                    ],
                  ),
                ),
                onTap: () {
                },
              ),
              new ListTile(
                title: new Container(
                  alignment: Alignment.centerLeft,
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      new Container(
                        alignment: Alignment.centerLeft,
                        child: new Icon(Icons.info),
                      ),
                      new Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.fromLTRB(20.0, 0.0, 0.0, 0.0),
                        child: new Text('About'),
                      )
                    ],
                  ),
                ),
                onTap: () {

                },
              ),
              new Divider(),
              new ListTile(
                title: new Container(
                  alignment: Alignment.centerLeft,
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      new Container(
                        alignment: Alignment.centerLeft,
                        child: new Icon(Icons.close),
                      ),
                      new Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.fromLTRB(20.0, 0.0, 0.0, 0.0),
                        child: new Text('Close'),
                      )
                    ],
                  ),
                ),
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  Navigator.pop(context);
                },
              ),
            ],
          )
        ),
    );
  }
}

class CovidJsonResponse{
  final location;

  CovidJsonResponse({this.location});

  factory CovidJsonResponse.fromJson(Map<String,dynamic> json){
    return CovidJsonResponse(
      location: json['location'],
    );
  }
}