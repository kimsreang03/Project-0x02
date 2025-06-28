import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project_0x02/core/designTools/shape.dart';
import 'package:project_0x02/core/designTools/tools.dart';

/// this class is just to simplify the constructor parameters of MasterPaiter
/// it contains the existing shapes needed to be rendered
/// and the data for new drawing


/// 
/// 
class CreateCanvas extends StatefulWidget {
  final List<ShapeObject> shapes;
  final NewShapeObject newShape;
  const CreateCanvas(this.shapes, this.newShape, {super.key});

  @override
  State<CreateCanvas> createState() => _CreateCanvasState();
}

class _CreateCanvasState extends State<CreateCanvas> {


  final FocusNode _focusNode = FocusNode();
  late final NewShapeObject newShape;
  

  @override
  void initState() {
    newShape = widget.newShape;
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
          painter: MasterPainter(widget.shapes, newShape),
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
        setState(() => newShape.modifierKeys.ctrl = value);
      break;
      case LogicalKeyboardKey.shiftLeft:
      case LogicalKeyboardKey.shiftRight:
        setState(() => newShape.modifierKeys.shift = value);
      break;
      case LogicalKeyboardKey.altLeft:
      case LogicalKeyboardKey.altRight:
        setState(() => newShape.modifierKeys.alt = value);
    }
  }

  


  void _onPointerDown(PointerDownEvent event){
    switch(event.buttons){
      case kPrimaryMouseButton:
        setState(() {
          newShape.points[0] = event.localPosition;
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
        newShape.points[1] = event.localPosition;
      });

    }
  }

  void _onPointerUp(PointerUpEvent event){
    
    // set points back to the zero position
    setState((){
      if(newShape.activeTool != ToolIndex.select){
        updatePaintingList();
      }
      newShape.points[0] = Offset.zero;
      newShape.points[1] = Offset.zero;
    });

  }


  void updatePaintingList(){
    // add the drawn shape to the shapes[] list
      widget.shapes.add(ShapeObject(
        pathData: newShape.pathData,
        color: newShape.color,
        paintingStyle: newShape.paintingStyle,
        strokeWidth: newShape.strokeWidth,
        strokeCap: newShape.strokeCap,
        strokeJoin: newShape.strokeJoin,
        strokeStyle: newShape.strokeStyle,
      ));
  }

}
///////////////////////////
 




/// Main painer class

class MasterPainter extends CustomPainter{

  static int i = 1;

  List<ShapeObject> shapes;
  NewShapeObject newShape;/// painting data
  
  Offset? dp;

  MasterPainter(this.shapes, this.newShape){
    dp = newShape.points[1];
  }
  
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();

    //draw all existed shapes
    for(int i = 0; i < shapes.length; i++){
      shapes[i].draw(canvas, paint);
    }

    newShape.draw(canvas, paint);
  }

  @override
  bool shouldRepaint(covariant MasterPainter oldDelegate) {
    return oldDelegate.dp != dp;   
  }

}




