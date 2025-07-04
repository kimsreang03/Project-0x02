import 'package:flutter/material.dart';
import 'package:project_0x02/core/designTools/tools.dart';
import 'package:project_0x02/core/shortcuts.dart';
import 'package:project_0x02/core/canvas.dart';
import 'package:project_0x02/ui/menu_bar.dart';



class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  late final Map<Type, Action<Intent>> actionsMap;
  ToolIndex activeTool = ToolIndex.select;

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
          child: _window()
        ),
      ),
    );

  }



  Column _window(){
    print("main tool type: ${activeTool.name}");

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