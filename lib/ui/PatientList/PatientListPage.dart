import 'dart:async';
import 'dart:collection';

import 'package:awesome_loader/awesome_loader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:phcovid19tracker/common/BaseState.dart';
import 'package:phcovid19tracker/data/PatientDetails.dart';
import 'package:phcovid19tracker/generated/i18n.dart';
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
  
  bool _showPageLoader, _showListLoader;

  PatientListPresenter _presenter;

  _PatientListPageState(){
    _presenter = PatientListPresenter(this);
  }

  @override
  void initState() {
    super.initState();
    defaultState();
    // _showPageLoader = true;
    _presenter.verifyLocationPermission();
  }

  @override
  void defaultState() {
    _showPageLoader = false;
    _showListLoader = false;
  }

  fetchPatientList(){
    setStateWrapper((){
      _showListLoader = true;
    });
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
  void onCompleteDropdownList(List<HashMap<String, dynamic>> dropdownList) {
    // TODO: create dropdownlist
  }

  @override
  void onLoadStatsComplete(List<PatientDetails> item) {
    // TODO: create list
  }

  @override
  void onLoadStatsError(String onError) {
    ToastUtil.showFlutterToast(message: S.of(context).LABEL_ERROR_FETCHING_DATA(onError));
  }

  Widget patientListContent(){
    return Container(
      child: Text('patientListContent'),
    );
  }

  Widget regionDropdown(){

  }

  Widget patientListByRegion(String region){

  }

  Widget mapPH() {
    Completer<GoogleMapController> _controller = Completer();
    return Container(
      child: GoogleMap( 
        mapType: MapType.normal,
        initialCameraPosition: CameraPosition(
          target: LatLng(14.586093, 120.975111),
          zoom: 13
        ),
        onMapCreated: (GoogleMapController controller){
          if( _controller == null ){
            _controller.complete(controller);
          }
        },
        markers: Set<Marker>(),
        compassEnabled: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title : Text(S.of(context).LABEL_PH_PATIENT_LIST),
          bottom: TabBar(
            tabs: <Widget>[
              Tab(icon: FaIcon(FontAwesomeIcons.map),),
              Tab(icon: FaIcon(FontAwesomeIcons.list),)
            ],
          ),
        ),
        body: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: <Widget>[
            mapPH(),
            patientListContent()
          ],
        ),
      ),
    );
  }
}