#!/usr/bin/env python3
"""Simple Flask server used with the ESP32-CAM example.

The server can perform two tasks using TensorFlow Lite models:

1. Classify the food item in the uploaded image using the **MobileNetV2 Food
   Classifier** model.
2. Optionally run on-device text recognition using the ML Kit Text Recognition
   model. This allows scanning the ingredient list or nutrition label when the
   client requests it.

Classification results are forwarded to Blynk on virtual pin ``V0``.
"""

from flask import Flask, request, jsonify
import numpy as np
import cv2
import blynklib
try:
    import tensorflow as tf
except ImportError:  # pragma: no cover - tensorflow not installed during tests
    tf = None

try:
    from tflite_support.task import vision
    from tflite_support.task.text import text_recognizer
    from tflite_support.task.core import BaseOptions
except Exception:  # pragma: no cover - optional dependency
    vision = None
    text_recognizer = None
    BaseOptions = None

# Blynk credentials
BLYNK_AUTH = 'YOUR_BLYNK_TOKEN'
BLYNK = blynklib.Blynk(BLYNK_AUTH)

###############################
# Model loading
###############################

if tf:
    food_interpreter = tf.lite.Interpreter(model_path='mobilenet_v2_food_classifier.tflite')
    food_interpreter.allocate_tensors()
    food_input = food_interpreter.get_input_details()
    food_output = food_interpreter.get_output_details()
else:  # pragma: no cover - tensorflow missing
    food_interpreter = None
    food_input = []
    food_output = []

LABELS = []
try:
    with open('labels.txt') as f:
        LABELS = [l.strip() for l in f if l.strip()]
except FileNotFoundError:  # pragma: no cover
    pass

if text_recognizer and BaseOptions:
    text_options = text_recognizer.TextRecognizerOptions(
        base_options=BaseOptions(model_path='text_recognizer.tflite')
    )
    TEXT_RECOGNIZER = text_recognizer.TextRecognizer.create_from_options(text_options)
else:  # pragma: no cover - optional dependency not installed
    TEXT_RECOGNIZER = None

app = Flask(__name__)


def classify(img: np.ndarray) -> dict:
    """Run the food classification model on the provided BGR image."""
    if not food_interpreter:
        return {"error": "TensorFlow not available"}
    resized = cv2.resize(img, (224, 224))
    input_data = np.expand_dims(resized.astype(np.float32) / 255.0, axis=0)
    food_interpreter.set_tensor(food_input[0]['index'], input_data)
    food_interpreter.invoke()
    output_data = food_interpreter.get_tensor(food_output[0]['index'])[0]
    class_id = int(np.argmax(output_data))
    confidence = float(np.max(output_data))
    label = LABELS[class_id] if class_id < len(LABELS) else str(class_id)
    return {"label": label, "confidence": confidence}


def recognize_text(img: np.ndarray) -> dict:
    """Run OCR on the provided BGR image."""
    if TEXT_RECOGNIZER is None:
        return {"error": "Text recognizer unavailable"}
    rgb = cv2.cvtColor(img, cv2.COLOR_BGR2RGB)
    input_image = vision.TensorImage.create_from_array(rgb)
    result = TEXT_RECOGNIZER.recognize(input_image)
    text = " ".join([block.text for block in result.blocks])
    return {"text": text}


@app.route('/upload', methods=['POST'])
def upload():
    """Handle image upload.

    The client can pass ``mode=ocr`` as a query parameter to run text
    recognition instead of food classification.
    """

    img_bytes = request.get_data()
    img_array = np.frombuffer(img_bytes, np.uint8)
    img = cv2.imdecode(img_array, cv2.IMREAD_COLOR)

    mode = request.args.get('mode', 'classify')
    if mode == 'ocr':
        result = recognize_text(img)
        return jsonify(result)

    result = classify(img)
    if 'label' in result:
        # Update Blynk with classification result
        BLYNK.virtual_write(0, f"{result['label']}: {result['confidence']:.2f}")
    return jsonify(result)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
