import 'dart:convert';

import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ItemController {
  static String? currentList;

  static final BehaviorSubject<List<Item>> _mainScreenItems = BehaviorSubject();
  static Stream<List<Item>> get mainScreenItems => _mainScreenItems.stream;
  static List<Item> _mainScreenValue = [];

  static final BehaviorSubject<List<ItemList>> _lists = BehaviorSubject();
  static Stream<List<ItemList>> get lists => _lists.stream;
  static List<ItemList> _listsValue = [];

  static Future load() async {
    final prefs = await SharedPreferences.getInstance();
    var jsonV = prefs.getString('data');

    if (jsonV?.isNotEmpty ?? false) {
      var dataObject = _AppData.fromJson(json.decode(jsonV!));
      _listsValue = dataObject.lists ?? [];
      _mainScreenValue = dataObject.mainScreenItems ?? [];
      _forceUpdateLists();
      _forceUpdateMainItemsList();
    }
  }

  static Future save() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(
      'data',
      json.encode(
        _AppData(
          mainScreenItems: _mainScreenValue,
          lists: _listsValue,
        ),
      ),
    );
  }

  static bool checkItemUnique(Item item) {

    bool value = true;

    for (var element in _mainScreenValue) {
      if(element.price == item.price && element.weight == item.weight) {
        value = false;
      }
    }

    return value;
  }

  static ItemList? getListByName(String name) {
    for (var i in _listsValue) {
      if (i.name == name) return i;
    }
    return null;
  }

  static void replaceItem(
      {required Item oldItem, required Item newItem, String? list}) {
    List<Item>? arr =
        list == null ? _mainScreenValue : getListByName(list!)?.items;

    if (arr != null) {
      var i = arr.indexOf(oldItem);
      arr.remove(oldItem);
      arr.insert(i, newItem);
    }

    list == null ? _forceUpdateMainItemsList() : _forceUpdateLists() ;
  }

  static void addList(
      {required String name, List<Item>? items, int? position}) {
    var value = ItemList(items: items ?? _mainScreenValue, name: name);
    position == null
        ? _listsValue.add(value)
        : _listsValue.insert(position!, value);
    if (items == null) {
      ItemController.deleteList();
    }
    _forceUpdateLists();
  }

  static void renameList({required String oldName, required String newName}) {
    getListByName(oldName)?.name = newName;
    _forceUpdateLists();
  }

  static void addItem({String? list, required Item value, int? position}) {
    if (list == null) {
      position == null
          ? _mainScreenValue.add(value)
          : _mainScreenValue.insert(position, value);
      _forceUpdateMainItemsList();
    } else {
      var listValue = getListByName(list);
      if (listValue != null) {
        position == null
            ? listValue.items?.add(value)
            : listValue.items?.insert(position, value);
        _forceUpdateLists();
      }
    }
  }

  static void removeItem({String? list, required Item value}) {
    if (list == null) {
      _mainScreenValue.remove(value);
      _forceUpdateMainItemsList();
    } else {
      var listValue = getListByName(list);
      if (listValue != null) {
        listValue.items?.remove(value);
        _forceUpdateLists();
      }
    }
  }

  static void deleteList({String? list}) {
    if (list == null) {
      _mainScreenValue = [];
      _forceUpdateMainItemsList();
    } else {
      var l = getListByName(list);
      if (l != null) {
        _listsValue.remove(l);
        _forceUpdateLists();
      }
    }
  }

  static void _forceUpdateMainItemsList() {
    _mainScreenItems.add(_mainScreenValue);
    save();
  }

  static void _forceUpdateLists() {
    _lists.add(_listsValue);
    save();
  }
}

class Item {
  Item({
    required this.weight,
    required this.price,
  });
  double? weight;
  double? price;

  Item.fromJson(Map<String, dynamic> json) {
    weight = json['weight'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['weight'] = weight;
    data['price'] = price;
    return data;
  }
}

class ItemList {
  ItemList({
    required this.items,
    required this.name,
  });
  List<Item>? items = [];
  String? name;

  ItemList.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    if (json['items'] != null) {
      items = <Item>[];
      json['items'].forEach((v) {
        items!.add(Item.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['name'] = name;
    if (items != null) {
      data['items'] = items!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class _AppData {
  _AppData({
    required this.mainScreenItems,
    required this.lists,
  });
  List<Item>? mainScreenItems;
  List<ItemList>? lists;

  _AppData.fromJson(Map<String, dynamic> json) {
    if (json['mainScreenItems'] != null) {
      mainScreenItems = <Item>[];
      json['mainScreenItems'].forEach((v) {
        mainScreenItems!.add(Item.fromJson(v));
      });
    }
    if (json['lists'] != null) {
      lists = <ItemList>[];
      json['lists'].forEach((v) {
        lists!.add(ItemList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    if (mainScreenItems != null) {
      data['mainScreenItems'] =
          mainScreenItems!.map((v) => v.toJson()).toList();
    }
    if (lists != null) {
      data['lists'] = lists!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
