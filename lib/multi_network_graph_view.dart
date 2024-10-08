part of network_graph;

class MultiNetworkGraphView extends StatefulWidget {
  bool isShowArrowShape;
  List<NodeGroup> nodeGroupList;

  MultiNetworkGraphView(
      {this.isShowArrowShape = true, required this.nodeGroupList});

  @override
  State createState() =>
      _MultiNetworkGraphViewState(
          nodeGroupList: nodeGroupList, isShowArrowShape: isShowArrowShape);
}

class _MultiNetworkGraphViewState extends State<MultiNetworkGraphView> {
  late DrawingModel model;

  var offsetX = 0.0;
  var offsetY = 0.0;

  var preX = 0.0;
  var preY = 0.0;

  NodeModel? currentNode;

  List<NodeGroup> nodeGroupList;
  bool isShowArrowShape;

  _MultiNetworkGraphViewState(
      {required this.nodeGroupList, required this.isShowArrowShape}) {
    model = DrawingModel(isShowArrowShape: isShowArrowShape);

    nodeGroupList.forEach((element) {
      model.addNodeList(element.nodeList);
      model.addEdgeList(element.edgeList);
    });
  }

  void _handlePanDown(details) {
    final x = details.localPosition.dx;
    final y = details.localPosition.dy;

    final node = model.getNode(x - offsetX, y - offsetY);
    if (node != null) {
      currentNode = node;
    } else {
      currentNode = null;
    }

    preX = x;
    preY = y;
  }

  void _handlePanUpdate(details) {
    final dx = details.localPosition.dx - preX;
    final dy = details.localPosition.dy - preY;

    if (currentNode != null) {
      setState(() {
        currentNode?.x = currentNode!.x! + dx;
        currentNode?.y = currentNode!.y! + dy;
      });
    } else {
      setState(() {
        offsetX = offsetX + dx;
        offsetY = offsetY + dy;
      });
    }

    preX = details.localPosition.dx;
    preY = details.localPosition.dy;
  }

  void _handleLongPressStart(details) {
    final x = details.localPosition.dx;
    final y = details.localPosition.dy;

    final node = model.getNode(x - offsetX, y - offsetY);

    if (node == null) {
      return;
    }

    if (node.onClick != null) {
      node.onClick!.call();
    }
  }

  void _handleLongPressMoveUpdate(details) {}

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onPanDown: _handlePanDown,
        onPanUpdate: _handlePanUpdate,
        onLongPressStart: _handleLongPressStart,
        onLongPressMoveUpdate: _handleLongPressMoveUpdate,
        //       child: CustomPaint(
        //         child: Container(),
        //         painter: GraphViewPainter(model, offsetX, offsetY),
        //       ),
        //     ),
        //   );
        // }
        child: Stack(
            children: [
              CustomPaint(
                size: Size.infinite,
                painter: GraphViewPainter(model, offsetX, offsetY),
              ),
              ...model.getNodeList().map((node) {
                return Positioned(
                  left: node.x! + offsetX - 25,
                  top: node.y! + offsetY - 25,
                  child: GestureDetector(
                    onPanUpdate: (details) {
                      setState(() {
                        node.x = node.x! + details.delta.dx;
                        node.y = node.y! + details.delta.dy;
                      });
                    },
                    child: node.widget != null ?
                    node.widget :
                    Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.blueGrey[900],
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 4,
                              offset: Offset(2, 2),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            node.content,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        )
                    ),
                  ),
                );
              }
              )
            ]
        )
    );
  }
}
