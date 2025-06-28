import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project_0x02/core/designTools/shape.dart';
import 'package:project_0x02/core/designTools/tools.dart';
import 'package:project_0x02/core/shortcuts.dart';


/// this class is just to simplify the constructor parameters of MasterPaiter
/// it contains the existing shapes needed to be rendered
/// and the data for new drawing
class PaintingData{
  List<ShapeObject> shapes = [];
  final ModifierKeys modifierKeys = ModifierKeys();
  final List<Offset> points = [Offset.zero, Offset.zero];
  ShapeObject newShape = ShapeObject("");
}


/// 
/// 
class CreateCanvas extends StatefulWidget {
  final ToolIndex tool;
  const CreateCanvas(this.tool, {super.key});

  @override
  State<CreateCanvas> createState() => _CreateCanvasState();
}

class _CreateCanvasState extends State<CreateCanvas> {


  final FocusNode _focusNode = FocusNode();

  PaintingData paintingData = PaintingData();

  @override
  void initState() {
    super.initState();
    _focusNode.requestFocus();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Container canvas = Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.white,
      child:  Listener(
        onPointerDown: _onPointerDown,
        onPointerUp: _onPointerUp,
        onPointerMove: _onPointerMove,
        
        child: CustomPaint(
          painter: MasterPainter(paintingData),
          size: Size.infinite
        ),

      )
    );
    
    MouseRegion mouseRegion = MouseRegion(
      cursor: SystemMouseCursors.precise,
      child: canvas,
    );


    return KeyboardListener(
      focusNode: _focusNode, 
      autofocus: true,
      onKeyEvent: _onKeyEvent,
      child: mouseRegion,
    );
    
  }


  /// check the logical keys whether they were pressed or released
  /// pressed set true
  /// realesed set false 
  void _onKeyEvent(KeyEvent event){
    
    if(event is KeyDownEvent){
      _setModifierKeys(event.logicalKey, true);
    }else
    if(event is KeyUpEvent){
      _setModifierKeys(event.logicalKey, false);
    }

  }
  /// scaning for the the keys ctrl, shift, alt
  /// if they were pressed/released, set them true/false in the modifierKeys
  void _setModifierKeys(LogicalKeyboardKey key, bool value){
    switch(key){
      case LogicalKeyboardKey.controlLeft:
      case LogicalKeyboardKey.controlRight:
        setState(() => paintingData.modifierKeys.ctrl = value);
      break;
      case LogicalKeyboardKey.shiftLeft:
      case LogicalKeyboardKey.shiftRight:
        setState(() => paintingData.modifierKeys.shift = value);
      break;
      case LogicalKeyboardKey.altLeft:
      case LogicalKeyboardKey.altRight:
        setState(() => paintingData.modifierKeys.alt = value);
    }
  }

  


  void _onPointerDown(PointerDownEvent event){
    switch(event.buttons){
      case kPrimaryMouseButton:
        setState(() {
          paintingData.points[0] = event.localPosition;
        });
      break;
      case kMiddleMouseButton:
        print("middle pressed");
      break;
      case kSecondaryMouseButton:
        print("right pressed");
      break;
    }
  }
  
  void _onPointerMove(PointerMoveEvent event){
    if(event.buttons == kPrimaryMouseButton){
      setState(() {

        paintingData.points[1] = event.localPosition;
        // print(points);
      });

    }
  }

  void _onPointerUp(PointerUpEvent event){
    
    switch(widget.tool){
      case ToolIndex.select:
        // TODO: implement selection function
        setState((){
          paintingData.points[0] = Offset.zero;
          paintingData.points[1] = Offset.zero;
        });
      break;
      case ToolIndex.rect:

      break;
      
      default: break;


    }

  }

}
///////////////////////////
 




/// Main painer class

class MasterPainter extends CustomPainter{

  PaintingData paintingData; /// painting data

  List<Offset> p = [];
  List<ShapeObject> shapes = [];
  ModifierKeys modifierKeys = ModifierKeys();
  ShapeObject newShape = ShapeObject("");

  MasterPainter(this.paintingData){
    p = paintingData.points;
    shapes = paintingData.shapes;
    modifierKeys = paintingData.modifierKeys;
    newShape = paintingData.newShape;
  }
  


  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();

    // draw all existed shapes
    for(int i = 0; i < shapes.length; i++){
      shapes[i].draw(canvas, paint);
    }

    //// draw new shape
    
    

  }

  @override
  bool shouldRepaint(covariant MasterPainter oldDelegate) {
    return oldDelegate.p[1] != p[1];   
  }

}




