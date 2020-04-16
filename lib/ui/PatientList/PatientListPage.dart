import 'package:awesome_loader/awesome_loader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:phcovid19tracker/common/BaseState.dart';
import 'package:phcovid19tracker/data/DropdownValue.dart';
import 'package:phcovid19tracker/data/PatientDetails.dart';
import 'package:phcovid19tracker/generated/i18n.dart';
import 'package:phcovid19tracker/utils/DateUtils.dart';
import 'package:phcovid19tracker/utils/StringUtil.dart';
import 'package:phcovid19tracker/utils/ToastUtil.dart';

import 'PatientListContract.dart';
import 'PatientPresenter.dart';

class PatientListPage extends StatefulWidget {
  PatientListPage({Key key}) : super(key: key);

  final _PatientListPageState instance = _PatientListPageState();

  @override
  _PatientListPageState createState() => instance;
}

class _PatientListPageState extends State<PatientListPage> implements PatientListContract, BaseState {
  
  GoogleMap _map;

  bool _showPageLoader, _showListLoader;
  int _dropDownStatusValue, _dropdownLocationValue;
  List<DropdownValue> _regionDropdown, _statusDropdown;
  List<PatientDetails> _dataList;
  List<PatientDetails> _originalDataList;
  String _searchTextValue;

  final String GENDER_FEMALE = "F";
  final String GENDER_MALE = "M";

  PatientListPresenter _presenter;
  _PatientListPageState(){
    _presenter = PatientListPresenter(this);
  }

  @override
  void initState() {
    super.initState();
    // needs to have default value for dropdown list - flutter throwing error if list are null
    _statusDropdown = [
      createDefaultDropdownValue(index: 0, text: "")
    ];
    _regionDropdown = [
      createDefaultDropdownValue(index: 0, text: "")
    ]; 
     // needs to have default value for dropdown list - flutter throwing error if list are null
    defaultState();
    Future.delayed(Duration.zero, (){
      // _presenter.verifyLocationPermission();
      _presenter.loadPatientList();
    });

    _showPageLoader = true;
  }

  @override
  void defaultState() {
    _dataList = [];
    _originalDataList = [];
    _showPageLoader = false;
    _showListLoader = false;
    _dropDownStatusValue = 0;
    _dropdownLocationValue = 0;
    _searchTextValue = "";

    Future.delayed(Duration.zero, () {
      setStateWrapper((){
         _statusDropdown = [
          createDefaultDropdownValue(index: 0, text: S.of(context).DROPDOWN_ALL_STATUS)
        ];
        _regionDropdown = [
          createDefaultDropdownValue(index: 0, text: S.of(context).DROPDOWN_ALL_REGIONS)
        ];
      });
    });
  }

  DropdownValue createDefaultDropdownValue({int index, String text}){
    return DropdownValue(index: index, key: text, label: text);
  }

  @override
  bool isLandscape() {
    return MediaQuery.of(context).orientation == Orientation.landscape;
  }

  @override
  Widget listLoader(BuildContext context, int index) {
    return null;
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
      setState(() { func(); });
    }
  }

  @override
  void onCompleteDropdownRegion(List<DropdownValue> list) {
    List<DropdownValue> tempList = [];
    int counter = 0;
    tempList.add(DropdownValue(index: counter, key: S.of(context).DROPDOWN_ALL_REGIONS, label: S.of(context).DROPDOWN_ALL_REGIONS));
    list.asMap().forEach((index,value) {
      counter++;
      tempList.add(DropdownValue(index: counter, key: value.key, label: value.label));
    });

    setStateWrapper((){
      _regionDropdown = tempList;
    });
  }
  
  @override
  void onCompleteDropdownStatus(List<DropdownValue> list) {
    List<DropdownValue> tempList = [];
    int counter = 0;
    tempList.add(DropdownValue(index: counter, key: S.of(context).DROPDOWN_ALL_STATUS, label: S.of(context).DROPDOWN_ALL_STATUS));
    list.asMap().forEach((index,value) {
      counter++;
      tempList.add(DropdownValue(index: counter, key: value.key, label: value.label));
    });

    setStateWrapper((){
      _statusDropdown = tempList;
    });
  }

  @override
  void onLoadStatsComplete(List<PatientDetails> item) {
    setStateWrapper((){
      _dataList = item;
      _originalDataList = item;
      _showPageLoader = false;
    });
    // TODO: create list
  }

  @override
  void onLoadStatsError(String onError) {
    setStateWrapper((){
      _showPageLoader = false;
    });
    ToastUtil.showFlutterToast(message: S.of(context).LABEL_ERROR_FETCHING_DATA(onError));
  }

  String getTextValueDropdown({List<DropdownValue> list, int index}){
    return list[index].label;
  }

  List<PatientDetails> getFilteredPatientList({List<PatientDetails> list, String key, String text, int index = 0}){
    List<PatientDetails> output = [];

    list.asMap().forEach((listIndex, value) { 
      switch(key){
        case PatientListPresenter.KEY_KEYWORD:
          String dateAdmitted = DateUtils.tryParse(value.date);
          if( dateAdmitted == "false" ){
            dateAdmitted = value.date;
          }else{
            dateAdmitted = DateUtils.formatDateTime("E MMM dd, yyyy", DateTime.parse(dateAdmitted));
          }

          if( StringUtil.itemContainsString(value.hospitalAdmitted, text) ||
              StringUtil.itemContainsString(value.age, text) ||
              StringUtil.itemContainsString(value.nationality, text) ||
              StringUtil.itemContainsString(value.region, text) ||
              StringUtil.itemContainsString(value.status, text) ||
              StringUtil.itemContainsString(value.caseNo.toString(), text) ||
              StringUtil.itemContainsString(dateAdmitted, text) ){
              output.add(value);
          }
          break;
        case PatientListPresenter.KEY_DATE_ADMITTED:
          break;
        case PatientListPresenter.KEY_NAME:
          break;
        case PatientListPresenter.KEY_HOSPITAL:
          if( (value.hospitalAdmitted.trim().toLowerCase()).contains(text.trim().toLowerCase()) ){
            output.add(value);
          }
          break;
        case PatientListPresenter.KEY_AGE:
          if( (value.age.trim().toLowerCase()).contains(text.trim().toLowerCase()) ){
            output.add(value);
          }
          break;
        case PatientListPresenter.KEY_NATIONALITY:
          if( (value.nationality.trim().toLowerCase()).contains(text.trim().toLowerCase()) ){
            output.add(value);
          }
          break;
        case PatientListPresenter.KEY_REGION:
          if( index == 0 ){
            output.add(value);
          }else if( (value.region.trim().toLowerCase()) == text.trim().toLowerCase() ){
            output.add(value);
          }
          break;
        case PatientListPresenter.KEY_STATUS:
          if( index == 0 ){
            output.add(value);
          }else if( (value.status.trim().toLowerCase()) == text.trim().toLowerCase() ){
            output.add(value);
          }
          break;
        default:
          output.add(value);
          break;
      }
    });
    return output;
  }

  void updateListByFilters(){
    List<PatientDetails> holder = _originalDataList;
    if( _dropDownStatusValue == 0 && _dropdownLocationValue == 0 ){
      setStateWrapper((){
        _dataList = _originalDataList;
      });
    }else{
      String status = getTextValueDropdown(list: _statusDropdown, index: _dropDownStatusValue);
      String region = getTextValueDropdown(list: _regionDropdown, index: _dropdownLocationValue);
      
      holder = getFilteredPatientList(list: holder, key: PatientListPresenter.KEY_STATUS, text: status, index: _dropDownStatusValue);
      holder = getFilteredPatientList(list: holder, key: PatientListPresenter.KEY_REGION, text: region, index: _dropdownLocationValue);
    }

    if( _searchTextValue.trim() != "" ){
      String value = _searchTextValue.trim();
      holder = getFilteredPatientList(list: holder, key: PatientListPresenter.KEY_KEYWORD, text: value);
      FocusScope.of(context).requestFocus(FocusNode());
    }

    setStateWrapper((){
      _dataList = holder;
    });
  }

  Widget dropdownFilterTemplate({List<DropdownValue> items, String hint, String key}){
    int currentValue = 0;
    if( key == PatientListPresenter.KEY_STATUS ){
      currentValue = _dropDownStatusValue;
    }else if( key == PatientListPresenter.KEY_REGION ){
      currentValue = _dropdownLocationValue;
    }

    return Container(
      padding: EdgeInsets.all(10.0),
      child: DropdownButton<int>(
        hint: Text(hint),
        items: items.map((DropdownValue value) {
          return DropdownMenuItem<int>(
            value: value.index,
            child: new Text(value.label),
          );
        }).toList(),
        value: currentValue,
        onChanged: (int index) {
          switch(key){
            case PatientListPresenter.KEY_STATUS:
              setStateWrapper((){
                _dropDownStatusValue = index;
              });
              updateListByFilters();
              break;
            case PatientListPresenter.KEY_REGION:
              setStateWrapper((){
                _dropdownLocationValue = index;
              });
              updateListByFilters();
              break;
          }
        },
      ),
    );
  }

  Widget dropdownFilter(){
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              flex: 5,
              child: Container(
                padding: EdgeInsets.all(8.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: S.of(context).LABEL_SEARCH_KEYWORD
                  ),
                  onChanged: (String text) {
                    setStateWrapper(() {
                      _searchTextValue = text;
                    });
                  },
                )
              )
            ),
            Expanded(
              flex: 1,
              child: Container(
                child: IconButton(
                  icon: FaIcon(FontAwesomeIcons.search),
                  onPressed: () {
                    updateListByFilters();
                  },
                )
              )
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              flex: 1,
              child: Container(
                padding: EdgeInsets.all(8.0),
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan( text: S.of(context).LABEL_TOTAL_PATIENTS, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black) ),
                      TextSpan( text: _dataList.length.toString(), style: TextStyle(fontWeight: FontWeight.normal, color: Colors.black) ),
                    ]
                  ),
                ),
              ),
            ),
            dropdownFilterTemplate(items: _statusDropdown, hint: S.of(context).DROPDOWN_ALL_STATUS, key: PatientListPresenter.KEY_STATUS),
            dropdownFilterTemplate(items: _regionDropdown, hint: S.of(context).DROPDOWN_ALL_REGIONS, key: PatientListPresenter.KEY_REGION)
          ],
        )
      ],
    );
  }

  Widget patientListContent(){
    if( _showPageLoader ){
      return pageLoader();
    }

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
            dropdownFilter(), 
            Expanded(
              child: patientListing(),
            )
        ],
      ),
    );
  }

  Widget patientListing(){  

    if( _dataList.length == 0 ){
      return Center(
        child: Text(S.of(context).LABEL_NO_AVAILABLE_DATA, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0), )
      );
    }
    
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: _dataList.length,
      itemBuilder: (BuildContext context, int index) {
        return patientContent(index);
      }
    );
  }

  Widget patientContent(int index){
    PatientDetails item = _dataList[index];
    Icon icon = Icon(FontAwesomeIcons.questionCircle, color: Colors.black, size: 50.0);
    if( (item.gender).trim().toLowerCase() == GENDER_FEMALE.toLowerCase() ){
      icon = Icon(FontAwesomeIcons.female, color: Colors.black, size: 50.0,);
    }else if( (item.gender).trim().toLowerCase() == GENDER_MALE.toLowerCase() ){
      icon = Icon(FontAwesomeIcons.male, color: Colors.black, size: 50.0);
    }

    String dateAdmitted = DateUtils.tryParse(item.date);
    if( dateAdmitted == "false" ){
      dateAdmitted = item.date;
    }else{
      dateAdmitted = DateUtils.formatDateTime("E MMM dd, yyyy", DateTime.parse(dateAdmitted));
    }

    return Card(
      elevation: 5,
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: icon,
          ),
          Expanded(
            flex: 4,
            child: Container(
              padding: EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(0, 4.0, 0, 4.0),
                    child: Text( S.of(context).LABEL_CASE_NUMER(item.caseNo.toString()), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(0, 4.0, 0, 4.0),
                    child: Text( S.of(context).LABEL_DATE_ADMITTED(dateAdmitted.toString()),),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(0, 4.0, 0, 4.0),
                    child: Text(S.of(context).LABEL_HOSPITAL(item.hospitalAdmitted.toString())),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(0, 4.0, 0, 4.0),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text(S.of(context).LABEL_AGE(item.age.toString())),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(S.of(context).LABEL_NATIONALITY(item.nationality.toString())),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(0, 4.0, 0, 4.0),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text( S.of(context).LABEL_STATUS(item.status.toString())),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(S.of(context).LABEL_REGION_VALUE(item.region.toString())),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget mapPH() {
    if( _map == null ){
      _map = GoogleMap( 
        mapType: MapType.normal,
        initialCameraPosition: CameraPosition(
          target: LatLng(14.586093, 120.975111),
          zoom: 13
        ),
        markers: Set<Marker>(),
        compassEnabled: true,
      );
    }
    return Container(child: _map);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title : Text(S.of(context).LABEL_PH_PATIENT_LIST),
      ),
      body: patientListContent(),
    );
  }
}