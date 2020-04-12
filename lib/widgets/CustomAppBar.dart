import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String text;
  final List<Widget> actions;

  CustomAppBar({Key key, this.text, this.actions}) : super(key: key);
  
  static Widget buildIconButton({Icon icon, GestureTapCallback callback}){
    return IconButton(
      icon: icon,
      onPressed: (callback != null) ? callback : () => { print("null") } ,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(this.text),
      actions: actions,
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(50.0);  //standard
}