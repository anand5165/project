#include <BH1750.h>
#include <Adafruit_Sensor.h>
#include <DHT.h>
#include <DHT_U.h>

#define DHTPIN            2   
#define DHTTYPE           DHT11 
#define pinMode(D8, OUTPUT);
#define pinMode(D9, OUTPUT);

DHT dht(DHTPIN, DHTTYPE);
BH1750 lightMeter;

void setup() {
  Serial.begin(9600);
  digitalWrite(D8, LOW);
  digitalWrite(D9, LOW);
  lightMeter.begin();
  Wire.begin(D2,D1);
  dht.begin();
}

void loop() {
  
  delay(1000);

  
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
 
}
