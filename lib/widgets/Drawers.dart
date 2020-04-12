import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:phcovid19tracker/data/Drawer/DrawerDetailContent.dart';
import 'package:phcovid19tracker/data/Drawer/DrawerListTileContent.dart';
import 'package:phcovid19tracker/generated/i18n.dart';

class CustomDrawers extends StatelessWidget {
  
  static topDetailView({String imageAsset, String accountName, String accountEmail}){
    return UserAccountsDrawerHeader(
      accountName:  Text(accountName),
      accountEmail: Text(accountEmail),
      currentAccountPicture: CircleAvatar(
        radius: 30.0,
        backgroundColor: Colors.transparent,
        backgroundImage: AssetImage(imageAsset),
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
    DrawerDetailContent detailContent = new DrawerDetailContent(
      S.of(context).APP_NAME, 
      S.of(context).LABEL_ACCOUNT_EMAIL, 
      'assets/images/test.jpg'
    );
    
    // TODO: implement build
    List<Widget> tiles ;
    return Drawer(
      child: ListView(
        children: <Widget>[
          CustomDrawers.topDetailView(imageAsset: detailContent.accountImage, accountName: detailContent.accountName, accountEmail: detailContent.accountEmail),
          buildDrawerItem(
            content: DrawerListTileContent(Icon(Icons.track_changes), S.of(context).LABEL_LINKS_TRACKER, () => { Navigator.pop(context) })
          ),
          buildDrawerItem(
            content: DrawerListTileContent(Icon(Icons.history), S.of(context).LABEL_LINKS_PH_HISTORY, () => { Navigator.of(context).pushNamed("/countryHistory") })
          ),
          buildDrawerItem(
            content: DrawerListTileContent(Icon(FontAwesomeIcons.chartLine), S.of(context).LABEL_LINKS_WORLD_STATS, () => { Navigator.of(context).pushNamed("/worldStats") })
          ),
          buildDrawerItem(
            content: DrawerListTileContent(Icon(Icons.info), S.of(context).LABEL_ABOUT, () => { Navigator.of(context).pushNamed("/about") })
          ),
          Divider(),
          buildDrawerItem(
            content: DrawerListTileContent(Icon(Icons.close), S.of(context).LABEL_LINKS_CLOSE, () => { Navigator.pop(context) })
          ),
        ],
      )
    );
  }
}