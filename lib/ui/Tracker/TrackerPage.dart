import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:phcovid19tracker/common/BaseState.dart';
import 'package:phcovid19tracker/data/LatestCountryStats.dart';
import 'package:phcovid19tracker/ui/Tracker/TrackerPageContract.dart';
import 'package:phcovid19tracker/utils/DialogUtil.dart';
import 'package:phcovid19tracker/utils/ToastUtil.dart';
import 'package:phcovid19tracker/widgets/CustomAppBar.dart';
import 'package:phcovid19tracker/widgets/Drawers.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:flutter_config/flutter_config.dart';
import 'TrackerPresenter.dart';
import 'package:phcovid19tracker/generated/i18n.dart';

class TrackerPage extends StatefulWidget {
  TrackerPage({Key key}) : super(key: key);
  _TrackerPageState instance = _TrackerPageState();

  @override
  _TrackerPageState createState() => instance;
}

class _TrackerPageState extends State<TrackerPage> implements TrackerPageContract, BaseState {

  TrackerViewPresenter _presenter;
  BuildContext _context;
  bool _isFetching;
  ProgressDialog _progressDialog; 
  String totalCases, totalDeaths, totalRecovered, totalActiveCases, recordDate, newCases, newDeaths;

  static const String KEY_DEATHS = "deaths";
  static const String KEY_RECOVERED = "recovered";
  static const String KEY_ACTIVE = "active_cases";
  static const String KEY_CONFIRMED = "confirmed";

  _TrackerPageState() {
    _presenter = TrackerViewPresenter(this);
  }

  @override
  void initState() {
    super.initState();
    defaultState();
    Future.delayed(const Duration(milliseconds: 500), fetchCountryStats);
  } 

  @override
  void defaultState() {
    _isFetching = false; 
    totalCases = "0";
    totalDeaths = "0";
    totalRecovered = "0";
    totalActiveCases = "0";
    recordDate = "";
    newCases = "0";
    newDeaths = "0";
  }

  @override
  Widget listLoader(BuildContext context, int index) {
    return null;
  }

  @override
  void progressDialog() {
    if( _isFetching ){
      _progressDialog = DialogUtil.awesomeLoader(_context, S.of(context).LABEL_PULL_SERVER_DATA);
      _progressDialog.show();
    } else {
      if( _progressDialog != null ){
        _progressDialog.hide();
      } 
    }
  }

  fetchCountryStats(){
    setState(() {
      defaultState();
      _isFetching = true;
    });
    progressDialog();
    _presenter.loadCountryStats(FlutterConfig.get('API_COUNTRY_KEY'));
  }

  @override
  void setStateWrapper(Function func) {
    if(this.mounted){
      setState((){
        func();
      });
    }
  }

  @override
  bool isLandscape() {
    return MediaQuery.of(_context).orientation == Orientation.landscape;
  }

  @override
  void onLoadStatsComplete(LatestCountryStats item) {
    setStateWrapper((){
      _isFetching = false;
      totalActiveCases = item.activeCases; 
      totalCases = item.confirmed;
      totalDeaths = item.deaths;
      totalRecovered = item.recovered;
      newCases = item.newCases;
      newDeaths = item.newDeaths;
      recordDate = item.formatRecordDate();
    }); 
    progressDialog();
  } 

  @override
  void onLoadStatsError(String onError) {
    progressDialog();
    ToastUtil.showFlutterToast(message: S.of(context).LABEL_ERROR_FETCHING_DATA(onError));
  }

  Widget buildCardEntry(context, type, data){
    String title = S.of(context).LABEL_TOTAL_CONFIRMED;
    IconData icon = FontAwesomeIcons.viruses;
    MaterialColor cardColor = Colors.yellow;
    String newUpdates = "";
    switch(type.toString().toLowerCase()){
      case KEY_DEATHS:
        icon = FontAwesomeIcons.skullCrossbones;
        title = S.of(context).LABEL_TOTAL_DEATHS;
        cardColor = Colors.red;
        newUpdates = S.of(context).LABEL_NEW_RECORD(newDeaths);
        break;
      case KEY_RECOVERED:
        icon = FontAwesomeIcons.userShield;
        title = S.of(context).LABEL_TOTAL_RECOVERED;
        cardColor = Colors.green;
        break;
      case KEY_ACTIVE:
        icon = FontAwesomeIcons.users;
        title = S.of(context).LABEL_TOTAL_ACTIVE_CASES;
        cardColor = Colors.blue;
        break;
      default:
        newUpdates = S.of(context).LABEL_NEW_RECORD(newDeaths);
        break;
    } 

    return Card(
      color: cardColor,
      elevation: 10.0,
      child: Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.fromLTRB(10.0, 25.0, 10.0, 25.0),
        child: new Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Icon(icon, size: 30.0)
            ),
            Expanded(
              flex: (isLandscape()) ? 4 : 3,
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      new Text(data.toString(), textAlign: TextAlign.left, style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 15.0, 0),
                        child: new Text(newUpdates, textAlign: TextAlign.right, style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),),
                      ),
                    ],
                  ),
                  new Text(title, textAlign: TextAlign.left)
                ],
              ),
            ),
          ],
        )
      )
    );
  }

  @protected
  Widget buildStats(){
    List<Widget> tiles = [
      Padding(
        padding: EdgeInsets.fromLTRB(0, 5.0, 0, 5.0),
        child: buildCardEntry(context, KEY_CONFIRMED, totalCases),
      ),
      Padding(
        padding: EdgeInsets.fromLTRB(0, 5.0, 0, 5.0),
        child: buildCardEntry(context, KEY_RECOVERED, totalRecovered),
      ),
      Padding(
        padding: EdgeInsets.fromLTRB(0, 5.0, 0, 5.0),
        child: buildCardEntry(context, KEY_DEATHS, totalDeaths),
      ),
      Padding(
        padding: EdgeInsets.fromLTRB(0, 5.0, 0, 5.0),
        child: buildCardEntry(context, KEY_ACTIVE, totalActiveCases),
      ),
    ];

    return (isLandscape()) ? 
    Table(
      children: [
          TableRow(children: [tiles[0],tiles[1]]),
          TableRow(children: [tiles[2],tiles[3]])
      ],
    ) 
    : 
    Table(
      children: [
        for( var item in tiles ) TableRow(children: [item])
      ],
    );
  }

  @protected
  Widget buildScrollableBody(BuildContext context){
    return
      ListView(
        padding: const EdgeInsets.all(8.0),
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(S.of(context).LABEL_LOCATION(FlutterConfig.get('API_COUNTRY_KEY')), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0), textAlign: TextAlign.left,),
          ),
          buildStats(),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              S.of(context).LABEL_RECORD_DATE(recordDate),
              textAlign: TextAlign.end,
              style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
            ),
          ),
        ],
    );
  }

  @override
  Widget pageLoader() {
    // TODO: implement pageLoader
    return null;
  }
 
  @override
  Widget build(BuildContext context) {
    _context = context;
    return Scaffold(
      appBar: CustomAppBar(
        text: S.of(context).APP_NAME, 
        actions: [CustomAppBar.buildIconButton(icon: Icon(Icons.refresh), callback: () => { fetchCountryStats() } )]
      ),
      body: buildScrollableBody(context),
      drawer: CustomDrawers()
    ); 
  }
}