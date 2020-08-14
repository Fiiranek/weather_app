
import 'package:hive/hive.dart';

class HiveMethods{
  
  final Box box;
  HiveMethods({this.box});

  // add city to hive box
  void addCity(String city) {
    box.put(box.length, city);
  }

  // delete city from hive box
  void deleteCity(int index) {
    box.deleteAt(index - 5);
  }
}