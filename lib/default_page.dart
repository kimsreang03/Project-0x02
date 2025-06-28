import 'package:flutter/material.dart';
import 'package:project_0x02/core/shortcuts.dart';
import 'package:project_0x02/core/designTools/tools.dart';
import 'package:project_0x02/ui/menu_bar.dart';
import 'package:project_0x02/core/canvas.dart';




class DefaultPage extends StatefulWidget {
  const DefaultPage({super.key});

  @override
  State<DefaultPage> createState() => _DefaultPageState();
}

class _DefaultPageState extends State<DefaultPage> {

  ToolIndex activeTool = ToolIndex.select;
  late final Map<Type, Action<Intent>> actionsMap;

  @override
  void initState() {
    super.initState();
    actionsMap = buildActionsMap((index){
      setState(() => activeTool = index);
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
          child: _window(activeTool)
        ),
      )
,
    );
  }



  Column _window(ToolIndex activeToo){
    print("tool type: ${activeTool.name}");
    return Column(
    children: [
      
      Align(  
        alignment: Alignment.centerLeft,
        child: CreateMenuBar(),
      ),
      
      Expanded(
        child: CreateCanvas(activeTool),
      )
    ],
  );
  }
}