#include <WiFi.h>
#include <BlynkSimpleEsp32.h>
#include "esp_camera.h"
#include <HTTPClient.h>

// Replace with your network credentials
const char* ssid = "YOUR_WIFI_SSID";
const char* password = "YOUR_WIFI_PASSWORD";

// Blynk authentication token
char auth[] = "YOUR_BLYNK_TOKEN";

// Server that will process images
const char* serverUrl = "http://YOUR_SERVER_IP:5000/upload";

void setup() {
  Serial.begin(115200);
  // Initialize camera with default pins for ESP32-CAM
  camera_config_t config;
  config.ledc_channel = LEDC_CHANNEL_0;
  config.ledc_timer = LEDC_TIMER_0;
  config.pin_d0 = 5;
  config.pin_d1 = 18;
  config.pin_d2 = 19;
  config.pin_d3 = 21;
  config.pin_d4 = 36;
  config.pin_d5 = 39;
  config.pin_d6 = 34;
  config.pin_d7 = 35;
  config.pin_xclk = 0;
  config.pin_pclk = 22;
  config.pin_vsync = 25;
  config.pin_href = 23;
  config.pin_sscb_sda = 26;
  config.pin_sscb_scl = 27;
  config.pin_pwdn = 32;
  config.pin_reset = -1;
  config.xclk_freq_hz = 20000000;
  config.pixel_format = PIXFORMAT_JPEG;
  config.frame_size = FRAMESIZE_VGA;
  config.jpeg_quality = 10;
  config.fb_count = 1;

  // Camera init
  esp_err_t err = esp_camera_init(&config);
  if (err != ESP_OK) {
    Serial.printf("Camera init failed with error 0x%x", err);
    return;
  }

  // Connect WiFi and Blynk
  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  Serial.println("WiFi connected");
  Blynk.begin(auth, ssid, password);
}

void loop() {
  Blynk.run();

  // Capture image
  camera_fb_t * fb = esp_camera_fb_get();
  if (!fb) {
    Serial.println("Camera capture failed");
    delay(1000);
    return;
  }

  // Send image to server
  if (WiFi.status() == WL_CONNECTED) {
    HTTPClient http;
    http.begin(serverUrl);
    http.addHeader("Content-Type", "application/octet-stream");
    int httpResponseCode = http.POST(fb->buf, fb->len);

    if (httpResponseCode == HTTP_CODE_OK) {
      String payload = http.getString();
      // Send classification result to Blynk virtual pin V0
      Blynk.virtualWrite(V0, payload);
    } else {
      Serial.printf("Server error: %d\n", httpResponseCode);
    }
    http.end();
  }

  esp_camera_fb_return(fb);
  delay(3000); // wait 3 seconds before next capture
}
