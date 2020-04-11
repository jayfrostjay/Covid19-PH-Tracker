import 'package:flutter/cupertino.dart';

abstract class BaseState {
  void setStateWrapper(Function func);
  void defaultState();
  bool isLandscape();
  void progressDialog();
  Widget listLoader(BuildContext context, int index);
  Widget pageLoader();
}