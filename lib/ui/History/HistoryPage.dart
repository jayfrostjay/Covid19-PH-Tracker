
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
import 'package:sticky_headers/sticky_headers/widget.dart';

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
  int _initalCountList = 11, _appendCountList = 5, _graphShowCount = 5;

  bool _showGraphConfirmed, _showGraphDeaths, _showGraphRecovered, _showGraphNewCases, _showPageLoader, _isLandscape;
  List<CountryStats> _list, _originalList;
  bool _isAscending;

  static const String KEY_DATE = 'date';
  static const String KEY_CONFIRMED = 'confirmed';
  static const String KEY_RECOVERED = 'recovered';
  static const String KEY_DEATHS = 'deaths';
  static const String KEY_ACTIVE = 'active';
  static const String KEY_NEW_CASES = 'newCases';
  static const String KEY_NEW_DEATHS = 'newDeaths';

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
    _isLandscape = false;
    _isAscending = true;
    _list = [];
    _originalList = [];
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
    _list = [];
    setStateWrapper((){ 
      _showPageLoader = false; 
      _list.addAll(item);
      _originalList.addAll(item);
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
          (index < (_graphShowCount) && index != 0 ) ? {
            dateFormatted = DateUtils.formatDateTime("MMM dd", DateUtils.timestampToDateTime(value.recordDate)),
            confirmedData.add(new HistoryGraphData(dateFormatted, StringUtil.stringToInt(value.confirmed))),
            recoveredData.add(new HistoryGraphData(dateFormatted, StringUtil.stringToInt(value.recovered))),
            deathsData.add(new HistoryGraphData(dateFormatted, StringUtil.stringToInt(value.deaths))),
            newCasesData.add(new HistoryGraphData(dateFormatted, StringUtil.stringToInt(value.newCases))),
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
        data: newCasesData.reversed.toList(),
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
                animationDuration: Duration(milliseconds: 500),
                vertical: true,
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
        itemCount: 1,
        itemBuilder: (BuildContext context, int index) {
          return StickyHeader(
            header: Container(
              color: Colors.white,
              alignment: Alignment.centerLeft,
              child: Container(
                child: buildListItem(
                  recordDate: S.of(context).LABEL_RECORD_DATE,
                  confirmed: S.of(context).LABEL_CONFIRMED,
                  deaths: S.of(context).LABEL_DEATHS,
                  recovered: S.of(context).LABEL_RECOVERED,
                  activeCases: S.of(context).LABEL_ACTIVE_CASES,
                  newDeaths: S.of(context).LABEL_NEW_DEATHS,
                  newCases: S.of(context).LABEL_NEW_CASES,
                  isBold: true,
                  isClickable: true
                ),
              )
            ),
            content: Column(
              children: [
                for(var i=0; i<_list.length; i++ ) buildHistoryListItem(context, i)
              ],
            ),
          );
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

  void sortList({String key}){
    List<CountryStats> tempList = [];
    tempList.addAll(_originalList);
    bool hasChanges = true;

    switch(key){
      case KEY_DATE:
        tempList = [];
        (_isAscending) ? tempList.addAll(_originalList) : tempList.addAll(_originalList.reversed);
        break;
      case KEY_CONFIRMED:
        tempList.sort((a, b){
          return (_isAscending) ? (StringUtil.stringToInt(a.confirmed)).compareTo(StringUtil.stringToInt(b.confirmed)) : (StringUtil.stringToInt(b.confirmed)).compareTo(StringUtil.stringToInt(a.confirmed));
        }); 
        break;
      case KEY_RECOVERED:
        tempList.sort((a, b){
          return (_isAscending) ? (StringUtil.stringToInt(a.recovered)).compareTo(StringUtil.stringToInt(b.recovered)) : (StringUtil.stringToInt(b.recovered)).compareTo(StringUtil.stringToInt(a.recovered));
        }); 
        break;
      case KEY_DEATHS:
        tempList.sort((a, b){
          return (_isAscending) ? (StringUtil.stringToInt(a.deaths)).compareTo(StringUtil.stringToInt(b.deaths)) : (StringUtil.stringToInt(b.deaths)).compareTo(StringUtil.stringToInt(a.deaths));
        }); 
        break;
      case KEY_ACTIVE:
        tempList.sort((a, b){
          return (_isAscending) ? (StringUtil.stringToInt(a.activeCases)).compareTo(StringUtil.stringToInt(b.activeCases)) : (StringUtil.stringToInt(b.activeCases)).compareTo(StringUtil.stringToInt(a.activeCases));
        }); 
        break;
      case KEY_NEW_CASES:
        tempList.sort((a, b){
          return (_isAscending) ? (StringUtil.stringToInt(a.newCases)).compareTo(StringUtil.stringToInt(b.newCases)) : (StringUtil.stringToInt(b.newCases)).compareTo(StringUtil.stringToInt(a.newCases));
        }); 
        break;
      case KEY_NEW_DEATHS:
        tempList.sort((a, b){
          return (_isAscending) ? (StringUtil.stringToInt(a.newDeaths)).compareTo(StringUtil.stringToInt(b.newDeaths)) : (StringUtil.stringToInt(b.newDeaths)).compareTo(StringUtil.stringToInt(a.newDeaths));
        }); 
        break;
      default:
        hasChanges = false;
        break;
    }

    if( hasChanges ){
      setStateWrapper((){
        _list = tempList;
        _isAscending = !(_isAscending);
      });
    }
  }

  Widget buildListItemDetail({String text, bool isBold = false, int flex = 1, Function onTap, bool isClickable = false }){
    return Expanded(
      flex: flex,
      child: Align(
        alignment: Alignment.center,
        child: GestureDetector(
          onTap: ( isClickable ) ? onTap : () => { },
          child: Text(text, style: TextStyle(fontWeight: (isBold) ? FontWeight.bold : FontWeight.normal),),
        ),
      ),
    );
  }

  Widget buildListItem({int index, String recordDate, String confirmed, String activeCases, String recovered, String deaths, String newCases, String newDeaths, bool isBold = false, bool isClickable = false }){
    List<Widget> landscapeView = [];
    if( isLandscape() ){
      landscapeView.add(buildListItemDetail(text: activeCases, isBold: isBold, onTap: () => { sortList(key: KEY_ACTIVE) }, isClickable: isClickable ));
      landscapeView.add(buildListItemDetail(text: newCases, isBold: isBold, onTap: () => { sortList(key: KEY_NEW_CASES) }, isClickable: isClickable ));
      landscapeView.add(buildListItemDetail(text: newDeaths, isBold: isBold, onTap: () => { sortList(key: KEY_NEW_DEATHS) }, isClickable: isClickable ));
    } 

    return Column(
      children: [
          Container(
            padding: EdgeInsets.fromLTRB(10.0, 20.0, 0.0, 10.0),
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                buildListItemDetail(text: recordDate, isBold: true, onTap: () => { sortList(key: KEY_DATE) }, isClickable: isClickable),
                buildListItemDetail(text: confirmed, isBold: isBold, onTap: () => { sortList(key: KEY_CONFIRMED) }, isClickable: isClickable),
                buildListItemDetail(text: recovered, isBold: isBold, onTap: () => { sortList(key: KEY_RECOVERED) }, isClickable: isClickable),
                buildListItemDetail(text: deaths, isBold: isBold, onTap: () => { sortList(key: KEY_DEATHS) }, isClickable: isClickable),
                for( var item in landscapeView ) item
              ],
            ),
          ),
          Divider(
            color: Colors.black,
          )
      ]
    );
  }

  Widget buildHistoryListItem(BuildContext context, int index){
    CountryStats data = _list[index];
    return buildListItem(
      index: index,
      recordDate: data.formatRecordDate().toString(),
      confirmed: data.confirmed.toString(),
      activeCases: data.activeCases.toString(),
      recovered: data.recovered.toString(),
      deaths: data.deaths.toString(),
      newCases: data.newCases.toString(),
      newDeaths: data.newDeaths.toString(),
      isBold: false,
      isClickable: false 
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