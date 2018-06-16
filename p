#include <Adafruit_Sensor.h>
#include <DHT.h>
#include <DHT_U.h>
#include <BH1750.h>
#include <Wire.h>
#include <Firebase.h>
#include <FirebaseArduino.h>
#include <FirebaseCloudMessaging.h>
#include <FirebaseError.h>
#include <FirebaseHttpClient.h>
#include <FirebaseObject.h>
#include <ESP8266WiFi.h>
#include <ESP8266WiFiAP.h>
#include <ESP8266WiFiGeneric.h>
#include <ESP8266WiFiMulti.h>
#include <ESP8266WiFiScan.h>
#include <ESP8266WiFiSTA.h>
#include <ESP8266WiFiType.h>
#include <WiFiClient.h>
#include <WiFiClientSecure.h>
#include <WiFiServer.h>
#include <WiFiServerSecure.h>
#include <WiFiUdp.h>

BH1750 lightMeter;

#define FIREBASE_HOST "https://proj-1-df3fa.firebaseio.com/"
#define WIFI_SSID "spider" // Change the name of your WIFI
#define WIFI_PASSWORD "88888888" // Change the password of your WIFI

#define DHTPIN            14  //dpin5
#define DHTTYPE           DHT11 
#define pinMode(D8, OUTPUT);
#define pinMode(D9, OUTPUT);
DHT dht(DHTPIN, DHTTYPE);


void setup(){
   
  Serial.begin(9600);
  digitalWrite(D8, LOW);
  digitalWrite(D9, LOW);
  lightMeter.begin();
    Wire.begin(D2,D1);

      WiFi.begin (WIFI_SSID, WIFI_PASSWORD);
   while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
   dht.begin();
  Serial.println ("");
  Serial.println ("WiFi Connected!");
  Firebase.begin(FIREBASE_HOST);
}

void loop() {
  
  

  
  float h = dht.readHumidity();
  
  float t = dht.readTemperature();
  // Read temperature as Fahrenheit 
  float f = dht.readTemperature(true);
  
  float l = lightMeter.readLightLevel();
 
  if (isnan(h) || isnan(t) || isnan(f)) {
    Serial.println("Failed to read from DHT sensor");
    return;
  }
  
  if (isnan(l)){
    Serial.println("Failed to read from Bh1750 sensor");
    return;
  }

   if (h >= 55 || t >=32){
  digitalWrite(D8, HIGH);
  }

   if (l <= 25){
  digitalWrite(D9, HIGH);
  }
  
  float hif = dht.computeHeatIndex(f, h);
  // Compute heat index in Celsius (isFahreheit = false)
  float hic = dht.computeHeatIndex(t, h, false);

  Serial.print("Humidity: ");
  Serial.print(h);
  Serial.print(" %");
  Serial.print("Temperature: ");
  Serial.print(t);
  Serial.print(" *C ");
  Serial.print("Light: ");
  Serial.print(l);
  Serial.println(" lx");

  Firebase.setFloat ("Temp",t);
  Firebase.setFloat ("Humidity",h);
  Firebase.setFloat ("light intensity",l);
 delay(1000);
}
