import QtQml 2.0
import QOwnNotesTypes 1.0
import QtQuick 2.4
import QtQuick.Controls 1.4

/**
 * This script shows current weather statistics in a "scripting label"
 * 
 * The Yahoo weather api is used for fetching the weather data
 * https://developer.yahoo.com/weather/
 */

Item {
    id: item
    property string dockWidgetId: "weatherStats";
    property string dockWidgetTitle: "Weather Stats";

    // you have to define your registered variables so you can access them later
    property string city;
    property bool useFahrenheit;

    // register your settings variables so the user can set them in the script settings
    property variant settingsVariables: [
        {
            "identifier": "city",
            "name": "City",
            "description": "Please enter your city:",
            "type": "string",
            "default": "Graz",
        },
        {
            "identifier": "useFahrenheit",
            "name": "Unit",
            "description": "Use Fahrenheit instead of Celsius",
            "type": "boolean",
            "default": false,
        },
    ];
    
    property string gWeatherCity: "unknown";

    function init() {
        script.registerLabel("weather stats");
        weatherLabel.weatherStats();
    }
    

    /**
     * This starts a timer that triggers every 10min
     */
    property QtObject timer: Timer {
        interval: 600000
        repeat: true
        running: true
        
        property int count: 0
        
        onTriggered: {
            weatherStats();
        }
    }

    Column {
        
        Slider {
        
            id: slider
            minimumValue: 0
            maximumValue: 100
        }
        
        Label {

            text: Math.floor(slider.value)
        }            

        Label {
            property string myText: "empty";
            id: weatherLabel
//            text: 'empty'
            //text: myText
            text: gWeatherCity
//            text: item.gWeatherCity
            font.pointSize: 24

            function setText(newText) {
                script.log(newText);
                //text = newText;
                myText = newText;
            }

            function weatherStats() {
                var unitString = useFahrenheit ? "f" :  "c"
                var json = script.downloadUrlToString("https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20weather.forecast%20where%20woeid%20in%20(select%20woeid%20from%20geo.places(1)%20where%20text%3D%22" + city + "%22)%20and%20u%3D%27" + unitString + "%27&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys");
                var weatherInfo = JSON.parse(json);

                var temp = weatherInfo.query.results.channel.item.condition.temp
                var tempUnit = weatherInfo.query.results.channel.units.temperature;
                var conditionText = weatherInfo.query.results.channel.item.condition.text
                var weatherCity = weatherInfo.query.results.channel.location.city
                var windSpeed = weatherInfo.query.results.channel.wind.speed
                var windUnit = weatherInfo.query.results.channel.units.speed;

                if (!useFahrenheit) {
                    tempUnit = "°" + tempUnit;
                }

                //weatherLabel.text = weatherCity;
                gWeatherCity = weatherCity;
                text = weatherCity;

                myText = weatherCity + "!";
                setText(weatherCity + "#");
        //        weatherLabel.myText ="<table align='center' width='90%'>
        //                                       <tr>
        //                                           <td align='center'>
        //                                               Weather in <b>" + weatherCity + "</b>: " + conditionText + " at <b>" + temp + " " + tempUnit + "</b>
        //                                               (" + windSpeed + " " + windUnit + " wind)
        //                                           </tb>
        //                                       </tr>
        //                                   </table>";

                script.setLabelText("weather stats",
                    "<table align='center' width='90%'>
                        <tr>
                            <td align='center'>
                                Weather in <b>" + weatherCity + "</b>: " + conditionText + " at <b>" + temp + " " + tempUnit + "</b>
                                (" + windSpeed + " " + windUnit + " wind)
                            </tb>
                        </tr>
                    </table>");
            }
        }

        Button {
            property int count: 0
            id: button1
            text: qsTr("Press Me")
            onClicked: function() {
                script.log("Button was pressed: " + count++);
                text = "Press " + count;
                weatherLabel.weatherStats();
                //gWeatherCity = count;
                //weatherLabel.text = count + "#";
                //weatherLabel.setText(count);
            }
        }
    }
} 