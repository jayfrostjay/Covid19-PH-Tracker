
enum ListViewHolderViewType {
  header, 
  item
}

class ListViewHolder {
  ListViewHolderViewType viewType;
  dynamic data;

  ListViewHolder({this.viewType, this.data});
}