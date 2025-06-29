
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project_0x02/core/designTools/tools.dart';

typedef Set = LogicalKeySet;
typedef Key = LogicalKeyboardKey;

class LeaderKeys{
  bool shift = false;
  bool ctrl = false;
  bool alt = false;
  bool space = false;
}

final  Map<LogicalKeySet, Intent> shortcutsMap = {

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
  Set(Key.keyS):   const SelectToolIntent(),
  Set(Key.escape): const SelectToolIntent(),
  Set(Key.keyZ):   const ZoomToolIntent(),

  Set(Key.keyT):   const TextToolIntent(), // second key for select
  Set(Key.keyR):   const RectToolIntent(),
  Set(Key.keyL):   const LineToolIntent(),
  Set(Key.keyP):   const PolygonToolIntent(),
  Set(Key.keyE):   const EllipseToolIntent(),
  Set(Key.keyD):   const ColorPickerToolIntent(),

};


Map<Type, Action<Intent>> buildActionsMap(void Function(ToolIndex) setToolIndex){

  return <Type, Action<Intent>>{

    //// actions map for design tools
    // interaction tools
    SelectToolIntent: CallbackAction<SelectToolIntent> (onInvoke: (tool){
      setToolIndex(tool.index);
      return null;
    }),
    ZoomToolIntent: CallbackAction<ZoomToolIntent> (onInvoke: (tool){
      setToolIndex(tool.index);
      return null;
    }),
    // creating object tools
    TextToolIntent: CallbackAction<TextToolIntent>(onInvoke: (tool){
      setToolIndex(tool.index);
      return null;
    }),
    RectToolIntent: CallbackAction<RectToolIntent>(onInvoke: (tool){
      setToolIndex(tool.index);
      return null;
    }),
    LineToolIntent: CallbackAction<LineToolIntent>(onInvoke: (tool){
      setToolIndex(tool.index);
      return null;
    }),
    EllipseToolIntent: CallbackAction<EllipseToolIntent>(onInvoke: (tool){
      setToolIndex(tool.index);
      return null;
    }),
    PolygonToolIntent: CallbackAction<PolygonToolIntent>(onInvoke: (tool){
      setToolIndex(tool.index);
      return null;
    }),
    ColorPickerToolIntent: CallbackAction<ColorPickerToolIntent>(onInvoke: (tool){
      setToolIndex(tool.index);
      return null;
    }),
    ////

  };
}



///  basic commands
///  mostly in the menu bar

class SaveIntent extends Intent{ 
  const SaveIntent(); 
}
class NewIntent extends Intent{
  const NewIntent(); 
}
class UndoIntent extends Intent{ const UndoIntent(); }
class RedoIntent extends Intent{ const RedoIntent(); }
class OpenIntent extends Intent{ const OpenIntent(); }
class ImportIntent extends Intent{ const ImportIntent(); }



// start with ctrl
class DuplicateIntent extends Intent{ const DuplicateIntent(); }
class CopyIntent extends Intent{ const CopyIntent(); }
class CutIntent extends Intent{ const CutIntent(); }
class PasteIntent extends Intent{ const PasteIntent(); }

//// all tools available for designing
// interaction tools
class SelectToolIntent extends Intent{
  final ToolIndex index = ToolIndex.select;
  const SelectToolIntent(); 
}
class ZoomToolIntent extends Intent{ 
  final ToolIndex index = ToolIndex.zoom;
  const ZoomToolIntent(); 
}

// object tools
class LineToolIntent extends Intent{ 
  final ToolIndex index = ToolIndex.line;
  const LineToolIntent(); 
}
class RectToolIntent extends Intent{ 
  final ToolIndex index = ToolIndex.rect;
  const RectToolIntent(); 
}
class EllipseToolIntent extends Intent{ 
  final ToolIndex index = ToolIndex.elilipse;
  const EllipseToolIntent(); 
}
class ColorPickerToolIntent extends Intent{ 
  final ToolIndex index = ToolIndex.colorPicker;
  const ColorPickerToolIntent(); 
}
class TextToolIntent extends Intent{ 
  final ToolIndex index = ToolIndex.text;
  const TextToolIntent(); 
}
class PolygonToolIntent extends Intent{ 
  final ToolIndex index = ToolIndex.poloygon;
  const PolygonToolIntent(); 
}
///////////////



/// alignment tools
// class  extends Intent{ const (); }
// class  extends Intent{ const (); }
// class  extends Intent{ const (); }
// class  extends Intent{ const (); }
// class  extends Intent{ const (); }



