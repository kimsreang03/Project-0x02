import "package:flutter/material.dart";
import 'package:path_drawing/path_drawing.dart';

enum StrokeStyle {solid, dash, ovalDash}
enum ShapeType{
  line, rect
}



/// ObjectShape is the class contains all drawing shape
/// subclass: LineShape, RectShape, 
class ShapeObject{

  String pathData;
  ShapeType shapeType;

  Color color;
  PaintingStyle style;
  double strokeWidth;
  StrokeCap strokeCap;
  StrokeJoin strokeJoin;
  StrokeStyle strokeStyle;


  ShapeObject( this.pathData,
    {
      this.shapeType = ShapeType.rect,
      this.color = Colors.black,
      this.style = PaintingStyle.fill,
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
    paint.style = style;
    paint.strokeWidth = strokeWidth;
    paint.strokeCap = strokeCap;
    paint.strokeJoin = strokeJoin;
    
    Path path = parseSvgPathData(pathData);

    canvas.drawPath(path, paint);
  }

}




class ShapePath{

  static String basic(List<Offset> points, ShapeType type, bool drawFromCenter){

    

    switch(type){
      
      case ShapeType.line:
        return _getLinePath(points[0], points[1], drawFromCenter);
      case ShapeType.rect:
        return _getRectPath(points[0], points[1], drawFromCenter);   
    }

  }

  static String _getLinePath(Offset p1, Offset p2, bool drawFromCenter){
    
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
    
    return  'M $x1 $y1 L $x2 $y2';
  }

  static String _getRectPath(Offset p1, Offset p2, bool drawFromCenter){
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

     return 'M $x1 $y1 '
            'H $x2 V $y2 '
            'H $x1 Z';
  }



} // ShapePath