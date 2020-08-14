import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// weather tile => small tile with city, country code, temperature and icon, which is displayed on the home page
class WeatherTile extends StatelessWidget {
  final Map<String,dynamic> data;
  final int index;
  final int tag;
  WeatherTile({this.tag, this.index,this.data});

  @override
  Widget build(BuildContext context) {

    
    if (data["cod"] == 200) {
      int temp = data["main"]["temp"].toInt();
      String cityName = data["name"];
      String countryName = data["sys"]["country"];
      String iconCode = data["weather"][0]["icon"];
      return Card(
        margin: EdgeInsets.only(top: 10, right: 10, left: 10),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cityName,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      Text(countryName, style: TextStyle(fontSize: 18)),

                      SizedBox(width: 10,),
                      Image.network('http://openweathermap.org/images/flags/${countryName.toLowerCase()}.png')
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    temp.toString() + " °C",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Hero(
                    tag: tag,
                    child: CircleAvatar(
                        backgroundColor: Colors.grey[300],
                        child: Image.network(
                          'http://openweathermap.org/img/wn/$iconCode@2x.png',
                          height: 50,
                        )),
                  )
                ],
              )
            ],
          ),
        ),
      );
    } 
    // return tile with information, that city name is incorrect
    else {
      return Card(
          margin: EdgeInsets.only(top: 10, right: 10, left: 10),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  FontAwesomeIcons.times,
                  color: Colors.red[400],
                  size: 30,
                ),
                Text("Incorrect city name",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20))
              ],
            ),
          ),
      );
    }
  }
}
