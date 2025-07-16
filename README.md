# Ingredii

Simple pantry inventory management example built with SwiftUI.

This repository also contains an optional computer vision example that uses an
ESP32-CAM and TensorFlow Lite models to automatically identify pantry items or
scan text from a product label.

## Features

- Display a list of pantry items
- View item details
- Add and delete items
- Add items with optional expiry dates
- Data is persisted using `UserDefaults`
- Sample inventory is loaded on first launch using bundled JSON

## Running

Open `Ingredii/Ingredii.xcodeproj` in Xcode to build the sample app. The
project is intentionally minimal and does not specify a signing team. Select
your own development team under **Signing & Capabilities** before running. If
you add the optional text recognition pod, run `pod install` in the `Ingredii`
directory and then open `Ingredii.xcworkspace` instead of the project file.

## Tests

Unit tests reside in the `IngrediiTests` group. Run them from Xcode via the `Product` → `Test` menu.

## Computer Vision Example

The `ArduinoCVBlynk` directory contains a companion project demonstrating how
to capture images from an ESP32‑CAM and classify them on-device. It uses two
TensorFlow Lite models:

1. **MobileNetV2 Food Classifier** – download from
   [Pramit726/MobileNetV2-FoodClassifier](https://github.com/Pramit726/MobileNetV2-FoodClassifier).
2. **ML Kit Text Recognition v2** – from
   [Google ML Kit](https://developers.google.com/ml-kit/vision/text-recognition/v2),
   invoked when the server is run with `mode=ocr`.

See `ArduinoCVBlynk/README.md` for setup instructions.

## Text Recognition on iOS

The app can also extract text from images using ML Kit. Add the
`GoogleMLKit/TextRecognition` pod to the `Podfile` and run `pod install`:

```ruby
pod 'GoogleMLKit/TextRecognition', '8.0.0'
```

After installing the pod open the `.xcworkspace` and use
`TextRecognitionService` to process a `UIImage` or camera frame:

```swift
let service = TextRecognitionService()
service.recognizeText(in: image) { result in
    // handle recognized text
}
```

This service wraps ML Kit's `TextRecognizer` as described in the official
documentation.

