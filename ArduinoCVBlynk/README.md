# Arduino Camera with Blynk and Computer Vision

This example shows how to connect an ESP32-CAM to Blynk and a Python server
that performs image classification and optional on-device text recognition
using TensorFlow Lite. The goal is to identify pantry items and, when needed,
read the ingredient or nutrition label directly on the device.

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
2. Download the **MobileNetV2 Food Classifier** TFLite model from
   [Pramit726/MobileNetV2-FoodClassifier](https://github.com/Pramit726/MobileNetV2-FoodClassifier)
   and save it as `mobilenet_v2_food_classifier.tflite` in this directory.
   Optionally place the accompanying `labels.txt` file alongside the model so
   results include the label name.
3. (Optional) Download the ML Kit Text Recognition v2 (on-device) model from
   [Google ML Kit](https://developers.google.com/ml-kit/vision/text-recognition/v2)
   and save it as `text_recognizer.tflite` if you want to enable OCR for
   scanning ingredient lists.
4. Run the server:
   ```bash
   python server.py
   ```
The server listens on port **5000** for image uploads.

When an image is received the server performs one of two actions depending on
the query parameter:

- **Default**: classify the food item using the MobileNetV2 Food Classifier and
  forward the result to both the ESP32-CAM and Blynk.
- **`mode=ocr`**: run the text recognizer on the uploaded image and return the
  detected UTF‑8 text. This can be used after cropping the label region on the
  device.

## Command Line Usage

You can also run the models directly on an image without using the ESP32‑CAM.
After placing the `mobilenet_v2_food_classifier.tflite` and optional
`text_recognizer.tflite` models in this directory run:

```bash
python scan_image.py path/to/image.jpg
```

Pass `--mode ocr` to extract text from the image instead of classifying it:

```bash
python scan_image.py --mode ocr path/to/image.jpg
```

The script prints a small JSON object describing the result.

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
