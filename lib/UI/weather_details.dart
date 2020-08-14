import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:weather_app/UI/details_tile.dart';
import 'package:intl/intl.dart';

class WeatherDetails extends StatelessWidget {
  final int tag;
  final Map<String,dynamic> data;
  WeatherDetails({this.tag, this.data});

  @override
  Widget build(BuildContext context) {
     int temp = data["main"]["temp"].toInt();
    String cityName = data["name"];
    String countryName = data["sys"]["country"];
    String iconCode = data["weather"][0]["icon"];
    String weather = data["weather"][0]["description"];
    String pressure = data["main"]["pressure"].toString();
    String humidity = data["main"]["humidity"].toString();
    String windSpeed = data["wind"]["speed"].toString();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff293251),
        elevation: 0,
        leading: IconButton(
          icon: Icon(FontAwesomeIcons.chevronLeft),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Container(
          color: Color(0xff293251),
          alignment: Alignment.topCenter,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Hero(
                tag: tag,
                child: CircleAvatar(
                    radius: 70,
                    backgroundColor: Colors.grey[300],
                    child: Image.network(
                      'http://openweathermap.org/img/wn/$iconCode@2x.png',
                      //scale: 1,
                    )),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                temp.toString() + " °C",
                style: TextStyle(color: Colors.grey[200], fontSize: 46),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                cityName + " | " + countryName,
                style: TextStyle(color: Colors.grey[200], fontSize: 30),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                weather[0].toUpperCase()+weather.substring(1),
                style: TextStyle(color: Colors.grey[200], fontSize: 28),
              ),
              SizedBox(
                height: 30,
              ),
              Flexible(
                child: Container(
                  padding: EdgeInsets.all(10),
                  color: Colors.white,
                  child: 
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          DetailsTile(
                              imgUrl: "assets/pressure.png",
                              text: pressure + " hPa"),
                          DetailsTile(
                            imgUrl: "assets/humidity.png",
                            text: humidity + "%",
                          ),
                          DetailsTile(
                              imgUrl: "assets/wind.png", text: windSpeed + "  m/s"),
                    ],
                  ),
                ),
              )
            ],
          )),
    );
  }
}
