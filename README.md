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

This repository does not include a fully configured Xcode project. The
`Ingredii.xcodeproj` file is only a placeholder, which is why Xcode reports the
project as being in an unsupported format. To build the app you will need to
create a new Xcode project and add the existing source files manually:

1. Open Xcode and create a new **iOS App** using the *SwiftUI* template.
2. Set *Ingredii* as the product name and remove the files Xcode generates in
   the new project.
3. Copy the contents of `Ingredii/Ingredii/` (Swift files, assets, storyboard
   and `Info.plist`) into the new project.
4. Build and run the app using the `Ingredii` target.

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

