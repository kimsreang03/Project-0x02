import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

typedef Set = LogicalKeySet;
typedef Key = LogicalKeyboardKey;


final  Map<LogicalKeySet, Intent> shortcuts = {
  Set(Key.keyS):const SelectToolIntent(),
  Set(Key.escape): const SelectToolIntent(),

};

class SelectToolIntent extends Intent{
  const SelectToolIntent();
}



