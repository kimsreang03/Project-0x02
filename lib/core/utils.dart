import 'package:project_0x02/core/designTools/shape.dart';



void addNewShape(List<ShapeObject> shapes, NewShapeObject newShape){
      
    shapes.add(ShapeObject(
      pathData: newShape.pathData,
      color: newShape.color,
      paintingStyle: newShape.paintingStyle,
      strokeWidth: newShape.strokeWidth,
      strokeCap: newShape.strokeCap,
      strokeJoin: newShape.strokeJoin,
      strokeStyle: newShape.strokeStyle,
    ));
  }