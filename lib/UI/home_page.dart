import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:weather_app/UI/weather_details.dart';
import 'package:weather_app/UI/weather_tile.dart';
import 'package:weather_app/cities_bloc.dart';
import 'package:weather_app/hive_methods.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final CitiesBloc _citiesBloc = CitiesBloc();

  static Box box;

  // 
  Future openBox() async {
    var dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
    box = await Hive.openBox("addedCities");
    print("Hive initialized successfuly");
    for (int i = 0; i < box.length; i++) {
      _citiesBloc.cityAdd.add(box.getAt(i));
    }
  }

  @override
  void initState() {
    super.initState();
    openBox();
  }

  bool changeState = false;

  @override
  void dispose() {
    _citiesBloc.dispose();
    super.dispose();
  }

  // Future<void> _refresh(){
    
  // }

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return  
    // RefreshIndicator(
    //   key: _refreshIndicatorKey,
    //   onRefresh: _refresh,
    //   child: 
      Scaffold(
        appBar: AppBar(
          title: Text("Weather App"),
          backgroundColor: Color(0xff293251),
          elevation: 0,
          actions: [
            // add city button
            FlatButton.icon(
              label: Text(
                "Add city",
                style: TextStyle(color: Colors.white),
              ),
              icon: Icon(Icons.add, color: Colors.white),
              // show dialog with textfield
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: TextField(
                          controller: _controller,
                          decoration: InputDecoration(hintText: "City name"),
                        ),
                        actions: [
                          // cancel button
                          FlatButton(
                            onPressed: () {
                              _controller.clear();
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              'Cancel',
                              style: TextStyle(color: Colors.grey[700]),
                            ),
                          ),
                          // add button
                          FlatButton(
                            onPressed: () {
                              _citiesBloc.cityAdd.add(_controller.text);
                              HiveMethods(box: box).addCity(_controller.text);
                              _controller.clear();
                              Navigator.of(context).pop();
                            },
                            child: Text('Add'),
                          )
                        ],
                      );
                    });
              },
            )
          ],
        ),
        body: Container(
          child: StreamBuilder<List<String>>(
              stream: _citiesBloc.citiesListStream,
              builder:
                  (BuildContext context, AsyncSnapshot<List<String>> streamSnap) {
                // if stream has data => return listview  
                if (streamSnap.hasData) {
                  int count = streamSnap.data.length ?? 0;
                  return ListView.builder(
                      itemCount: count,
                      itemBuilder: (context, index) {
                        Future<dynamic> fetchCity(String city) async {
                          final response = await get(
                              'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=fc5abc156d3fb80a7017e653d2466342&units=metric');

                          return response;
                        }
                        return FutureBuilder(
                          future: fetchCity(streamSnap.data[index]),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              Map<String, dynamic> data =
                                  jsonDecode(snapshot.data.body);
                                
                              return GestureDetector(
                                // push to weather details 
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => WeatherDetails(
                                              tag: index, data: data)));
                                },
                                onLongPress: () {
                                  // if city index > 4 => delete city from list and hive box  
                                  if(index>4){
                                     _citiesBloc.cityRemove.add(index);
                                  HiveMethods(box: box).deleteCity(index);
                                  setState(() {
                                    changeState = true;
                                  });
                                  }
                                },
                                child: WeatherTile(
                                    data: data, index: index - 5, tag: index),
                              );
                            } 
                            // return card with Loading... while fetching data from API
                            else {
                              return Card(
                                margin:
                                    EdgeInsets.only(top: 10, right: 10, left: 10),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  child: Text("Loading..."),
                                ),
                              );
                            }
                          },
                        );
                      });
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }),
        ),
      // ),
    );
  }
}
