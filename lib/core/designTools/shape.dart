import "package:flutter/material.dart";
import 'package:path_drawing/path_drawing.dart';
import 'package:project_0x02/core/designTools/tools.dart';
import 'package:project_0x02/core/shortcuts.dart';

enum StrokeStyle {solid, dash, ovalDash}


/// ObjectShape is the class contains all drawing shape
class ShapeObject{

  Path path = Path();
  Color color;
  PaintingStyle paintingStyle;
  double strokeWidth;
  StrokeCap strokeCap;
  StrokeJoin strokeJoin;
  StrokeStyle strokeStyle;
  late String _pathData;

  String get pathData => _pathData;
  set pathData(String value){
    _pathData = value;
    path = parseSvgPathData(_pathData);
  }

  ShapeObject(
    { 
      String pathData = "",
      this.color = Colors.black,
      this.paintingStyle = PaintingStyle.fill,
      this.strokeWidth = 2,
      this.strokeCap = StrokeCap.butt,
      this.strokeJoin = StrokeJoin.bevel,
      this.strokeStyle = StrokeStyle.solid,
    }
  ){
    this.pathData = pathData;
  }

  void paint(Canvas canvas, Paint paint, Offset pointer){
    
    paint.color = color;
    paint.style = paintingStyle;
    paint.strokeWidth = strokeWidth;
    paint.strokeCap = strokeCap;
    paint.strokeJoin = strokeJoin;
    //TODO: implement more features here

    canvas.drawPath(path, paint);

  }

  

}


/// this class is only used in the drawing new shapes process
/// if the shape is already drawn into the canvas
/// and need some transformation or changes, 
/// this class has no capibility of doing so
class NewShapeObject{

  String pathData;
  Color color;
  PaintingStyle paintingStyle;
  double strokeWidth;
  StrokeCap strokeCap;
  StrokeJoin strokeJoin;
  StrokeStyle strokeStyle;


  bool _drawFromCenter = false;

  NewShapeObject(
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
    print("NewShapeObject created");
  }




  
  void paint(Canvas canvas, Paint paint, List<Offset> pointer, LeaderKeys leaderKey, ToolIndex tool) {
    _drawFromCenter = leaderKey.ctrl;

    pathData = _getBasicPath(pointer[0], pointer[1], tool);

    Path path = parseSvgPathData(pathData);
    paint.color = color;
    paint.style = paintingStyle;
    paint.strokeWidth = strokeWidth;
    paint.strokeCap = strokeCap;
    paint.strokeJoin = strokeJoin;
    canvas.drawPath(path, paint);
  
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

  String _getBasicPath(Offset p1, Offset p2, ToolIndex tool){
    double x1, x2, y1, y2;

    if(_drawFromCenter){
      x1 = 2*p1.dx - p2.dx;
      y1 = 2*p1.dy - p2.dy;
      x2 = p2.dx;
      y2 = p2.dy;    
    }else{
      x1 = p1.dx; y1 = p1.dy; 
      x2 = p2.dx; y2 = p2.dy;
    }


    switch(tool){
      case ToolIndex.line:
        paintingStyle = PaintingStyle.stroke;
        return  'M $x1 $y1 L $x2 $y2';
      case ToolIndex.rect: case ToolIndex.select:
        return 'M $x1 $y1 H $x2 V $y2 H $x1 Z';
      default: return "";
    }


  } // _gerBasicPath

  

}

