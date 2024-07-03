#include <WiFi.h>
#include <HTTPClient.h>
#include <TFT_eSPI.h>
#include <DHT.h>

// Configuración de la red Wi-Fi
const char* ssid = ".:PC Puma FI:.";
const char* password = "";

// Pin del sensor de humedad de suelo
const int sensorPin = 34; // GPIO 34

// Pin de la bomba de agua
const int pumpPin = 12; // GPIO 12

// Pin del sensor DHT11
const int dhtPin = 4; // GPIO 4

// Pin del ventilador
const int fanPin = 13; // GPIO 13

// Umbrales de humedad para diferentes estados
const int umbralSeco = 30;
const int umbralHumedo = 60;

// Umbrales de temperatura para el ventilador
const int umbralTempBaja = 35; // Activar ventilador si la temperatura es mayor a 20°C
const int umbralTempAlta = 19; // Apagar ventilador si la temperatura es menor a 25°C

// Configuración de la pantalla TFT
TFT_eSPI tft = TFT_eSPI(); // Crear objeto de pantalla TFT

// Configuración del sensor DHT11
#define DHTTYPE DHT11
DHT dht(dhtPin, DHTTYPE);

// Declaración de la variable WiFi ,.Client
WiFiClient client;

// API Key y URL de ThingSpeak
const char* apiKey = "SGBM02NJ79EADC12";
const char* thingSpeakUrl = "http://api.thingspeak.com/update";

// Variables para la gráfica
const int maxReadings = 240; // Número de lecturas que se muestran en la gráfica
int readings[maxReadings];   // Array para almacenar las lecturas de humedad
int currentIndex = 0;        // Índice actual en el array de lecturas

void setup() {
  Serial.begin(115200);
  delay(100);

  // Configurar los pines como salida o entrada
  pinMode(pumpPin, OUTPUT);
  pinMode(fanPin, OUTPUT);
  pinMode(sensorPin, INPUT);

  // Inicializar la pantalla TFT
  tft.init();
  tft.setRotation(1); // Ajusta la rotación de la pantalla según sea necesario
  tft.fillScreen(TFT_BLACK);
  tft.setTextColor(TFT_WHITE, TFT_BLACK);
  tft.setTextSize(1);

  // Inicializar la gráfica
  for (int i = 0; i < maxReadings; i++) {
    readings[i] = 0;
  }

  // Inicializar el sensor DHT11
  dht.begin();

  // Conectar a la red Wi-Fi
  Serial.println();
  Serial.print("Conectando a ");
  Serial.println(ssid);

  WiFi.begin(ssid, password);

  unsigned long startAttemptTime = millis();

  while (WiFi.status() != WL_CONNECTED && millis() - startAttemptTime < 10000) {
    delay(500);
    Serial.print(".");
  }

  if (WiFi.status() != WL_CONNECTED) {
    Serial.println("Error: No se pudo conectar a la red WiFi.");
  } else {
    Serial.println("");
    Serial.println("Conexión WiFi establecida");
    Serial.print("Dirección IP: ");
    Serial.println(WiFi.localIP());
  }
}

void loop() {
  // Leer el valor del sensor de humedad de suelo
  int sensorValue = analogRead(sensorPin);

  // Mapear el valor del sensor a un porcentaje de humedad
  int moisturePercent = map(sensorValue, 0, 4095, 0, 100);

  // Leer temperatura del sensor DHT11
  float temperature = dht.readTemperature();

  // Verificar si la lectura es válida
  if (isnan(temperature)) {
    Serial.println("Error al leer la temperatura del DHT11");
    return;
  }

  // Imprimir valores en el monitor serie
  Serial.print("Humedad: ");
  Serial.print(moisturePercent);
  Serial.print("%, Temperatura: ");
  Serial.print(temperature);
  Serial.println("°C");

  // Enviar datos a ThingSpeak
  if (WiFi.status() == WL_CONNECTED) {
    HTTPClient http;
    String url = String(thingSpeakUrl) + "?api_key=" + apiKey + "&field1=" + String(moisturePercent) + "&field2=" + String(temperature);
    http.begin(url);
    int httpResponseCode = http.GET();
    if (httpResponseCode > 0) {
      Serial.print("Datos enviados a ThingSpeak. Código de respuesta: ");
      Serial.println(httpResponseCode);
    } else {
      Serial.print("Error al enviar los datos a ThingSpeak. Código de error: ");
      Serial.println(httpResponseCode);
    }
    http.end();
  } else {
    Serial.println("Error: No hay conexión WiFi.");
  }

  // Encender o apagar la bomba de agua según el nivel de humedad del suelo
  if (moisturePercent > umbralSeco) {
    digitalWrite(pumpPin, HIGH); // Enciende la bomba de agua
    Serial.println("Activando bomba de agua (suelo seco)");
  } else {
    digitalWrite(pumpPin, LOW);  // Apaga la bomba de agua
    Serial.println("Desactivando bomba de agua (suelo húmedo)");
  }

  // Encender o apagar el ventilador según la temperatura
  if (temperature > umbralTempBaja) {
    digitalWrite(fanPin, HIGH); // Enciende el ventilador
    Serial.println("Activando ventilador (temperatura alta)");
  } else if (temperature < umbralTempAlta) {
    digitalWrite(fanPin, LOW); // Apaga el ventilador
    Serial.println("Desactivando ventilador (temperatura baja)");
  }

  // Actualizar la gráfica
  readings[currentIndex] = moisturePercent;
  currentIndex = (currentIndex + 1) % maxReadings;
  drawGraph();

  delay(1000); // Esperar 1 segundo antes de la siguiente lectura
}

void drawGraph() {
  tft.fillRect(0, 0, 240, 60, TFT_BLACK); // Limpiar área de la gráfica
  for (int i = 0; i < maxReadings - 1; i++) {
    int x1 = i;
    int y1 = 60 - map(readings[(currentIndex + i) % maxReadings], 0, 100, 0, 60);
    int x2 = i + 1;
    int y2 = 60 - map(readings[(currentIndex + i + 1) % maxReadings], 0, 100, 0, 60);
    tft.drawLine(x1, y1, x2, y2, TFT_GREEN);
  }
}