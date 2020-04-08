import 'package:awesome_loader/awesome_loader.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert' show json;
import 'package:intl/intl.dart';

class CovidHistory extends StatefulWidget{
  final String apiKey, apiHost, locationKey;

  CovidHistory({Key key, this.apiKey, this.apiHost, this.locationKey}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return CovidHistoryState(apiKey, apiHost, locationKey);
  }
}

class CovidHistoryState extends State<CovidHistory> {

  final String apiKey, apiHost, locationKey;
  CovidHistoryState(this.apiKey, this.apiHost, this.locationKey);

  var _dataAppendCount = 10;
  var _showLoader = true, _dataLoaded = 10, _showLoaderList = false; //default number of list
  List<dynamic> _data;
  bool _hasHistory = true;

  @override
  void initState(){
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), _pullHistoryData);
  }

  @protected
  Future<bool> _pullHistoryData() async{
    final response = await http.get(
    Uri.encodeFull('https://coronavirus-monitor.p.rapidapi.com/coronavirus/cases_by_particular_country.php?country='+this.locationKey),
      headers: { 
        "Accept" : "application/json",
        "x-rapidapi-host" : this.apiHost,
        "x-rapidapi-key" : this.apiKey
      }
    );

    if( response.statusCode == 200 ){
        var data = json.decode(response.body);
        var countryData = data["stat_by_country"];
        var reversedCountryData = countryData.reversed.toList();
        List<dynamic> dateList = [], tempData = [];

        reversedCountryData.forEach((element) {
          var formattedData = DateFormat("yyyy-MM-dd").format(DateTime.parse(rawFormatData(element['record_date'])));

          if( !dateList.contains(formattedData) ){
            tempData.add(element);
            dateList.add(formattedData);
          }
        });

        if( this.mounted ){
          setState(() {
            _showLoader = false;
            _data = tempData;
            if( _data.length == 0 ){
              _hasHistory = false;
            }else{
              _hasHistory = true;
            }
          });
        }
    }else{
      if( this.mounted ){
        setState(() {
          _hasHistory = false;
        });
      }
      throw Exception('Failed to load data....');
    }
  }

  rawFormatData(date){
    var formattedData = (date).split('.')[0];
    formattedData = formattedData.replaceAll(' ', '');
    formattedData = formattedData.replaceAll('-', '');
    formattedData = formattedData.replaceAll(':', '');
    formattedData = formattedData.substring(0, 8) + 'T' + formattedData.substring(8);
    return formattedData;
  }

  formatData(date){
    var formattedData = rawFormatData(date);
    return DateFormat("EEEE, MMM dd, yyyy").format(DateTime.parse(formattedData));
  }

  @protected
  Widget BuildLoadMore(BuildContext context, int index){
    if( _showLoaderList ){
      var totalMinusLoaded = (_data.length) - _dataLoaded;
      if( totalMinusLoaded >= _dataAppendCount ){
        _dataLoaded = _dataLoaded + _dataAppendCount;
      }else{
        _dataLoaded = _dataLoaded + totalMinusLoaded;
      }

      Future.delayed(const Duration(milliseconds: 500), () => {
        ( this.mounted ) ? {
          setState((){
            _showLoaderList = false;
            _dataLoaded = _dataLoaded;
          })
        } : { }
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

    if( index < (_data.length)-1 ){
      return Container(
        margin: EdgeInsets.fromLTRB(0, 4.0, 0, 0),
        color: Colors.blue,
        child: FlatButton(
            child: Text("Load More...", style: TextStyle(color: Colors.white),),
            onPressed: () {
              if( this.mounted ){
                setState(() {
                  _showLoaderList = true;
                });
              }
            },
        ),
      ); 
    }
  }

  @protected
  Widget BuildHistoryItem(BuildContext context, int index) {
    return 
      Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 2.0, 8.0, 2.0),
        child: Card(
          elevation: 5,
          child: new Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                  child: Text(formatData(_data[index]["record_date"]), style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),),
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
                              text: _data[index]['total_cases'], style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold), 
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
                              text: _data[index]['total_deaths'], style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold), 
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
                              text: 'Active: ', style: TextStyle(color: Colors.black), 
                            ),
                            TextSpan(
                              text: _data[index]['active_cases'], style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold), 
                            ),
                          ]
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          )
        ),
      );
  }

  @protected
  Widget BuildHistoryList(BuildContext context){
    if( !(_hasHistory) ){
      return Center(
        child: Text(
          'No available data to be displayed.',
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
        ),
      );
    }

    return new Container(
      child: new ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: _dataLoaded,
        itemBuilder: (BuildContext context, int index) {
          return (index == (_dataLoaded-1) && !(index == (_data.length - 1)) ) ? BuildLoadMore(context, index) : BuildHistoryItem(context, index);
        }
      ),
    );
  }

  @protected
  Widget BuildLoader(BuildContext context){
    return new Container(
      alignment: Alignment.center,
      child: AwesomeLoader(
        loaderType: AwesomeLoader.AwesomeLoader4,
        color: Colors.blue,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: new AppBar(
        title: new Text("PH Covid History"),
      ),
      body: new Container(
        child: (_showLoader) ? 
                BuildLoader(context) : 
                BuildHistoryList(context)
      )
    );
  }
}