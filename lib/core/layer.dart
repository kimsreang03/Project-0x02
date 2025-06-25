
enum NodeType {group, object, image}

abstract class Node{

  int index = 0;
  int? id;
  int? parentId;
  bool visibility = true;
  bool locked = false;
  double opacity = 1;
  final String name;

  NodeType get type;

  Node(this.name){
    id = Object.hash(name, parentId, hashCode);
  }


}

class ObjectNode extends Node{

  @override
  final NodeType type = NodeType.object;

  

  ObjectNode(super.name);
  
  
  
}


class GroupNode extends Node{

  @override
  final NodeType type = NodeType.group;

  List<Node> _children = [];

  GroupNode(super.name, [List<Node>? children]){
    if(children != null) {

      for(int i = 0; i < children.length; i++) {
        children[i].parentId = id;
      }

      _children = children;
    }
  }

  List<Node> getChildrens(){
    return _children;
  }

  bool _isNameDuplicated(Node newChild){


    for(Node node in _children){
      if(newChild.type != node.type) continue;
      if(newChild.name == node.name) return true;
    }

    return false;
  }
   
  
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
    
  }



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
    
  }



  void remove(Node child){
    
    int index = child.index;
    _children.removeAt(index);
    // reset the index of each child
    for(int i = index; i < _children.length; i++){
      _children[i].index -= 1;
    }

  }



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
  
  }



 
  void moveChildGroup(Node child, GroupNode group, int index) {
    
    // check if the child it in this group
    if(child.parentId != id){
      print("Given node is an outsider: ${child.name}");
      return;
    }

    remove(child);
    group.insert(index, child);

  }
  
  
  
}
