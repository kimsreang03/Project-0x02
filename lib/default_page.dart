import 'package:flutter/material.dart';
import 'package:project_0x02/core/shortcuts.dart';
import 'package:project_0x02/core/tools/tools.dart';
import 'package:project_0x02/ui/menu_bar.dart';
import 'package:project_0x02/core/canvas.dart';




class DefaultPage extends StatefulWidget {
  const DefaultPage({super.key});

  @override
  State<DefaultPage> createState() => _DefaultPageState();
}

class _DefaultPageState extends State<DefaultPage> {

  ToolType toolType = ToolType.select;

  @override
  Widget build(BuildContext context) {



    return Shortcuts(
      shortcuts: shortcuts, 
      child: Actions(
      actions: {
          SelectToolIntent: CallbackAction<SelectToolIntent> (onInvoke: (_){
            
            setState(() {
              toolType = ToolType.select;
            });

            return null;
          })
        },

        child: Focus(
          autofocus: true,
          child: _window(toolType)
        ),
      )
,
    );
  }


  Column _window(ToolType toolType){
    return Column(
    children: [
      
      Align(  
        alignment: Alignment.centerLeft,
        child: CreateMenuBar(),
      ),
      
      Expanded(
        child: CreateCanvas(toolType),
      )
    ],
  );
  }
}