import 'package:rxdart/rxdart.dart';

class ItemController {
  static final BehaviorSubject<List<Item>> _mainScreenItems = BehaviorSubject();
  static Stream<List<Item>> get mainScreenItems => _mainScreenItems.stream;
  final List<Item> _mainScreenValue = [];

  void addItem({String? list, required Item value}) {
    if(list == null) {
      _mainScreenValue.add(value);
    }
  }

  void removeItem({String? list, required Item value}){
    if(list == null) {
      _mainScreenValue.remove(value);
    }
  }

  void deleteList({String? list}){
    if(list == null) {
      _mainScreenValue.clear();
    }
  }
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