import 'dart:ffi';

import 'package:awesome_loader/awesome_loader.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert' show json;
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:charts_flutter/flutter.dart' as charts;

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
  var _showLoader = true, _dataLoaded = 10, _showLoaderList = false, _graphShowCount = 3; //default number of list
  List<dynamic> _data = [];
  bool _hasHistory = true, _showGraphConfirmed = true, _showGraphRecovered = true, _showGraphDeaths = true;

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

        setStateWrapper((){
          _showLoader = false;
          _data = tempData;
          if( _data.length == 0 ){
            _hasHistory = false;
          }else{
            _hasHistory = true;
          }
        });
    }else{
      setStateWrapper((){
        _hasHistory = false;
      });
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
        setStateWrapper((){
          _showLoaderList = false;
          _dataLoaded = _dataLoaded;
        })
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
              setStateWrapper((){
                _showLoaderList = true;
              });
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
    determinePageOrientation();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: new Text("PH Covid History"),
          bottom: TabBar(
            tabs: [
              Tab(icon: FaIcon(FontAwesomeIcons.list)),
              Tab(icon: FaIcon(FontAwesomeIcons.chartBar)),
            ],
          ),
        ),
        body: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: <Widget>[
            (_showLoader) ? BuildLoader(context) : BuildHistoryList(context),
            BuildCharts(context)
          ],
        ),
      ),
    );
  }

  @protected
  Widget BuildCharts(BuildContext context){
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            Text(
              'PH Statistics for Covid-19 PH',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0
              ),
            ),
            Expanded(
              child: charts.BarChart(
                _createItems(),
                animate: true,
                barGroupingType: charts.BarGroupingType.grouped,
                animationDuration: Duration(milliseconds: 500),
              )
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Row(
                  children: <Widget>[
                      Checkbox(
                      value: _showGraphConfirmed,
                      checkColor: Colors.grey.shade900,
                      activeColor: Colors.yellow,
                      onChanged: (value) => {
                        setStateWrapper((){
                          _showGraphConfirmed = value;
                        })
                      }
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(5.0, 0, 0, 0),
                      child: GestureDetector(
                        onTap: () {
                          setStateWrapper((){
                            _showGraphConfirmed = !(_showGraphConfirmed);
                          });
                        },
                        child: Text('Confirmed',style: TextStyle( fontWeight: FontWeight.bold)),
                      )
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Checkbox(
                      value: _showGraphRecovered,
                      checkColor: Colors.grey.shade900,
                      activeColor: Colors.green,
                      onChanged: (value) => {
                        setStateWrapper((){
                          _showGraphRecovered = value;
                        })
                      }
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(5.0, 0, 0, 0),
                      child: GestureDetector(
                        onTap: () {
                          setStateWrapper((){
                            _showGraphRecovered = !(_showGraphRecovered);
                          });
                        },
                        child: Text('Recovered',style: TextStyle( fontWeight: FontWeight.bold)),
                      )
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Checkbox(
                      value: _showGraphDeaths,
                      checkColor: Colors.grey.shade900,
                      activeColor: Colors.red,
                      onChanged: (value) => {
                        setStateWrapper((){
                          _showGraphDeaths = value;
                        })
                      }
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(5.0, 0, 0, 0),
                      child: GestureDetector(
                        onTap: () {
                          setStateWrapper((){
                            _showGraphDeaths = !(_showGraphDeaths);
                          });
                        },
                        child: Text('Deaths',style: TextStyle( fontWeight: FontWeight.bold)),
                      )
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<charts.Series<HistoryItem, String>> _createItems(){
    List<HistoryItem> recoveredData = [], deathsData  = [], confirmedData  = [];
    (_data).asMap().forEach((index, value) => {
      (index < (_graphShowCount)) ? {
        confirmedData.add(
          new HistoryItem(DateFormat("MMM dd, yyyy").format(DateTime.parse(rawFormatData(value["record_date"]))), int.parse( (value['total_cases']).replaceAll(',', '') ))
        ),
        recoveredData.add(
          new HistoryItem(DateFormat("MMM dd, yyyy").format(DateTime.parse(rawFormatData(value["record_date"]))), int.parse( (value['total_recovered']).replaceAll(',', '') ))
        ),
        deathsData.add(
          new HistoryItem(DateFormat("MMM dd, yyyy").format(DateTime.parse(rawFormatData(value["record_date"]))), int.parse( (value['total_deaths']).replaceAll(',', '') ))
        )
      } : {}
    });   

    List<charts.Series<HistoryItem, String>> returnData = [];

    if( _showGraphConfirmed ){
      returnData.add(new charts.Series<HistoryItem, String>(
        id: 'Confirmed',
        colorFn: (_, __) => charts.MaterialPalette.yellow.shadeDefault,
        domainFn: (HistoryItem item, _) => item.historyDate,
        measureFn: (HistoryItem item, _) => item.count,
        data: confirmedData.reversed.toList(),
      ));
    }

    if( _showGraphRecovered ){
      returnData.add(new charts.Series<HistoryItem, String>(
        id: 'Recovered',
        colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
        domainFn: (HistoryItem item, _) => item.historyDate,
        measureFn: (HistoryItem item, _) => item.count,
        data: recoveredData.reversed.toList(),
      ));
    }

    if( _showGraphDeaths ){
      returnData.add(new charts.Series<HistoryItem, String>(
        id: 'Deaths',
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        domainFn: (HistoryItem item, _) => item.historyDate,
        measureFn: (HistoryItem item, _) => item.count,
        data: deathsData.reversed.toList(),
      ));
    }  
 
    return returnData;
  }

  void determinePageOrientation(){
    Orientation currentOrientation = MediaQuery.of(context).orientation;
    if( currentOrientation == Orientation.landscape ){
      setStateWrapper((){
        _graphShowCount = 8;
      });
    }else{
      setStateWrapper((){
        _graphShowCount = 3;
      });
    }
  }

  void setStateWrapper(Function function){
    if( this.mounted ){
      setState(() {
        function();
      });
    }
  }
}

class HistoryItem {
  final String historyDate;
  final int count;

  HistoryItem(this.historyDate, this.count);
}