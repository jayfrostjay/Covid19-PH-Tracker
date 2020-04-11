import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:phcovid19tracker/data/Drawer/DrawerDetailContent.dart';
import 'package:phcovid19tracker/data/Drawer/DrawerListTileContent.dart';

class CustomDrawers extends StatelessWidget {
  final DrawerDetailContent detailContent = new DrawerDetailContent("Covid-19 PH Tracker", "garciajyh@gmail.com", Image.asset('assets/images/test.jpg'));

  static TopDetailView({Image imageAsset, String accountName, String accountEmail}){
    return UserAccountsDrawerHeader(
      accountName:  Text(accountName),
      accountEmail: Text(accountEmail),
      currentAccountPicture: CircleAvatar(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(50.0),
          child: imageAsset
        ),
      ),
    );
  }

  static Widget buildDrawerItem({DrawerListTileContent content}){
    return ListTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            child: content.icon,
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.fromLTRB(20.0, 0.0, 0.0, 0.0),
            child: Text(content.title)
          )
        ],
      ),
      onTap: content.callback,
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    List<Widget> tiles ;
    return Drawer(
      child: ListView(
        children: <Widget>[
          CustomDrawers.TopDetailView(imageAsset: this.detailContent.accountImage, accountName: this.detailContent.accountName, accountEmail: this.detailContent.accountEmail),
          buildDrawerItem(
            content: DrawerListTileContent(Icon(Icons.track_changes), "Tracker", () => { Navigator.pop(context) })
          ),
          buildDrawerItem(
            content: DrawerListTileContent(Icon(Icons.history), "PH History", () => { Navigator.of(context).pushNamed("/history") })
          ),
          buildDrawerItem(
            content: DrawerListTileContent(Icon(FontAwesomeIcons.chartLine), "World Statistics", () => { Navigator.of(context).pushNamed("/statistics") })
          ),
          buildDrawerItem(
            content: DrawerListTileContent(Icon(Icons.info), "About", () => { Navigator.of(context).pushNamed("/about") })
          ),
          Divider(),
          buildDrawerItem(
            content: DrawerListTileContent(Icon(Icons.close), "Close", () => { Navigator.pop(context) })
          ),
        ],
      )
    );
  }
}