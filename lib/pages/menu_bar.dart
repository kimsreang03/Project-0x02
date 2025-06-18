import 'package:flutter/material.dart';
import 'package:paper_writer/core/manu_bar.dart';
import '../utils/color_theme.dart';



class _SubButton{
  String label;
  VoidCallback onPressed;
  _SubButton(this.label, this.onPressed);
}

class _MainButton{
  String label;
  List<_SubButton> subButtons;
  _MainButton({required this.label, required this.subButtons});
}

// main class
class CreateMenuBar extends StatelessWidget {

  static const double _minMainButtonWidth = 50;
  static const double _maxMainButtonWidth = 70;
  static const double _subButtonWidth = 250;
  static const double _menuBarHeight = 35;

  // list of all menu button 
  final List<_MainButton> _mainButtonsRaw = [
    _MainButton(label: "File", 
      subButtons: [
        _SubButton("New", () => print("new")),
        _SubButton("Open", OpenFileDialog),
        _SubButton("Save", () => print("save")),
      ]
    ),
    _MainButton(label: "Edit", 
      subButtons: [
        _SubButton("Undo", () => print("Undo")),
        _SubButton("Redo", () => print("Redo")),
        _SubButton("Replace", () => print("Replace")),
      ]
    ),
    _MainButton(label: "View", 
      subButtons: [
        
      ]
    ),
    _MainButton(label: "Format", 
      subButtons: [
        
      ]
    ),
    _MainButton(label: "Table", 
      subButtons: [
        
      ]
    ),
    _MainButton(label: "Window", 
      subButtons: [
        
      ]
    ),_MainButton(label: "Help", 
      subButtons: [
        
      ]
    ),
    
  ];
  ////

  
  final List<SubmenuButton> _mainButtons = [];

  CreateMenuBar({super.key}){

    for(var button in _mainButtonsRaw){
      _mainButtons.add(createMainButton(button));
    }
    
  }

  
  
  @override
  Widget build(BuildContext context) {
    return MenuBar(
      style: MenuStyle(
        alignment: AlignmentGeometry.xy(0, 0),
        elevation: WidgetStatePropertyAll(0.5),
        // shadowColor: WidgetStatePropertyAll(Colors.transparent),
        padding: WidgetStatePropertyAll(EdgeInsets.zero),
        shape: WidgetStatePropertyAll(BeveledRectangleBorder()),
        maximumSize: WidgetStatePropertyAll(Size.fromHeight(_menuBarHeight)),
      ),
      children: _mainButtons,
    
    );
  }

  // create main buttons
  SubmenuButton createMainButton(_MainButton mainButton) {

    // setup a list for creating main buttons
    List<MenuItemButton> subButtons = [];
    for(var button in mainButton.subButtons){
      subButtons.add(createSubButton(button.label, button.onPressed));
    }

    return SubmenuButton(
      style: ButtonStyle(
        alignment: AlignmentGeometry.xy(0, 0),
        backgroundColor: _hoverEffect(ColorTheme.light_00, ColorTheme.light_01),
        foregroundColor: WidgetStatePropertyAll(ColorTheme.light_foreground),
        overlayColor: WidgetStatePropertyAll(Colors.transparent),
        minimumSize: WidgetStatePropertyAll(Size(_minMainButtonWidth, _menuBarHeight)),
        maximumSize: WidgetStatePropertyAll(Size(_maxMainButtonWidth, _menuBarHeight)),
        side: WidgetStatePropertyAll(BorderSide.none),
        padding: WidgetStatePropertyAll(EdgeInsets.only(top: 10, left: 6, right: 6)),
        textStyle: WidgetStatePropertyAll(TextStyle(
          fontSize: 16,
        )),
        
      ),
      menuChildren: subButtons,
      child: Center(child: Text(mainButton.label)),
    );
  }


  // create sub buttons
  MenuItemButton createSubButton(String label, VoidCallback onPressed){

    return MenuItemButton(
      style: ButtonStyle(
        backgroundColor: _hoverEffect(ColorTheme.light_00, ColorTheme.light_01),
        foregroundColor: WidgetStatePropertyAll(ColorTheme.light_foreground),
        overlayColor: WidgetStatePropertyAll(Colors.transparent),
        minimumSize: WidgetStatePropertyAll(Size(_subButtonWidth, _menuBarHeight)),
        maximumSize: WidgetStatePropertyAll(Size(_subButtonWidth, _menuBarHeight)),
        side: WidgetStatePropertyAll(BorderSide.none),
        elevation: WidgetStatePropertyAll(0),
        padding: WidgetStatePropertyAll(EdgeInsets.only(left: 10, top: 10)),
        textStyle: WidgetStatePropertyAll(TextStyle(
          fontSize: 16,
        )),
        shape: WidgetStatePropertyAll(BeveledRectangleBorder())
      ),
      onPressed: onPressed,
      child: Text(label),
    );
  }

  // create background color changing effect when a button is hovered
  WidgetStateColor _hoverEffect(Color defaultColor, Color hoveredColor){
    return WidgetStateColor.resolveWith((states) {
      if(states.contains(WidgetState.hovered)){
        return hoveredColor;
      }
      return defaultColor;
    });
  }
  
}



