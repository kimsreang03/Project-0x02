import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project_0x02/core/designTools/shape.dart';
import 'package:project_0x02/core/designTools/tools.dart';
import 'package:project_0x02/core/shortcuts.dart';
import 'package:project_0x02/core/utils.dart';


  // shapes =
    // [
    //   ShapeObject(
    //     pathData: "M10 10 H110 V70 H10 Z",
    //     color: Color(0xffff0000),
    //   ),
    //   ShapeObject(
    //     pathData: "M60 20 L100 100 L20 100 Z",
        
    //   ),
    // ];


class Transformation{
  Offset pan;
  double scale;
  Transformation({
    this.pan = Offset.zero,
    this.scale = 1,
  });
}



/// 
/// 
class CreateCanvas extends StatefulWidget {
  final ToolIndex activeTool;
  const CreateCanvas(this.activeTool, {super.key});

  @override
  State<CreateCanvas> createState() => _CreateCanvasState();
}

class _CreateCanvasState extends State<CreateCanvas> {

  final List<ShapeObject> shapes = [];
  final NewShapeObject newShape = NewShapeObject();
  final LeaderKeys leaderKeys = LeaderKeys();
  final Transformation transform = Transformation();
  final List<Offset> pointer = [Offset.zero, Offset.zero, Offset.zero];

  final FocusNode _focusNode = FocusNode();
  

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
        onPointerHover: _onPointerHover,
        onPointerSignal: _onPointerSignal,
        onPointerPanZoomStart: _onPointerPanZoomStart,
        onPointerPanZoomUpdate: _onPointerPanZoomUpdate,
        onPointerPanZoomEnd: _onPointerPanZoomEnd,


        child: CustomPaint(
          painter: MasterPainter(shapes, newShape, pointer, widget.activeTool, leaderKeys, transform),
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
    if(widget.activeTool == ToolIndex.select){
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
      _setLeaderKeys(event.logicalKey, true);
    }else
    if(event is KeyUpEvent){
      _setLeaderKeys(event.logicalKey, false);
    }

  }
  /// scaning for the the keys ctrl, shift, alt
  /// if they were pressed/released, set them true/false in the modifierKeys
  void _setLeaderKeys(LogicalKeyboardKey key, bool value){
    switch(key){
      case LogicalKeyboardKey.controlLeft:
      case LogicalKeyboardKey.controlRight:
        setState(() => leaderKeys.ctrl = value);
      break;
      case LogicalKeyboardKey.shiftLeft:
      case LogicalKeyboardKey.shiftRight:
        setState(() => leaderKeys.shift = value);
      break;
      case LogicalKeyboardKey.altLeft:
      case LogicalKeyboardKey.altRight:
        setState(() => leaderKeys.alt = value);
      case LogicalKeyboardKey.space:
        setState(() => leaderKeys.space = value);
    }
  } // _setLeaderKeys

  

  /// methods of Listener
  void _onPointerDown(PointerDownEvent event){
    switch(event.buttons){
      case kPrimaryMouseButton:
        setState(() {
          pointer[0] = pointer[2] = (event.localPosition - transform.pan)/transform.scale;
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
        pointer[1] = (event.localPosition - transform.pan)/transform.scale;
      });

    }
  } // _onPointerMove

  void _onPointerUp(PointerUpEvent event){
    setState((){
      if (widget.activeTool == ToolIndex.rect ||
          widget.activeTool == ToolIndex.line){
        addNewShape(shapes, newShape);
      }
      pointer[2] = Offset(-1000, -1000);
      pointer[1] = pointer[0];
    });

  } // _onPointerUp

  void _onPointerHover(PointerHoverEvent event){
    
    if(leaderKeys.space){
      setState(() {
        transform.pan += event.localDelta;
      });
    }

  } // _onPointerHover

  void _onPointerSignal(PointerSignalEvent event){
    
    if(event is PointerScrollEvent){
      
      if(leaderKeys.ctrl){
        setState(() {

          double scaleDelta = event.scrollDelta.dy/530;
          double ratio = scaleDelta/(transform.scale);
          transform.scale += scaleDelta;
          transform.scale = transform.scale.clamp(0.1, 12); 
          
          if(0.1 < transform.scale && transform.scale < 12){
            transform.pan *= ratio + 1;
            transform.pan -= event.localPosition * ratio;
          }
        });
      }

    }

  } // _onPointerSignal

/////////////////////////////
/////////////////////////
///TODO: future implementation
  void _onPointerPanZoomStart(PointerPanZoomStartEvent event){
    //TODO
    setState(() {
    });
  }


  void _onPointerPanZoomUpdate(PointerPanZoomUpdateEvent event){

    setState(() {
      transform.pan += event.localPanDelta;
      if(leaderKeys.ctrl){
        print("delta: ${event.localPanDelta/40}");
      }

    });


  }

  void _onPointerPanZoomEnd(PointerPanZoomEndEvent event){
    //TODO
    setState(() {
      
    });
  }
///////////////////////////////////////
//////////////////////////////////////

  

} // _CreateCanvasState
///////////////////////////
 




/// Main paitner class

class MasterPainter extends CustomPainter{


  List<Offset> pointer;
  List<ShapeObject> shapes;
  NewShapeObject newShape;
  Transformation transform;
  LeaderKeys leaderKeys;
  ToolIndex activeTool;

  // these are for tracking the changes of the canvas
  Offset? r1, r2;
  double? r3;
  bool? r4;

  MasterPainter(
    this.shapes, 
    this.newShape, 
    this.pointer,
    this.activeTool,
    this.leaderKeys,
    this.transform,)
  {
    r1 = pointer[1];
    r2 = transform.pan;
    r3 = transform.scale;
    r4 = leaderKeys.ctrl;
  }
  
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();
    
    // panning and zooming
    canvas.translate(transform.pan.dx, transform.pan.dy);
    canvas.scale(transform.scale);  

    // draw all existed shapes
    for(int i = 0; i < shapes.length; i++){
      shapes[i].paint(canvas, paint, pointer[2]);
    }
    
    
    // select tool box style
    if(activeTool == ToolIndex.select){
      newShape.color = Color(0xAAFF0000);
      newShape.paintingStyle = PaintingStyle.stroke;
      newShape.paint(canvas, paint, pointer, leaderKeys, activeTool);
      newShape.color = Colors.black;
      newShape.paintingStyle = PaintingStyle.fill;
      return;
    }
    
    newShape.paint(canvas, paint, pointer, leaderKeys, activeTool);

  }

  @override
  bool shouldRepaint(covariant MasterPainter old) {
    return (old.r1 != r1 || old.r2 != r2 || 
            old.r3 != r3 || old.r4 != r4);    
  }
 
} // MasterPainter




