import 'package:flutter/material.dart';

enum NodeType {group, object, image}



/// Node is a generic type that contains all kind of objects in the tree node
/// including group, shape, images
/// subclass: ObjectNode, GroupNode 
abstract class Node{

  int index = 0;
  int? id;
  int? parentId;
  bool isVisible = true;
  bool islocked = false;
  double opacity = 1;
  final String name;

  NodeType get type;
  Rect boundingBox;


  Node(this.name, this.boundingBox){
    id = Object.hash(name, parentId, hashCode);
  }


}

class ObjectNode extends Node{

  @override
  final NodeType type = NodeType.object;

  
  // TODO: need implementation
  ObjectNode(super.name, super.boundingBox);
  
  
  
}


class GroupNode extends Node{

  @override
  final NodeType type = NodeType.group;

  List<Node> _children = [];


  GroupNode(super.name, super.boundingBox, [List<Node>? children]){
    if(children != null) {
      for(int i = 0; i < children.length; i++) {
        children[i].parentId = id;
      }
      _children = children;
    }
  } // constructor


  // can be removed
  List<Node> getChildrens(){
    return _children;
  }

  bool _isNameDuplicated(Node newChild){

    // directly comparing string
    for(Node node in _children){
      if(newChild.type != node.type) continue;
      if(newChild.name == node.name) return true;
    }

    return false;
  } // isNameDuplicated
   
  
  void add(Node child){

    if(_isNameDuplicated(child)) {
      print("name duplication: ${child.name}");
      return; 
    }

    // update the index 
    if(_children.isNotEmpty){
      child.index = _children.last.index + 1;
    }
    child.parentId = id;
    _children.add(child);
    
  } // add



  void insert(int index, Node child) {

    if(_isNameDuplicated(child)) {
      print("name duplication: ${child.name}");
      return; 
    }


    // update the index 
    if(_children.isNotEmpty){
      child.index = index;
      child.parentId = id;
      _children.insert(child.index, child);
      
      // update index
      index++;
      for(int i = index; i < _children.length ; i++){
        _children[i].index = index;
        index++;
      }

    }else {
      add(child);
    }
    
  } // insert



  void remove(Node child){
    
    int index = child.index;
    _children.removeAt(index);
    // reset the index of each child
    for(int i = index; i < _children.length; i++){
      _children[i].index -= 1;
    }

  } // remove



  void moveChildIndex(Node child, int newIndex) {

    // check if the child it in this group
    if(child.parentId != id){
      print("Given node is an outsider: ${child.name}");
      return;
    }

    Node tmp = _children.removeAt(child.index);
    _children.insert(newIndex, tmp);

    //reset the index
    for(int i = 0; i < _children.length; i++){
      _children[i].index = i;
    }
  
  } // moveChildIndex



 
  void moveChildGroup(Node child, GroupNode group, int index) {
    
    // check if the child it in this group
    if(child.parentId != id){
      print("Given node is an outsider: ${child.name}");
      return;
    }

    remove(child);
    group.insert(index, child);

  } // moveChildGroup
  
  
  
}
