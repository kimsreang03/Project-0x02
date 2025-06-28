import "package:flutter/material.dart";
import 'package:path_drawing/path_drawing.dart';
import 'package:project_0x02/core/designTools/tools.dart';
import 'package:project_0x02/core/shortcuts.dart';

enum StrokeStyle {solid, dash, ovalDash}



/// ObjectShape is the class contains all drawing shape
/// subclass: LineShape, RectShape, 
class ShapeObject{

  String pathData;

  Color color;
  PaintingStyle paintingStyle;
  double strokeWidth;
  StrokeCap strokeCap;
  StrokeJoin strokeJoin;
  StrokeStyle strokeStyle;


  ShapeObject(
    {
      this.pathData = "",
      this.color = Colors.black,
      this.paintingStyle = PaintingStyle.fill,
      this.strokeWidth = 2,
      this.strokeCap = StrokeCap.butt,
      this.strokeJoin = StrokeJoin.bevel,
      this.strokeStyle = StrokeStyle.solid,
    }
  ){
    print("ShapeObject created");
  }

  void draw(Canvas canvas, Paint paint){
    
    paint.color = color;
    paint.style = paintingStyle;
    paint.strokeWidth = strokeWidth;
    paint.strokeCap = strokeCap;
    paint.strokeJoin = strokeJoin;
    
    Path path = parseSvgPathData(pathData);

    canvas.drawPath(path, paint);
  }

}

class NewShapeObject extends ShapeObject{

  final ModifierKeys modifierKeys = ModifierKeys();
  final List<Offset> points = [Offset.zero, Offset.zero];
  ShapeObject newShape = ShapeObject();
  ToolIndex activeTool = ToolIndex.select;
  // bool painting = false;


  @override
  void draw(Canvas canvas, Paint paint) {
  
    pathData = _getBasicPath(points[0], points[1], modifierKeys.ctrl);

    super.draw(canvas, paint);
  }

  // void reset(){
  //   pathData = "";
  //   color = Colors.black;
  //   paintingStyle = PaintingStyle.fill;
  //   strokeWidth = 2;
  //   strokeCap = StrokeCap.butt;
  //   strokeJoin = StrokeJoin.bevel;
  //   strokeStyle = StrokeStyle.solid;
    
  // }
  


  String _getBasicPath(Offset p1, Offset p2, bool drawFromCenter){
    double x1, x2, y1, y2;

    if(drawFromCenter){
      x1 = 2*p1.dx - p2.dx;
      y1 = 2*p1.dy - p2.dy;
      x2 = p2.dx;
      y2 = p2.dy;    
    }else{
      x1 = p1.dx; y1 = p1.dy; 
      x2 = p2.dx; y2 = p2.dy;
    }

    switch(activeTool){
      case ToolIndex.line:
        paintingStyle = PaintingStyle.stroke;
        return  'M $x1 $y1 L $x2 $y2';
      case ToolIndex.rect: case ToolIndex.select:
        return 'M $x1 $y1 H $x2 V $y2 H $x1 Z';
      default: return "";
    }

  }

  

}

