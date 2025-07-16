# Arduino Camera with Blynk and Computer Vision

This example shows how to connect an ESP32-CAM to Blynk and a Python server
that performs image classification using TensorFlow Lite.

## Hardware
- ESP32-CAM module
- Power supply (5V)

## Arduino Setup
1. Install the **ESP32** board support in the Arduino IDE.
2. Install the `Blynk` library from the Arduino Library Manager.
3. Open `camera_blynk.ino` and update the following placeholders:
   - `YOUR_WIFI_SSID` / `YOUR_WIFI_PASSWORD`
   - `YOUR_BLYNK_TOKEN`
   - `YOUR_SERVER_IP`
4. Select the board **AI Thinker ESP32-CAM** and upload the sketch.

The sketch captures a JPEG image every 3 seconds and posts it to the Python
server. The response from the server is written to Blynk virtual pin **V0**.

## Python Server
1. Install dependencies:
   ```bash
   pip install -r requirements.txt
   ```
2. Copy or train a TensorFlow Lite model and place it as `model.tflite` in this
directory.
3. Run the server:
   ```bash
   python server.py
   ```
   The server listens on port **5000** for image uploads.

When an image is received, the server performs classification using the model
and sends the result back to the ESP32-CAM. The same result is forwarded to
Blynk through the Blynk HTTP API.

## Blynk Configuration
1. Create a new Blynk project and note the **auth token**.
2. Add a **Value Display** widget to virtual pin **V0** to see classification
   results.
3. Ensure your phone and ESP32 are on the same network or use Blynk cloud.

## Notes
- This is a minimal example. Depending on your application, you may need to
  adjust camera settings, model preprocessing, or memory usage.
- TensorFlow Lite models may be trained using a dataset of food images so that
  the classifier can recognize your specific items.
