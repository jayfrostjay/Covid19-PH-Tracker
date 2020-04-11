import 'dart:js';

import 'package:awesome_loader/awesome_loader.dart';
import 'package:flutter/material.dart';
import 'package:phcovid19tracker/common/BaseState.dart';

class WorldStatsPage extends StatefulWidget {
  WorldStatsPage({Key key}) : super(key: key);
  _WorldStatsPageState instance = _WorldStatsPageState();

  @override
  _WorldStatsPageState createState() => instance;
}

class _WorldStatsPageState extends State<WorldStatsPage> implements BaseState {
  
  BuildContext _context;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void defaultState() {
    // TODO: implement defaultState
  }

  @override
  void setStateWrapper(Function func) {
    // TODO: implement setStateWrapper
    setState((){
      func();
    });
  }

  @override
  bool isLandscape(){
    // TODO: implement build
    return (MediaQuery.of(_context).orientation == Orientation.landscape);
  }

  Widget pageLoader(){
    return new Container(
      alignment: Alignment.center,
      child: AwesomeLoader(loaderType: AwesomeLoader.AwesomeLoader4, color: Colors.blue,),
    );
  }

  Widget listLoader(){

  }

  void navigateToHistoryScreen(BuildContext context, String countryName){

  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    // TODO: implement build
    return null;
  }

  @override
  void progressDialog() {
    // TODO: implement progressDialog
  }
}