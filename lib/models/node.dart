part of network_graph;

class NodeModel {
  String? id;
  String content;
  Widget? widget;
  double? x;
  double? y;
  LinearGradient? gradient;
  bool isBigNode;
  Function? onClick;
  Size? size;

  NodeModel({this.id, required this.content, this.x, this.y, this.isBigNode = false, this.gradient = blueLinearGradientOne,this.onClick, this.size, this.widget});
}