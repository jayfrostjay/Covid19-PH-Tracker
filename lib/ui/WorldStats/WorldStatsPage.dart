import 'package:awesome_loader/awesome_loader.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:phcovid19tracker/common/BaseState.dart';
import 'package:phcovid19tracker/data/CountryStats.dart';
import 'package:phcovid19tracker/data/ListViewHolder.dart';
import 'package:phcovid19tracker/generated/i18n.dart';
import 'package:phcovid19tracker/ui/History/HistoryPage.dart';
import 'package:phcovid19tracker/ui/WorldStats/WorldStatsPresenter.dart';
import 'package:phcovid19tracker/utils/DateUtils.dart';
import 'package:phcovid19tracker/utils/StringUtil.dart';
import 'package:phcovid19tracker/widgets/CustomAppBar.dart';
import 'package:flutter_config/flutter_config.dart';

import 'WorldStatsPageContract.dart';

class WorldStatsPage extends StatefulWidget {
  WorldStatsPage({Key key}) : super(key: key);
  _WorldStatsPageState instance = _WorldStatsPageState();

  @override
  _WorldStatsPageState createState() => instance;
}

class _WorldStatsPageState extends State<WorldStatsPage> implements BaseState, WorldStatsPageContract {
  
  BuildContext _context;
  bool _listLoading, _pageLoading;
  int _listInitalCount, _listAppendCount;
  List<ListViewHolder> _list;
  WorldStatsPresenter _presenter;

  _WorldStatsPageState(){
    _presenter = WorldStatsPresenter(this);
  }

  @override
  void initState() {
    super.initState();
    defaultState();
    fetchWorldStats();
  }

  @override
  void defaultState() {
    _pageLoading = false;
    _listLoading = false;
    _listInitalCount = 22;
    _listAppendCount = 20;
    _list = [];
  }

  fetchWorldStats(){
    setStateWrapper((){
      _pageLoading = true;
    });
    _presenter.loadWorldStats();
  }

   @override
  void onLoadStatsComplete(Map<String, dynamic> item) {
    List<ListViewHolder> holder = [];
    holder.add(ListViewHolder(viewType: ListViewHolderViewType.header, data: DateUtils.formatDateTime("E MMM dd, yyyy - hh:mm:ss a", DateUtils.timestampToDateTime(item["date"]))));

    // order by total cases
    (item["history"]).sort((a, b) => StringUtil.stringToInt(b['cases']).compareTo(StringUtil.stringToInt(a['cases'])));
    (item["history"]).forEach((stat) => {
      holder.add(ListViewHolder(viewType: ListViewHolderViewType.item, data: stat))
    });

    setStateWrapper((){
      _pageLoading = false;
      if( item["history"].length == 0 ){
        _list = [];
      }else{
        _list = holder;
      }
    });
  }

  @override
  void onLoadStatsError(String onError) {
    setStateWrapper((){
      _pageLoading = false;
      _list = [];
    });
  }

  @override
  void setStateWrapper(Function func) {
    if(this.mounted) {
      setState((){ func(); });
    }
  }

  @override
  bool isLandscape(){
    return (MediaQuery.of(_context).orientation == Orientation.landscape);
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
    // 
  }

  @override
  Widget listLoader(BuildContext context, int index) {
    if( _listLoading ){

      var totalMinusLoaded = (_list.length) - _listInitalCount;
      if( totalMinusLoaded >= _listAppendCount ){
        _listInitalCount = _listInitalCount + _listAppendCount;
      }else{
        _listInitalCount = _listInitalCount + totalMinusLoaded;
      }

      Future.delayed(const Duration(milliseconds: 500), () => { 
        setStateWrapper(() { _listLoading = false; _listInitalCount = _listInitalCount; }),
      });

      return Container(
        margin: EdgeInsets.fromLTRB(0, 4.0, 0, 0),
        child: Center(
          child: AwesomeLoader( loaderType: AwesomeLoader.AwesomeLoader4, color: Colors.blue, ),
        ),
      );
    }

    if( index < _list.length ){
      return Container(
        margin: EdgeInsets.fromLTRB(0, 4.0, 0, 0),
        color: Colors.blue,
        child: FlatButton(
            child: Text(S.of(context).LABEL_LOAD_MORE, style: TextStyle(color: Colors.white),),
            onPressed: () {
              setStateWrapper((){
                _listLoading = true;
              }); 
            },
        ),
      );
    }

    return Container();
  }

  void _navigateToHistoryScreen(BuildContext context, String locationKey){
    Navigator
      .of(context)
      .push(MaterialPageRoute(builder: (context) => 
            HistoryPage(countryName: locationKey))
    );
  }

  Widget listDataItemHeader(int number, String text, bool isPH){
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(S.of(context).LABEL_RANK_TEMPLATE((number).toString(), text), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),),
          Opacity(
            opacity: 0.3,
            child: (isPH) ? Container( child: FaIcon(FontAwesomeIcons.solidStar),) : FaIcon(FontAwesomeIcons.angleRight),
          )
        ],
      ),
    );
  }

  Widget listDataItemContent(String label, String text){
    return Expanded(
      child: RichText(
        textAlign: TextAlign.left,
        text: TextSpan(
          children: [
            TextSpan( text: label, style: TextStyle(color: Colors.black), ),
            TextSpan( text: text, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold), ),
          ]
        ),
      )
    );
  }

  Widget buldListItem(BuildContext context, int index){
    var listViewTemplate;

    if( _list[index].viewType == ListViewHolderViewType.header ){
      listViewTemplate = Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          S.of(context).LABEL_RECORD_DATE(_list[index].data),
          textAlign: TextAlign.right,
          style: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.bold
          ),
        ),
      );
    } else if( _list[index].viewType == ListViewHolderViewType.item ){
      CountryStats item =  CountryStats.fromMap(_list[index].data);
      bool isPH = (item.countryName == FlutterConfig.get('API_COUNTRY_KEY'));

      listViewTemplate = 
        Card(
          elevation: 5,
          child: InkWell(
            onTap: () {
              _navigateToHistoryScreen(context, item.countryName);
            },
            child: Padding(
            padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  listDataItemHeader(index, item.countryName, isPH),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      listDataItemContent(S.of(context).LABEL_CONFIRMED, item.confirmed),
                      listDataItemContent(S.of(context).LABEL_RECOVERED, item.recovered),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      listDataItemContent(S.of(context).LABEL_ACTIVE_CASES, item.activeCases),
                      listDataItemContent(S.of(context).LABEL_DEATHS, item.deaths),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      listDataItemContent(S.of(context).LABEL_NEW_CASES, item.newCases),
                      listDataItemContent(S.of(context).LABEL_NEW_DEATHS, item.newDeaths),
                    ],
                  ),
                ],
              ),
            ),
          ),
      );
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
      child: listViewTemplate,
    );
  }

  Widget buildListView(BuildContext context){
    if( _list.length == 0 ){
      return Center(
        child: Text(S.of(context).LABEL_NO_AVAILABLE_DATA,
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
        ),
      );
    }else{
      return ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: _listInitalCount,
        itemBuilder: (BuildContext context, int index) {
          return (index == (_listInitalCount-1) && !(index == (_list.length - 1)) ) ? listLoader(context, index) : buldListItem(context, index);
        }
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    return Scaffold(
      appBar: CustomAppBar(
        text: S.of(context).LABEL_LINKS_WORLD_STATS, 
      ),
      body: (_pageLoading) ? pageLoader() : buildListView(context),
    ); 
  }
}