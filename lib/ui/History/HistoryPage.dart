
import 'package:awesome_loader/awesome_loader.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:phcovid19tracker/common/BaseState.dart';
import 'package:phcovid19tracker/data/CountryStats.dart';
import 'package:phcovid19tracker/data/HistoryGraphData.dart';
import 'package:phcovid19tracker/generated/i18n.dart';
import 'package:phcovid19tracker/ui/History/HistoryPageContract.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:phcovid19tracker/utils/DateUtils.dart';
import 'package:phcovid19tracker/utils/StringUtil.dart';

import 'HistoryPresenter.dart';

class HistoryPage extends StatefulWidget {
  final String countryName;

  HistoryPage({Key key, this.countryName}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _HistoryPageState(countryName);
  }
}

class _HistoryPageState extends State<HistoryPage> implements HistoryPageContract, BaseState {

  final String countryName;
  BuildContext _context;
  int _initalCountList = 11, _appendCountList = 10, _graphShowCount = 5;

  bool _showGraphConfirmed, _showGraphDeaths, _showGraphRecovered, _showGraphNewCases, _showPageLoader, _showListLoader, _isLandscape;
  List<CountryStats> _list;

  HistoryPresenter _presenter;
  _HistoryPageState(this.countryName){
    _presenter = HistoryPresenter(this);
  }
  
  @override
  void initState() {
    super.initState();
    defaultState();
    fetchCountryHistory();
  }

  @override
  void defaultState() {
    _showGraphConfirmed = true;
    _showGraphDeaths = true;
    _showGraphRecovered = true;
    _showPageLoader = true;
    _showGraphNewCases = true;
    _showListLoader = false;
    _isLandscape = false;
    _list = [];
  }

  fetchCountryHistory(){
    setStateWrapper((){
      _showPageLoader = true;
    });
    _presenter.loadCountryHistory(countryName);
  }

  @override
  bool isLandscape() {
    return (MediaQuery.of(_context).orientation == Orientation.landscape);
  }

  @override
  Widget listLoader(BuildContext context, int index) {
    if( _showListLoader ){
      var totalMinusLoaded = (_list.length) - _initalCountList;
      if( totalMinusLoaded >= _appendCountList ){
        _initalCountList = _initalCountList + _appendCountList;
      }else{
        _initalCountList = _initalCountList + totalMinusLoaded;
      }
      
      Future.delayed(const Duration(milliseconds: 500), () => {
        setStateWrapper((){ _showListLoader = false; _initalCountList = _initalCountList; })
      });

      return Container(
        margin: EdgeInsets.fromLTRB(0, 4.0, 0, 0),
        child: Center(
          child: AwesomeLoader( loaderType: AwesomeLoader.AwesomeLoader4, color: Colors.blue, ),
        ),
      );
    }

    if( index < (_list.length)-1 ){
      return Container(
        margin: EdgeInsets.fromLTRB(0, 4.0, 0, 0),
        color: Colors.blue,
        child: FlatButton(
            child: Text(S.of(context).LABEL_LOAD_MORE, style: TextStyle(color: Colors.white),),
            onPressed: () {
              setStateWrapper((){
                _showListLoader = true;
              });
            },
        ),
      ); 
    }

    return Container();
  }

  @override
  Widget pageLoader() {
    return Center(
      child: AwesomeLoader(
        loaderType: AwesomeLoader.AwesomeLoader4,
        color: Colors.blue,
      ),
    );
  }

  @override
  void progressDialog() {

  }

  @override
  void setStateWrapper(Function func) {
    if( this.mounted ){
      setState((){ func(); });
    }
  }

  @override
  void onLoadStatsComplete(List<CountryStats> item) {
    setStateWrapper((){ 
      _showPageLoader = false; 
      _list = item;
    });
  }

  @override
  void onLoadStatsError(String onError) {
    setStateWrapper((){ _showPageLoader = false; });
  }

  List<charts.Series<HistoryGraphData, String>> createChartData(){
    List<HistoryGraphData> recoveredData = [], deathsData  = [], confirmedData  = [], newCasesData = [];

    String dateFormatted;
        (_list).asMap().forEach((index, value) => {
          (index < (_graphShowCount)) ? {
            dateFormatted = DateUtils.formatDateTime("MMM dd", DateUtils.timestampToDateTime(value.recordDate)),
            confirmedData.add(new HistoryGraphData(dateFormatted, StringUtil.stringToInt(value.confirmed))),
            recoveredData.add(new HistoryGraphData(dateFormatted, StringUtil.stringToInt(value.recovered))),
            deathsData.add(new HistoryGraphData(dateFormatted, StringUtil.stringToInt(value.deaths))),
            newCasesData.add(new HistoryGraphData(dateFormatted, StringUtil.stringToInt(value.deaths))),
      } : {}
    });   

    List<charts.Series<HistoryGraphData, String>> returnData = [];

    if( _showGraphConfirmed ){
      returnData.add(new charts.Series<HistoryGraphData, String>(
        id: S.of(context).LABEL_BUTTON_CONFIRMED,
        colorFn: (_, __) => charts.MaterialPalette.yellow.shadeDefault,
        domainFn: (HistoryGraphData item, _) => item.historyDate,
        measureFn: (HistoryGraphData item, _) => item.count,
        data: confirmedData.reversed.toList(),
      ));
    }

    if( _showGraphRecovered ){
      returnData.add(new charts.Series<HistoryGraphData, String>(
        id: S.of(context).LABEL_BUTTON_CONFIRMED,
        colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
        domainFn: (HistoryGraphData item, _) => item.historyDate,
        measureFn: (HistoryGraphData item, _) => item.count,
        data: recoveredData.reversed.toList(),
      ));
    }

    if( _showGraphDeaths ){
      returnData.add(new charts.Series<HistoryGraphData, String>(
        id: S.of(context).LABEL_BUTTON_DEATHS,
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        domainFn: (HistoryGraphData item, _) => item.historyDate,
        measureFn: (HistoryGraphData item, _) => item.count,
        data: deathsData.reversed.toList(),
      ));
    }

    if( _showGraphNewCases ){
      returnData.add(new charts.Series<HistoryGraphData, String>(
        id: S.of(context).LABEL_BUTTON_NEW_CASES,
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (HistoryGraphData item, _) => item.historyDate,
        measureFn: (HistoryGraphData item, _) => item.count,
        data: deathsData.reversed.toList(),
      ));
    }  
 
    return returnData;
  }

  Widget buildCharts(BuildContext context){
    return Container(
      child: Padding(
        padding:  (_isLandscape) ? const EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 0) : const EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            buildChartsTitle(context),
            Expanded(
              child: charts.BarChart(
                createChartData(),
                animate: true,
                defaultRenderer: new charts.BarRendererConfig(
                  groupingType: charts.BarGroupingType.groupedStacked,
                ),
                animationDuration: Duration(milliseconds: 500),
              )
            ),
            buildChartsLegends(context)
          ],
        )
      )
    );
  }

  Widget buildChartsTitle(BuildContext context){
    return Text(
      S.of(context).LABEL_COUNTRY_COVID_HISTORY(countryName),
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 20.0
      ),
    );
  }

  Widget buildChartsLegends(BuildContext context){
    if( _isLandscape ){
      return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            buildChartsLegendsItem(text: S.of(context).LABEL_BUTTON_CONFIRMED, status: _showGraphConfirmed, active: Colors.yellow, 
              onChangedCallback: (){
                setStateWrapper((){
                  _showGraphConfirmed = !(_showGraphConfirmed);
                });
              }),
            buildChartsLegendsItem(text: S.of(context).LABEL_BUTTON_RECOVERED, status: _showGraphRecovered, active: Colors.green, 
              onChangedCallback: (){
                setStateWrapper((){
                  _showGraphRecovered = !(_showGraphRecovered);
                });
              }),
              buildChartsLegendsItem(text: S.of(context).LABEL_BUTTON_DEATHS, status: _showGraphDeaths, active: Colors.red, 
              onChangedCallback: (){
                setStateWrapper((){
                  _showGraphDeaths = !(_showGraphDeaths);
                });
              }),
            buildChartsLegendsItem(text: S.of(context).LABEL_BUTTON_NEW_CASES, status: _showGraphNewCases, active: Colors.blue, 
              onChangedCallback: (){
                setStateWrapper((){
                  _showGraphNewCases = !(_showGraphNewCases);
                });
              }),
          ]
        );
    }

    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            buildChartsLegendsItem(text: S.of(context).LABEL_BUTTON_CONFIRMED, status: _showGraphConfirmed, active: Colors.yellow, 
              onChangedCallback: (){
                setStateWrapper((){
                  _showGraphConfirmed = !(_showGraphConfirmed);
                });
              }),
            buildChartsLegendsItem(text: S.of(context).LABEL_BUTTON_RECOVERED, status: _showGraphRecovered, active: Colors.green, 
              onChangedCallback: (){
                setStateWrapper((){
                  _showGraphRecovered = !(_showGraphRecovered);
                });
              }),
          ]
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            buildChartsLegendsItem(text: S.of(context).LABEL_BUTTON_DEATHS, status: _showGraphDeaths, active: Colors.red, 
              onChangedCallback: (){
                setStateWrapper((){
                  _showGraphDeaths = !(_showGraphDeaths);
                });
              }),
            buildChartsLegendsItem(text: S.of(context).LABEL_BUTTON_NEW_CASES, status: _showGraphNewCases, active: Colors.blue, 
              onChangedCallback: (){
                setStateWrapper((){
                  _showGraphNewCases = !(_showGraphNewCases);
                });
              }),
          ],
        )
      ],
    );
  }

  Widget buildChartsLegendsItem({String text, bool status, MaterialColor active, Function onChangedCallback}){
    return Row(
      children: <Widget>[
        Checkbox(
          value: status,
          checkColor: Colors.grey.shade900,
          activeColor: active,
          onChanged: (value) => {
            onChangedCallback()
          }
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(5.0, 0, 0, 0),
          child: GestureDetector(
            onTap: () {
              onChangedCallback();
            },
            child: Text(text, style: TextStyle( fontWeight: FontWeight.bold)),
          )
        ),
      ],
    );
  }

  Widget buildHistoryList(BuildContext context){
    if( _list.length == 0 ){
      return Center(
        child: Text(
          S.of(context).LABEL_NO_AVAILABLE_DATA,
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
        ),
      );
    }

    return new Container(
      child: new ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: _initalCountList,
        itemBuilder: (BuildContext context, int index) {
          return (index == (_initalCountList-1) && !(index == (_list.length - 1)) ) ? listLoader(context, index) : buildHistoryListItem(context, index);
        }
      ),
    );
  }

  Widget buildRecordEntry(String label, String value){
    return Expanded(
      child: RichText(
        textAlign: TextAlign.left,
        text: TextSpan(
          children: [
            TextSpan(
              text: label, style: TextStyle(color: Colors.black), 
            ),
            TextSpan(
              text: value, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold), 
            ),
          ]
        ),
      )
    );
  }

  Widget buildHistoryListItem(BuildContext context, int index){
    CountryStats data = _list[index];

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
                  child: Text(data.formatRecordDate(), style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),),
                  ),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    buildRecordEntry(S.of(context).LABEL_CONFIRMED, data.confirmed),
                    buildRecordEntry(S.of(context).LABEL_RECOVERED, data.recovered)
                  ],
                ),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    buildRecordEntry(S.of(context).LABEL_ACTIVE_CASES, data.activeCases),
                    buildRecordEntry(S.of(context).LABEL_DEATHS, data.deaths),
                  ],
                ),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    buildRecordEntry(S.of(context).LABEL_NEW_CASES, data.newCases),
                    buildRecordEntry(S.of(context).LABEL_NEW_DEATHS, data.newDeaths),
                  ],
                )
              ],
            ),
          )
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    _context = context;

    setStateWrapper((){
      _isLandscape = isLandscape();
      if( _isLandscape ){
        _graphShowCount = 12;
      }else{
        _graphShowCount = 5;
      }
    });

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(S.of(context).LABEL_COVID_HISTORY),
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
            (_showPageLoader) ? pageLoader() : buildHistoryList(context),
            buildCharts(context)
          ],
        ),
      ),
    );
  }
}