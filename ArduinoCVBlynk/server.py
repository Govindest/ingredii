#!/usr/bin/env python3
"""Simple Flask server that receives an image from ESP32-CAM,
performs classification using TensorFlow Lite and updates Blynk."""

from flask import Flask, request, jsonify
import numpy as np
import tensorflow as tf
import cv2
import blynklib

# Blynk credentials
BLYNK_AUTH = 'YOUR_BLYNK_TOKEN'
BLYNK = blynklib.Blynk(BLYNK_AUTH)

# Load TFLite model (MobileNet or custom food classifier)
interpreter = tf.lite.Interpreter(model_path='model.tflite')
interpreter.allocate_tensors()
input_details = interpreter.get_input_details()
output_details = interpreter.get_output_details()

app = Flask(__name__)

@app.route('/upload', methods=['POST'])
def upload():
    img_bytes = request.get_data()
    img_array = np.frombuffer(img_bytes, np.uint8)
    img = cv2.imdecode(img_array, cv2.IMREAD_COLOR)
    # Preprocess for model
    resized = cv2.resize(img, (224, 224))
    input_data = np.expand_dims(resized.astype(np.float32) / 255.0, axis=0)
    interpreter.set_tensor(input_details[0]['index'], input_data)
    interpreter.invoke()
    output_data = interpreter.get_tensor(output_details[0]['index'])
    class_id = int(np.argmax(output_data))
    confidence = float(np.max(output_data))
    result = f"id:{class_id} conf:{confidence:.2f}"
    # Update Blynk with classification result
    BLYNK.virtual_write(0, result)
    return result, 200

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
