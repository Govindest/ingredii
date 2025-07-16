#!/usr/bin/env python3
"""Run food classification or label OCR on a local image using TFLite models.

This utility loads the MobileNetV2 Food Classifier and optional ML Kit Text
Recognizer models to process an image file. The default model filenames match
those expected by ``server.py``.
"""

import argparse
from pathlib import Path
import numpy as np
import cv2

try:
    import tensorflow as tf
except ImportError:
    tf = None

try:
    from tflite_support.task import vision
    from tflite_support.task.text import text_recognizer
    from tflite_support.task.core import BaseOptions
except Exception:
    vision = None
    text_recognizer = None
    BaseOptions = None


class VisionModels:
    """Wrapper for loading TFLite models."""

    def __init__(self, food_model: Path, labels_file: Path,
                 ocr_model: Path | None):
        if tf:
            self.food_interpreter = tf.lite.Interpreter(model_path=str(food_model))
            self.food_interpreter.allocate_tensors()
            self.food_input = self.food_interpreter.get_input_details()
            self.food_output = self.food_interpreter.get_output_details()
        else:
            self.food_interpreter = None
            self.food_input = []
            self.food_output = []

        self.labels: list[str] = []
        if labels_file.exists():
            self.labels = [l.strip() for l in labels_file.read_text().splitlines() if l.strip()]

        if text_recognizer and BaseOptions and ocr_model and ocr_model.exists():
            options = text_recognizer.TextRecognizerOptions(
                base_options=BaseOptions(model_path=str(ocr_model))
            )
            self.text_recognizer = text_recognizer.TextRecognizer.create_from_options(options)
        else:
            self.text_recognizer = None

    def classify(self, img: np.ndarray) -> dict:
        if not self.food_interpreter:
            raise RuntimeError("TensorFlow not available")
        resized = cv2.resize(img, (224, 224))
        input_data = np.expand_dims(resized.astype(np.float32) / 255.0, axis=0)
        self.food_interpreter.set_tensor(self.food_input[0]['index'], input_data)
        self.food_interpreter.invoke()
        output_data = self.food_interpreter.get_tensor(self.food_output[0]['index'])[0]
        class_id = int(np.argmax(output_data))
        confidence = float(np.max(output_data))
        label = self.labels[class_id] if class_id < len(self.labels) else str(class_id)
        return {"label": label, "confidence": confidence}

    def recognize_text(self, img: np.ndarray) -> dict:
        if self.text_recognizer is None:
            raise RuntimeError("Text recognizer unavailable")
        rgb = cv2.cvtColor(img, cv2.COLOR_BGR2RGB)
        timg = vision.TensorImage.create_from_array(rgb)
        result = self.text_recognizer.recognize(timg)
        text = " ".join(block.text for block in result.blocks)
        return {"text": text}


def main() -> None:
    parser = argparse.ArgumentParser(description="Classify food images or run OCR")
    parser.add_argument("image", type=Path, help="Path to the image file")
    parser.add_argument("--mode", choices=["classify", "ocr"], default="classify",
                        help="Operation to perform")
    parser.add_argument("--food_model", type=Path, default=Path("mobilenet_v2_food_classifier.tflite"),
                        help="Path to MobileNetV2 Food Classifier model")
    parser.add_argument("--labels", type=Path, default=Path("labels.txt"),
                        help="Path to labels file")
    parser.add_argument("--ocr_model", type=Path, default=Path("text_recognizer.tflite"),
                        help="Path to ML Kit Text Recognizer model")
    args = parser.parse_args()

    if not args.image.exists():
        parser.error(f"Image not found: {args.image}")

    models = VisionModels(args.food_model, args.labels, args.ocr_model)

    img = cv2.imread(str(args.image))
    if img is None:
        parser.error("Failed to load image")

    if args.mode == "ocr":
        result = models.recognize_text(img)
    else:
        result = models.classify(img)

    print(result)


if __name__ == "__main__":
    main()
