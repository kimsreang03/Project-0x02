import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

typedef Set = LogicalKeySet;
typedef Key = LogicalKeyboardKey;


final  Map<LogicalKeySet, Intent> shortcuts = {

  /// shortcuts start with ctrl
  Set(Key.control, Key.keyS):const SaveIntent(),
  Set(Key.control, Key.keyN):const NewIntent(),
  Set(Key.control, Key.keyZ):const UndoIntent(),
  Set(Key.control, Key.keyY):const RedoIntent(),
  Set(Key.control, Key.keyI):const ImportIntent(),
  /// for macos platform where cmd key is used
  Set(Key.meta, Key.keyS):const SaveIntent(),
  Set(Key.meta, Key.keyN):const NewIntent(),
  Set(Key.meta, Key.keyZ):const UndoIntent(),
  Set(Key.meta, Key.keyY):const RedoIntent(),
  Set(Key.meta, Key.keyI):const ImportIntent(), 
  


  
  /// design tools
  Set(Key.keyS):const SelectToolIntent(),
  Set(Key.escape):const SelectToolIntent(),
  Set(Key.keyR): const RectToolIntent(),
  Set(Key.keyL): const LineToolIntent(),
  Set(Key.keyP): const PolygonToolIntent(),
  Set(Key.keyZ): const ZoomToolIntent(),


};



///  basic commands
///  mostly in the menu bar

class SaveIntent extends Intent{ const SaveIntent(); }
class NewIntent extends Intent{ const NewIntent(); }
class UndoIntent extends Intent{ const UndoIntent(); }
class RedoIntent extends Intent{ const RedoIntent(); }
class OpenIntent extends Intent{ const OpenIntent(); }
class ImportIntent extends Intent{ const ImportIntent(); }


//// all tools available for designing
// interaction tools
class SelectToolIntent extends Intent{ const SelectToolIntent(); }
class ZoomToolIntent extends Intent{ const ZoomToolIntent(); }
// start with ctrl
class DuplicateIntent extends Intent{ const DuplicateIntent(); }
class CopyIntent extends Intent{ const CopyIntent(); }
class PasteIntent extends Intent{ const PasteIntent(); }
class CutIntent extends Intent{ const CutIntent(); }
// object tools
class LineToolIntent extends Intent{ const LineToolIntent(); }
class RectToolIntent extends Intent{ const RectToolIntent(); }
class EllipseToolIntent extends Intent{ const EllipseToolIntent(); }
class ArcToolIntent extends Intent{ const ArcToolIntent(); }
class ColorPickerToolIntent extends Intent{ const ColorPickerToolIntent(); }
class TextToolIntent extends Intent{ const TextToolIntent(); }
class PolygonToolIntent extends Intent{ const PolygonToolIntent(); }

/// alignment tools
// class  extends Intent{ const (); }
// class  extends Intent{ const (); }
// class  extends Intent{ const (); }
// class  extends Intent{ const (); }
// class  extends Intent{ const (); }



