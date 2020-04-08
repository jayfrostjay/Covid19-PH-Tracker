import 'dart:async';
import 'dart:convert' show json;

import 'package:awesome_loader/awesome_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';


class CovidTracker extends StatefulWidget{
  final String apiKey, apiHost, locationKey;

  CovidTracker({Key key, this.apiKey, this.apiHost, this.locationKey}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return CovidTrackerState(apiKey, apiHost, locationKey);
  }
}

class CovidTrackerState extends State<CovidTracker> {
  final String apiKey, apiHost, locationKey;
  var confirmed, recovered, deaths, active_cases, location, showLoader, dataTimelines, record_date = "", record_date_formatted = "";
  ProgressDialog progressDialog;
  
  CovidTrackerState(this.apiKey, this.apiHost, this.locationKey);

  @override
  void initState(){
    super.initState();
    defaultState();
    showLoader = false;
    Future.delayed(const Duration(milliseconds: 500), pullDataFromServer);
  }

  defaultState(){
    confirmed = "0";
    recovered = "0";
    deaths = "0";
    active_cases = "0";
    location = this.locationKey;
  }

  Future<void> fetchData() async {
    final response = await http.get(
    // Uri.encodeFull('https://coronavirus-tracker-api.herokuapp.com/v2/locations/182'),
    Uri.encodeFull('https://coronavirus-monitor.p.rapidapi.com/coronavirus/latest_stat_by_country.php?country='+this.locationKey),
      headers: { 
        "Accept" : "application/json",
        "x-rapidapi-host" : this.apiHost,
        "x-rapidapi-key" : this.apiKey
      }
    );

    if( response.statusCode == 200 ){
        showLoader = true;
        var data = json.decode(response.body);
        /* -- FROM CORONAVIRUS-TRACKER-API HEROKU
        var latestData = data["location"]["latest"];
        setState(() {
          dataTimelines = data["location"]["timelines"];
          confirmed = latestData["confirmed"];
          deaths = latestData["deaths"];
          recovered = latestData["recovered"];
          total_population = data["location"]["country_population"];
          showLoader = false;
        });
        */
        var latestData = data["latest_stat_by_country"][0];
        record_date = (latestData["record_date"]).split('.')[0];
        record_date = record_date.replaceAll(' ', '');
        record_date = record_date.replaceAll('-', '');
        record_date = record_date.replaceAll(':', '');
        record_date = record_date.substring(0, 8) + 'T' + record_date.substring(8);
        // print(latestData);
        
        if( this.mounted ){
          setState(() {
            confirmed = latestData["total_cases"];
            deaths = latestData["total_deaths"];
            recovered = latestData["total_recovered"];
            active_cases = latestData['active_cases'];
            showLoader = false;

            record_date = record_date;
            record_date_formatted = DateFormat("E MMM dd, yyyy - hh:mm:ss a").format(DateTime.parse(record_date));
          });
        }
    }else{
      throw Exception('Failed to load data....');
    }
  }

  Widget buildCardEntry(context, type, data){
    var title = "Total Confirmed";
    var icon = FontAwesomeIcons.viruses;
    var cardColor = Colors.yellow;
    switch(type.toString().toLowerCase()){
      case "deaths":
        icon = FontAwesomeIcons.skullCrossbones;
        title = "Total Deaths";
        cardColor = Colors.red;
        break;
      case "recovered":
        icon = FontAwesomeIcons.userShield;
        title = "Total Recovered";
        cardColor = Colors.green;
        break;
      case "active_cases":
        icon = FontAwesomeIcons.users;
        title = "Active Cases";
        cardColor = Colors.blue;
        break;
    } 

    var wrapperIcon = Icon(icon, size: 30.0);
    // var numberFormatter = NumberFormat('#,###', 'en_US');
    // var toStringData = numberFormatter.format((data)).toString();
    var toStringData = data.toString();
    
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
      progressWidget: AwesomeLoader(loaderType: AwesomeLoader.AwesomeLoader4, color: Colors.blue,),
      elevation: 10.0,
      insetAnimCurve: Curves.easeInOut,
      progress: 0.0,
      maxProgress: 100.0,
      progressTextStyle: TextStyle(
        color: Colors.black, fontSize: 8.0, fontWeight: FontWeight.w400)
    );

    if( show ){
      if( this.mounted ){
        setState(() {
          defaultState();
        });
      }
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

  buildDrawerLinks(String title, Function onTapRedirect){
      return new ListTile(
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
                child: new Text(title),
              )
            ],
          ),
        ),
        onTap: () => onTapRedirect,
      );
  }

  @protected
  Widget BuildScrollableBody(BuildContext context){
    return SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              new Container(
                padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 10.0),
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
                child: buildCardEntry(context, "active_cases", active_cases),
              ),
              new Container(
                padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    new Text("Record Date: ", style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),),
                    new Text(record_date_formatted, style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold))
                  ],
                ),
              ) 
            ],
          ),
      ),
    );
  }

  @protected 
  Widget buildDrawers(BuildContext context){
    return new Drawer(
      child: new ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          new UserAccountsDrawerHeader(
            accountName: new Text("Covid-19 PH Tracker"), 
            accountEmail: new Text("jayfrostgarcia@gmail.com"),
            currentAccountPicture: new CircleAvatar(
              child: Text("PH")
              // child: ClipRRect(
              //   borderRadius: BorderRadius.circular(50.0),
              //   child: Image.asset('assets/images/test.jpg'),
              // )
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
            onTap: () => Navigator.pop(context),
          ),
          new ListTile(
            title: new Container(
              alignment: Alignment.centerLeft,
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  new Container(
                    alignment: Alignment.centerLeft,
                    child: new FaIcon(FontAwesomeIcons.history),
                  ),
                  new Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.fromLTRB(20.0, 0.0, 0.0, 0.0),
                    child: new Text('History'),
                  )
                ],
              ),
            ),
            onTap: () => 
              Navigator.of(context).pushNamed("/history")
          ),
          new ListTile(
            title: new Container(
              alignment: Alignment.centerLeft,
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  new Container(
                    alignment: Alignment.centerLeft,
                    child: new FaIcon(FontAwesomeIcons.chartLine),
                  ),
                  new Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.fromLTRB(20.0, 0.0, 0.0, 0.0),
                    child: new Text('World Statistics'),
                  )
                ],
              ),
            ),
            onTap: () => Navigator.of(context).pushNamed("/statistics"),
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
            onTap: () => Navigator.of(context).pushNamed("/about"),
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
            onTap: () => Navigator.pop(context),
          ),
        ],
      )
    );
  }

  @protected
  Widget buildAppBar(BuildContext context){
    return AppBar(
      title: Text("Covid-19 PH Tracker"),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.refresh),
          onPressed: pullDataFromServer
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildAppBar(context), 
        body: BuildScrollableBody(context),
        drawer: buildDrawers(context),
    );
  }
}