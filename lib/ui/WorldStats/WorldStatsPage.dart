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
import 'package:sticky_headers/sticky_headers/widget.dart';

import 'WorldStatsPageContract.dart';

class WorldStatsPage extends StatefulWidget {
  WorldStatsPage({Key key}) : super(key: key);
  _WorldStatsPageState instance = _WorldStatsPageState();

  @override
  _WorldStatsPageState createState() => instance;
}

class _WorldStatsPageState extends State<WorldStatsPage> implements BaseState, WorldStatsPageContract {
  
  BuildContext _context;
  bool _pageLoading;
  int _listInitalCount, _listAppendCount;
  List<ListViewHolder> _list;
  List<CountryStats> _rawList;
  WorldStatsPresenter _presenter;
  bool _isAscending;

  static const String KEY_COUNTRY = 'country';
  static const String KEY_CONFIRMED = 'confirmed';
  static const String KEY_RECOVERED = 'recovered';
  static const String KEY_DEATHS = 'deaths';
  static const String KEY_ACTIVE = 'active';
  static const String KEY_NEW_CASES = 'newCases';
  static const String KEY_NEW_DEATHS = 'newDeaths';

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
    _listInitalCount = 22;
    _listAppendCount = 20;
    _isAscending = true;
    _list = [];
    _rawList = [];
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
    List<CountryStats> rawHolder = [];
    // order by total cases
    (item["history"]).sort((a, b) => StringUtil.stringToInt(b['cases']).compareTo(StringUtil.stringToInt(a['cases'])));
    (item["history"]).forEach((stat) => {
      holder.add(ListViewHolder(viewType: ListViewHolderViewType.item, data: stat)), rawHolder.add(CountryStats.fromMap(stat))
    });

    setStateWrapper((){
      _pageLoading = false;
      if( item["history"].length == 0 ){
        _list = [];
      }else{
        _list = holder;
        _rawList = rawHolder;
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
  }

  @override
  Widget listLoader(BuildContext context, int index) {
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

  Widget buildListItemDetail({String text, bool isBold, bool isClickable = false, Function onTap, Alignment alignment}){
    return Expanded(
      flex: 1,
      child: Align(
        alignment: (alignment != null) ? alignment : Alignment.center,
        child: GestureDetector(
          onTap: (isClickable) ? onTap : () => { },
          child: Text(text, style: (isBold) ? TextStyle(fontWeight: FontWeight.bold) : TextStyle(fontWeight: FontWeight.normal),),
        ),
      ),
    );
  }

  Widget buildListItemLayout({String country, String confirmed, String recovered, String deaths, String activeCases, String newCases, String newDeaths, bool isBold = false, bool isClickable = false}){
    List<Widget> landscapeView = [];

    if( isLandscape() ){
      landscapeView.add(
        buildListItemDetail(text: activeCases, isBold: isBold, onTap: () => { sortList(key: KEY_ACTIVE) }, isClickable: isClickable)
      );
      landscapeView.add(
        buildListItemDetail(text: newCases, isBold: isBold, onTap: () => { sortList(key: KEY_NEW_CASES) }, isClickable: isClickable)
      );
      landscapeView.add(
        buildListItemDetail(text: newDeaths, isBold: isBold, onTap: () => { sortList(key: KEY_NEW_DEATHS) }, isClickable: isClickable)
      );
    }

    return Column(
      children: [
          Container(
            padding: EdgeInsets.fromLTRB(10.0, 20.0, 0.0, 10.0),
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                buildListItemDetail(text: country, isBold: true, onTap: () => { sortList(key: KEY_COUNTRY) }, isClickable: isClickable, alignment: Alignment.centerLeft),
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

  Widget buldListItem(BuildContext context, int index){
    CountryStats item;
    if( (_list[index].data) is CountryStats ){
      item =  (_list[index].data);
    }else{
      item =  CountryStats.fromMap(_list[index].data);
    }

    return buildListItemLayout(
      country: "${index+1}. ${item.countryName}",
      confirmed: item.confirmed,
      recovered: item.recovered,
      deaths: item.deaths,
      activeCases: item.activeCases,
      newCases: item.newCases,
      newDeaths: item.newDeaths
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
        itemCount: 1,
        itemBuilder: (BuildContext context, int index) {
          return StickyHeader(
            header: Container(
              color: Colors.white,
              alignment: Alignment.centerRight,
              child: Container(
                child: buildListItemLayout(
                  country: S.of(context).LABEL_COUNTRY,
                  confirmed: S.of(context).LABEL_CONFIRMED,
                  recovered: S.of(context).LABEL_RECOVERED,
                  deaths: S.of(context).LABEL_DEATHS,
                  activeCases: S.of(context).LABEL_ACTIVE_CASES,
                  newCases: S.of(context).LABEL_NEW_CASES,
                  newDeaths: S.of(context).LABEL_NEW_DEATHS,
                  isBold: true,
                  isClickable : true,
                ),
              )
            ),
            content: Column(
              children: [
                for(var i=0; i<_list.length; i++ ) buldListItem(context, i)
              ],
            ),
          );
        }
      );
    }
  }

  void sortList({ String key }){
    List<ListViewHolder> tempList = [];
    bool hasChanges = true;
    switch(key){
      case KEY_COUNTRY:
        _rawList.sort((a, b){
          return (_isAscending) ? (a.countryName.toLowerCase()).compareTo(b.countryName.toLowerCase()) : (b.countryName.toLowerCase()).compareTo(a.countryName.toLowerCase());
        }); 
        break;
      case KEY_CONFIRMED:
        _rawList.sort((a, b){
          return (_isAscending) ? (StringUtil.stringToInt(a.confirmed)).compareTo(StringUtil.stringToInt(b.confirmed)) : (StringUtil.stringToInt(b.confirmed)).compareTo(StringUtil.stringToInt(a.confirmed));
        }); 
        break;
      case KEY_DEATHS:
        _rawList.sort((a, b){
          return (_isAscending) ? (StringUtil.stringToInt(a.deaths)).compareTo(StringUtil.stringToInt(b.deaths)) : (StringUtil.stringToInt(b.deaths)).compareTo(StringUtil.stringToInt(a.deaths));
        }); 
        break;
      case KEY_RECOVERED:
        _rawList.sort((a, b){
          return (_isAscending) ? (StringUtil.stringToInt(a.recovered)).compareTo(StringUtil.stringToInt(b.recovered)) : (StringUtil.stringToInt(b.recovered)).compareTo(StringUtil.stringToInt(a.recovered));
        }); 
        break;
      case KEY_ACTIVE:
        _rawList.sort((a, b){
          return (_isAscending) ? (StringUtil.stringToInt(a.activeCases)).compareTo(StringUtil.stringToInt(b.activeCases)) : (StringUtil.stringToInt(b.activeCases)).compareTo(StringUtil.stringToInt(a.activeCases));
        }); 
        break;
      case KEY_NEW_CASES:
        _rawList.sort((a, b){
          return (_isAscending) ? (StringUtil.stringToInt(a.newCases)).compareTo(StringUtil.stringToInt(b.newCases)) : (StringUtil.stringToInt(b.newCases)).compareTo(StringUtil.stringToInt(a.newCases));
        }); 
        break;
      case KEY_NEW_DEATHS:
        _rawList.sort((a, b){
          return (_isAscending) ? (StringUtil.stringToInt(a.newDeaths)).compareTo(StringUtil.stringToInt(b.newDeaths)) : (StringUtil.stringToInt(b.newDeaths)).compareTo(StringUtil.stringToInt(a.newDeaths));
        }); 
        break;
      default:
        _isAscending = false;
        break;
    }

    _rawList.forEach((element) {
      tempList.add(new ListViewHolder(viewType: ListViewHolderViewType.item, data: element));
    });
    
    if( _isAscending ){
      setStateWrapper((){
        _list = tempList;
        _isAscending = !(_isAscending);
      });
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