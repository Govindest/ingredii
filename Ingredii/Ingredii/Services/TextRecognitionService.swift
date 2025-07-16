import UIKit
import MLKitTextRecognition
import MLKitVision

/// Service wrapper around ML Kit's TextRecognizer.
///
/// Initialize and call `recognizeText` with a `UIImage` or camera frame to
/// obtain detected text.
final class TextRecognitionService {
    private let recognizer: TextRecognizer

    /// Initialize a text recognizer for Latin script.
    init() {
        let options = TextRecognizerOptions()
        self.recognizer = TextRecognizer.textRecognizer(options: options)
    }

    /// Recognize text in a `UIImage`.
    func recognizeText(in image: UIImage, completion: @escaping (Result<String, Error>) -> Void) {
        let visionImage = VisionImage(image: image)
        visionImage.orientation = image.imageOrientation
        recognizer.process(visionImage) { result, error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(result?.text ?? ""))
            }
        }
    }

    /// Recognize text in a camera frame.
    func recognizeText(in buffer: CMSampleBuffer, cameraPosition: AVCaptureDevice.Position, completion: @escaping (Result<String, Error>) -> Void) {
        let orientation = imageOrientation(deviceOrientation: UIDevice.current.orientation, cameraPosition: cameraPosition)
        let visionImage = VisionImage(buffer: buffer)
        visionImage.orientation = orientation
        recognizer.process(visionImage) { result, error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(result?.text ?? ""))
            }
        }
    }

    /// Helper to translate device orientation for CMSampleBuffer images.
    private func imageOrientation(deviceOrientation: UIDeviceOrientation, cameraPosition: AVCaptureDevice.Position) -> UIImage.Orientation {
        switch deviceOrientation {
        case .portrait:
            return cameraPosition == .front ? .leftMirrored : .right
        case .landscapeLeft:
            return cameraPosition == .front ? .downMirrored : .up
        case .portraitUpsideDown:
            return cameraPosition == .front ? .rightMirrored : .left
        case .landscapeRight:
            return cameraPosition == .front ? .upMirrored : .down
        case .faceDown, .faceUp, .unknown:
            return .up
        @unknown default:
            return .up
        }
    }
}
