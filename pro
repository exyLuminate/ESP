#include <DHT.h>
#include <LiquidCrystal_I2C.h>
#include <Wire.h>

const int VIBRATION_PIN 4;
const int PIR_PIN = 3;
const int LDR_PIN = 5;
const int ledPin = 9;
const int BUZZER = 8;
const int RELAY = 2;

#define DHTPIN 6
#define DHT
#define DHTTYPE DHT11
DHT dht (DHTPIN, DHTTYPE)
LiquidCrystal_I2C lcd(0x27, 16, 2);

void setup() {
  lcd.backlight();
  Serial.begin(9600);
  dht.begin();
  lcd.init();
  int positionCounter;
  lcd.setCursor(2,0); 
  lcd.print("Ujian Akhir Praktikum")
  lcd.setCursor(2,1);
  lcd.print("1-C Alex, Azmi, Adit");
  for(positionCounter = 0; positionCounter < 21;
  positionCounter++) { lcd.scrollDisplayLeft();
  delay (350); }
  lcd.clear();

  pinMode(VIBRATION_PIN, INPUT); 
  pinMode(PIR_PIN, INPUT); 
  pinMode(LDR_PIN, INPUT); 
  pinMode(ledPin, OUTPUT);
  pinMode(BUZZER, OUTPUT);
  pinMode(RELAY, OUTPUT);

}

void loop() {
  float t = dht.readTemprature();
  float h = dht.readHumidity();
  int statusGetar = digitalRead(VIBRATION_PIN); 
  int motionState = digitalRead(PIR_PIN);
  int statusCahaya = digitalRead(LDR_PIN);

  if (warning) {
    tone(BUZZER, 2000); 
  } else {
    noTone(BUZZER);
  }

  bool warning = false;

    if (isnan(h) || isnan(t)) {
    Serial.println("Gagal membaca data dari sensor DHT!");
    return; }

    if (t > 30 || h < 40) {
    Serial.println("🚨 Peringatan! Suhu tinggi atau kelembaban rendah!");
    lcd.setCursor(0,0); 
    lcd.print("Peringatan!!!")
    lcd.setCursor(0,1);
    lcd.print("Suhu tinggi / kelembaban rendah");
    warning = true; }


  if (statusGetar == HIGH) {
    Serial.println("Getaran Terdeteksi!");
    lcd.setCursor(0,0); 
    lcd.print("Peringatan!!!")
    lcd.setCursor(0,1);
    lcd.print("Selamatkan Diri!!");
    warning = true;
  } else {
    Serial.println("Tidak ada getaran.");
    lcd.setCursor(0,0); 
    lcd.print("Tidak ada getaran.")
  }

  if (motionState == HIGH) {
    Serial.println("⚠️ Motion Detected!");
    digitalWrite(ledPin, HIGH);
    lcd.setCursor(0,0); 
    lcd.print("Ada pergerakan.") 
    } else {
    digitalWrite(ledPin, LOW); 
    }

  if (statusCahaya == HIGH){
    Serial.println("gelap");
    digitalWrite(RELAY, HIGH);
    lcd.setCursor(0,0); 
    lcd.print("Gelap") 
  } else {
    digitalWrite(RELAY, LOW); 
  }
  delay(1000);
}


