import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:project_0x02/core/tools/tools.dart';


class CreateCanvas extends StatefulWidget {
  final ToolIndex tool;
  const CreateCanvas(this.tool, {super.key});

  @override
  State<CreateCanvas> createState() => _CreateCanvasState();
}

class _CreateCanvasState extends State<CreateCanvas> {

  

  List<Offset> points = [Offset.zero, Offset.zero];


  @override
  Widget build(BuildContext context) {
    Container canvas = Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.red,
      child:  Listener(
        onPointerDown: _onPointerDown,
        onPointerUp: _onPointerUp,
        onPointerMove: _onPointerMove,
        
        child: CustomPaint(
          painter: MasterPainter(points),
          size: Size.infinite
        ),

      )
    );

    return MouseRegion(
      cursor: SystemMouseCursors.precise,
      child: canvas,
    );
    
  }

  void _onPointerDown(PointerDownEvent event){
    switch(event.buttons){
      case kPrimaryMouseButton:
        setState(() {
          points[0] = event.localPosition;
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

        points[1] = event.localPosition;
        // print(points);
      });

    }
  }

  void _onPointerUp(PointerUpEvent event){
    
    switch(widget.tool){
      case ToolIndex.select:
        // TODO: implement selection function
        setState(() => points = [Offset.zero, Offset.zero]);
      break;
      case ToolIndex.rect:

      break;
      
      default: break;


    }

  }

}

 




class MasterPainter extends CustomPainter{

  List<Offset> points;
  Offset? dp;

  MasterPainter(this.points){
    dp = points[1];
  }
  

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();
    paint.color = Color(0x2D0078D7);
    paint.style = PaintingStyle.fill;
    // paint.strokeWidth = 3;
    
    
    
    Rect rect = Rect.fromPoints(points[0], points[1]);
    
    

  }

  @override
  bool shouldRepaint(covariant MasterPainter oldDelegate) {
    return oldDelegate.dp != dp;   
    // return false; 
  }

}




