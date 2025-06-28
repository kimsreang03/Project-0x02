import 'package:flutter/material.dart';
import 'package:project_0x02/core/designTools/shape.dart';
import 'package:project_0x02/core/designTools/tools.dart';
import 'package:project_0x02/core/shortcuts.dart';
import 'package:project_0x02/ui/menu_bar.dart';
import 'package:project_0x02/core/canvas.dart';




class DefaultPage extends StatefulWidget {
  const DefaultPage({super.key});

  @override
  State<DefaultPage> createState() => _DefaultPageState();
}

class _DefaultPageState extends State<DefaultPage> {

  late final Map<Type, Action<Intent>> actionsMap;

  late final List<ShapeObject> shapes;
  final NewShapeObject newShape = NewShapeObject();

  @override
  void initState() {

    shapes =
    [
      ShapeObject(
        pathData: "M10 10 H110 V70 H10 Z",
        color: Color(0xffff0000),
      ),
      ShapeObject(
        pathData: "M60 20 L100 100 L20 100 Z",
        
      ),
    ];

    super.initState();
    actionsMap = buildActionsMap((index){
      setState(() => newShape.activeTool = index);
    });

  }

  @override
  Widget build(BuildContext context) {

    return Shortcuts(
      shortcuts: shortcutsMap, 
      child: Actions(
        actions: actionsMap,
        child: Focus(
          autofocus: true,
          child: _window()
        ),
      )
,
    );
  }



  Column _window(){
    print("tool type: ${newShape.activeTool.name}");
    return Column(
    children: [
      
      Align(  
        alignment: Alignment.centerLeft,
        child: CreateMenuBar(),
      ),
      
      Expanded(
        child: CreateCanvas(shapes, newShape),
      )
    ],
  );
  }
}