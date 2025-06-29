import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project_0x02/core/designTools/shape.dart';
import 'package:project_0x02/core/designTools/tools.dart';
import 'package:project_0x02/core/shortcuts.dart';


class TransformObject{
  Offset pan;
  double scale;
  TransformObject({
    this.pan = Offset.zero,
    this.scale = 1,
  });
}


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
  final ModifierKeys modifierKeys = ModifierKeys();
  TransformObject transform = TransformObject();
  

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
        onPointerHover: _onPointerHover,
        onPointerSignal: _onPointerSignal,
        onPointerPanZoomStart: _onPointerPanZoomStart,
        onPointerPanZoomUpdate: _onPointerPanZoomUpdate,
        onPointerPanZoomEnd: _onPointerPanZoomEnd,


        child: CustomPaint(
          painter: MasterPainter(widget.shapes, newShape, transform, modifierKeys),
          size: Size.infinite
        ),

      )
    );
    
    MouseRegion mouseRegion = MouseRegion(
      cursor: _handleMouseCursor(),
      child: canvas,
    );


    return KeyboardListener(
      focusNode: _focusNode, 
      autofocus: true,
      onKeyEvent: _onKeyEvent,
      child: mouseRegion,
    );
    
  }

  /// methods of MouseRegion
  /// change mouse cursor for different design tools
  MouseCursor _handleMouseCursor(){
    if(newShape.activeTool == ToolIndex.select){
      return SystemMouseCursors.move;
    }
    return SystemMouseCursors.precise;
  }


  /// methods of KeyboardListener
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
        setState(() => modifierKeys.ctrl = value);
      break;
      case LogicalKeyboardKey.shiftLeft:
      case LogicalKeyboardKey.shiftRight:
        setState(() => modifierKeys.shift = value);
      break;
      case LogicalKeyboardKey.altLeft:
      case LogicalKeyboardKey.altRight:
        setState(() => modifierKeys.alt = value);
      case LogicalKeyboardKey.space:
        setState(() => modifierKeys.space = value);
    }
  }

  

  /// methods of Listener
  void _onPointerDown(PointerDownEvent event){
    switch(event.buttons){
      case kPrimaryMouseButton:
        setState(() {
          // newShape.points[0] = event.localPosition - transform.pan;
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
  } // _onPointerDown

  void _onPointerMove(PointerMoveEvent event){
    if(event.buttons == kPrimaryMouseButton){
      setState(() {
        // newShape.points[1] = event.localPosition - transform.pan;
        newShape.points[1] = event.localPosition;
      });

    }
  } // _onPointerMove

  void _onPointerUp(PointerUpEvent event){
    
    // set points back to the zero position
    setState((){
      if(newShape.activeTool != ToolIndex.select){

        updatePaintingList();
      }
      newShape.points[0] = Offset.zero;
      newShape.points[1] = Offset.zero;
    });

  } // _onPointerUp

  void _onPointerHover(PointerHoverEvent event){
    if(modifierKeys.space){
      setState(() {
        transform.pan += event.localDelta;
      });
    }

  } // _onPointerHover

  void _onPointerSignal(PointerSignalEvent event){
    if(event is PointerScrollEvent){
      if(modifierKeys.ctrl){
        setState(() {
          transform.scale += event.scrollDelta.dy/153;
          transform.scale = transform.scale.clamp(0.1, 10);
        
        });
      }
    }
  } // _onPointerSignal


  void _onPointerPanZoomStart(PointerPanZoomStartEvent event){
    //TODO
    setState(() {
    });
  }


  void _onPointerPanZoomUpdate(PointerPanZoomUpdateEvent event){

    setState(() {
      transform.pan += event.localPanDelta;

    });

  }

  void _onPointerPanZoomEnd(PointerPanZoomEndEvent event){
    //TODO
    setState(() {
      
    });
  }

//////////////////////////////////////

  void updatePaintingList(){
    // add the drawn shape to the shapes[] list
    Offset p1 = (newShape.points[0] - transform.pan)/transform.scale;
    Offset p2 = (newShape.points[1] - transform.pan)/transform.scale;
    widget.shapes.add(ShapeObject(
      pathData: newShape.getBasicPath(p1, p2, modifierKeys.ctrl),
      // pathData: newShape.pathData,
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
  TransformObject transform;
  ModifierKeys modifierKeys;
  
  Offset? r1, r2;
  double? r3;
  bool? r4;

  MasterPainter(this.shapes, this.newShape, this.transform, this.modifierKeys){
    r1 = newShape.points[1];
    r2 = transform.pan;
    r3 = transform.scale;
    r4 = modifierKeys.ctrl;
  }
  
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();

    canvas.save();

    canvas.translate(transform.pan.dx, transform.pan.dy);
    canvas.scale(transform.scale);  

    //draw all existed shapes
    for(int i = 0; i < shapes.length; i++){
      shapes[i].paint(canvas, paint);
    }

    canvas.restore();
    newShape.paint(canvas, paint, modifierKeys);
  }

  @override
  bool shouldRepaint(covariant MasterPainter old) {
    return (old.r1 != r1 || old.r2 != r2 || 
            old.r3 != r3 || old.r4 != r4);    
  }

}




