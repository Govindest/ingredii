#include <Arduino.h>

void setup() {
    Serial.begin(115200);
    Serial.println("Ingredii firmware started");
}

void loop() {
    delay(1000);
    Serial.println("running...");
}
