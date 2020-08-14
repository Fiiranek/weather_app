import 'dart:async';

class CitiesBloc {
  
  List<String> _cities = ["Gdansk", "Warsaw", "Krakow", "Wroclaw", "Lodz"];

  // stream controllers
  final _citiesListStreamController = StreamController<List<String>>();

  final _citiesAddStreamController = StreamController<String>();
  final _citiesRemoveStreamController = StreamController<int>();

  //getters

  Stream<List<String>> get citiesListStream =>
      _citiesListStreamController.stream;

  StreamSink<List<String>> get citiesListSink =>
      _citiesListStreamController.sink;

  StreamSink<String> get cityAdd => _citiesAddStreamController.sink;
  StreamSink<int> get cityRemove => _citiesRemoveStreamController.sink;

  CitiesBloc() {
    _citiesListStreamController.add(_cities);

    _citiesAddStreamController.stream.listen(_addCity);
    _citiesRemoveStreamController.stream.listen(_removeCity);
  }

  _addCity(String city) {
    _cities.add(city);

    citiesListSink.add(_cities);
  }

  _removeCity(int index) {
    _cities.removeAt(index);
  }
  
  void dispose() {
    _citiesAddStreamController.close();
    _citiesRemoveStreamController.close();
    _citiesListStreamController.close();
  }
}
