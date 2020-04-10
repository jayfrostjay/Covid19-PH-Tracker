import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:awesome_loader/awesome_loader.dart';
import 'dart:async';
import 'dart:convert' show json;
import 'package:intl/intl.dart';
import 'package:phcovid19tracker/history.dart';
import 'package:flutter_config/flutter_config.dart';

class CovidStatistics extends StatefulWidget{
  final String apiKey, apiHost, locationKey;
  CovidStatistics({Key key, this.apiKey, this.apiHost, this.locationKey}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return CovidStatisticsState(apiKey, apiHost, locationKey);
  }
}

enum viewType {
  item,
  header
}

class CovidStatisticsState extends State<CovidStatistics> {
  final String apiKey, apiHost, locationKey;
  CovidStatisticsState(this.apiKey, this.apiHost, this.locationKey);

  bool _pageLoader = true, _listLoader = false, _hasData = true;
  int _listItemCount = 22;
  List<dynamic> _data = [];
  int _dataAppendCount = 20;

  @override
  void initState(){
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), _pullStatisticsData);
  }

  formatData(date){
    var formattedData = (date).split('.')[0];
    formattedData = formattedData.replaceAll(' ', '');
    formattedData = formattedData.replaceAll('-', '');
    formattedData = formattedData.replaceAll(':', '');
    formattedData = formattedData.substring(0, 8) + 'T' + formattedData.substring(8);
    return DateFormat("E MMM dd, yyyy - hh:mm:ss a").format(DateTime.parse(formattedData));
  }

  Future<HashMap<String, dynamic>> _fetchStatistics() async {
    final response = await http.get(
    Uri.encodeFull('https://coronavirus-monitor.p.rapidapi.com/coronavirus/cases_by_country.php'),
      headers: { 
        "Accept" : "application/json",
        "x-rapidapi-host" : this.apiHost,
        "x-rapidapi-key" : this.apiKey
      }
    );

    HashMap<String, dynamic> _data = new HashMap<String, dynamic>();
    if( response.statusCode == 200 ){
      var data = json.decode(response.body);
      _data["date"] = data["statistic_taken_at"];
      _data["history"] = data["countries_stat"];
      return _data;
    }else{
      return _data;
    }
  }

  _pullStatisticsData() async {
    var dataHolder = [];
    var statisticsData = await _fetchStatistics();

    if( statisticsData["history"].length > 0 ){
      dataHolder.add({
        'stat_date' : formatData(statisticsData['date']).toString(),
        'viewType' : viewType.header
      });
      (statisticsData["history"]).forEach((value) {
        value['viewType'] = viewType.item;
        dataHolder.add(value);
      });

      setStateWrapper((){
        _data = dataHolder;
        _pageLoader = false;
        (_data.length == 0) ? _hasData = false : _hasData = true;
      });
    }else{
      setStateWrapper((){
        _hasData = false;
      });
    }
  }

  @protected
  Widget BuildPageLoader(BuildContext context){
    return new Container(
      alignment: Alignment.center,
      child: AwesomeLoader(loaderType: AwesomeLoader.AwesomeLoader4, color: Colors.blue,),
    );
  }

  @protected
  Widget BuildListLoader(BuildContext context, int index){
    if( _listLoader ){
      var totalMinusLoaded = (_data.length) - _listItemCount;
      if( totalMinusLoaded >= _dataAppendCount ){
        _listItemCount = _listItemCount + _dataAppendCount;
      }else{
        _listItemCount = _listItemCount + totalMinusLoaded;
      }

      Future.delayed(const Duration(milliseconds: 500), () => {
        (this.mounted) ? {
          setState((){
            _listLoader = false;
            _listItemCount = _listItemCount;
          })
        } : {}
      });
      return Container(
        margin: EdgeInsets.fromLTRB(0, 4.0, 0, 0),
        child: Center(
          child: AwesomeLoader(
            loaderType: AwesomeLoader.AwesomeLoader4,
            color: Colors.blue,
          ),
        ),
      );
    }

    if( index < (_data.length) ){
      return Container(
        margin: EdgeInsets.fromLTRB(0, 4.0, 0, 0),
        color: Colors.blue,
        child: FlatButton(
            child: Text("Load More...", style: TextStyle(color: Colors.white),),
            onPressed: () {
              (this.mounted) ? setState(() { _listLoader = true; }) : { };
            },
        ),
      ); 
    }
  }

  void _navigateToHistoryScreen(BuildContext context, String locationKey){
    Navigator
      .of(context)
      .push(MaterialPageRoute(builder: (context) => 
            CovidHistory(apiKey: FlutterConfig.get('API_KEY'), 
                         apiHost: FlutterConfig.get('API_URL'), 
                         locationKey: locationKey))
        );
  }

  @protected
  Widget BuildListItem(BuildContext context, int index) {
    if( _data[index]['viewType'] == viewType.header ){
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          'Record Date: ' + _data[index]['stat_date'],
          textAlign: TextAlign.right,
          style: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.bold
          ),
        ),
      );
    }

    bool showIcon = false;
    if( _data[index]['country_name'] == locationKey ){
      showIcon = true;
    }


    return 
      Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 2.0, 8.0, 2.0),
        child: Card(
          elevation: 5,
          child: InkWell(
            onTap: () {
              _navigateToHistoryScreen(context, _data[index]['country_name']);
            },
            child: new Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    new Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                      child: Text((index).toString() + '. ' + _data[index]['country_name'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                      child: (showIcon) 
                        ? Container(
                          child: FaIcon(FontAwesomeIcons.solidStar),
                        ) 
                        :  Text(''),
                    )
                  ],
                ),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Expanded(
                      child: RichText(
                        textAlign: TextAlign.left,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Confirmed: ', style: TextStyle(color: Colors.black), 
                            ),
                            TextSpan(
                              text: _data[index]['cases'], style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold), 
                            ),
                          ]
                        ),
                      )
                    ),
                    Expanded(
                      child: RichText(
                        textAlign: TextAlign.left,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Recovered: ', style: TextStyle(color: Colors.black), 
                            ),
                            TextSpan(
                              text: _data[index]['total_recovered'], style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold), 
                            ),
                          ]
                        ),
                      )
                    ),
                  ],
                ),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Expanded(
                      child: RichText(
                        textAlign: TextAlign.left,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Deaths: ', style: TextStyle(color: Colors.black), 
                            ),
                            TextSpan(
                              text: _data[index]['deaths'], style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold), 
                            ),
                          ]
                        ),
                      )
                    ),
                    Expanded(
                      child: RichText(
                        textAlign: TextAlign.left,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Active Cases: ', style: TextStyle(color: Colors.black), 
                            ),
                            TextSpan(
                              text: _data[index]['active_cases'], style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold), 
                            ),
                          ]
                        ),
                      )
                    ),
                  ],
                )
              ],
            ),
            ),
          ),
        ),
    );
  }

  @protected
  Widget BuildHistoryList(BuildContext context){
    if( !(_hasData) ){
      return Center(
        child: Text('No available data to be displayed.',
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
        ),
      );
    }

    return new Container(
      child: new ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(), itemCount: _listItemCount,
        itemBuilder: (BuildContext context, int index) {
          return (index == (_listItemCount-1) && !(index == (_data.length - 1)) ) ? BuildListLoader(context, index) : BuildListItem(context, index);
        }
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: new AppBar(title: new Text("World Statistics")),
      body: Container(child: (_pageLoader) ? BuildPageLoader(context) : BuildHistoryList(context),),
    );
  }

  void setStateWrapper(Function function){
    if( this.mounted ){
      setState(() {
        function();
      });
    }
  }
}