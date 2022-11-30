import 'package:rxdart/rxdart.dart';

class ItemController {
  static final BehaviorSubject<List<Item>> _mainScreenItems = BehaviorSubject();
  static Stream<List<Item>> get mainScreenItems => _mainScreenItems.stream;
  static final List<Item> _mainScreenValue = [];

  static final BehaviorSubject<List<ItemList>> _lists = BehaviorSubject();
  static Stream<List<ItemList>> get lists => _lists.stream;
  static final List<ItemList> _listsValue = [];

  Future load() async {
    //TODO load lists
  }

  static ItemList? getListByName(String name) {
    for(var i in _listsValue) {
      if(i.name == name) return i;
    }
    return null;
  }

  static void addList({required String name, List<Item>? items}) {
    _listsValue.add(ItemList(items: items ?? (<Item>[]), name: name));
    _forceUpdateLists();
  }

  static void addItem({String? list, required Item value}) {
    if(list == null) {
      _mainScreenValue.add(value);
      _forceUpdateMainItemsList();
    } else {
      var listValue = getListByName(list);
      if(listValue != null) {
        listValue.items.add(value);
        _forceUpdateLists();
      }
    }
  }

  static void removeItem({String? list, required Item value}){
    if(list == null) {
      _mainScreenValue.remove(value);
      _forceUpdateMainItemsList();
    } else {
      var listValue = getListByName(list);
      if(listValue != null) {
        listValue.items.remove(value);
        _forceUpdateLists();
      }
    }
  }

  static void deleteList({String? list}){
    if(list == null) {
      _mainScreenValue.clear();
      _forceUpdateMainItemsList();
    } else {
      var l = getListByName(list);
      if(l != null) {
        _listsValue.remove(l);
        _forceUpdateLists();
      }
    }
  }

  static void _forceUpdateMainItemsList() => _mainScreenItems.add(_mainScreenValue);
  static void _forceUpdateLists() => _lists.add(_listsValue);
}

class Item {
  const Item({required this.weight, required this.price,});
  final double weight;
  final double price;
}

class ItemList {
  const ItemList({required this.items, required this.name,});
  final List<Item> items;
  final String name;
}