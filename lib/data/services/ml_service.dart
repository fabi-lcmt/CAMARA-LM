import 'dart:io';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

class MLResult {
  final String label;
  final double confidence;

  MLResult(this.label, this.confidence);

  @override
  String toString() => '$label (${(confidence * 100).toStringAsFixed(1)}%)';
}

class MLService {
  Interpreter? _interpreter;
  List<String>? _labels;

  static const String _modelPath = 'assets/models/mobilenet_v1_1.0_224.tflite';
  static const String _labelsPath = 'assets/models/labels.txt';

  Future<void> initialize() async {
    try {
      _interpreter = await Interpreter.fromAsset(_modelPath);
      final labelsData = await rootBundle.loadString(_labelsPath);
      _labels = labelsData.split('\n');
      print('ML Service initialized successfully');
    } catch (e) {
      print('Error initializing ML Service: $e');
    }
  }

  Future<MLResult> predict(String imagePath) async {
    if (_interpreter == null || _labels == null) {
      return MLResult("Model not initialized", 0.0);
    }

    final imageFile = File(imagePath);
    final imageBytes = await imageFile.readAsBytes();
    img.Image? originalImage = img.decodeImage(imageBytes);

    if (originalImage == null) return MLResult("Error decoding image", 0.0);

    // Resize the image to 224x224 as required by MobileNet
    img.Image resizedImage = img.copyResize(originalImage, width: 224, height: 224);

    // Prepare input (224 * 224 * 3)
    var input = _imageToByteListUint8(resizedImage, 224);

    // Prepare output (1 * 1001) for MobileNet V1
    var output = List<int>.filled(1 * 1001, 0).reshape([1, 1001]);

    // Run inference
    _interpreter!.run(input, output);

    // Find the label with the highest probability
    int maxIndex = 0;
    int maxValue = -1;
    for (int i = 0; i < output[0].length; i++) {
      if (output[0][i] > maxValue) {
        maxValue = output[0][i];
        maxIndex = i;
      }
    }

    // Since it's a quantized model, the maxValue is between 0 and 255
    double confidence = maxValue / 255.0;

    if (maxIndex < _labels!.length) {
      return MLResult(_labels![maxIndex], confidence);
    } else {
      return MLResult("Unknown", confidence);
    }
  }

  Uint8List _imageToByteListUint8(img.Image image, int inputSize) {
    var convertedBytes = Uint8List(inputSize * inputSize * 3);
    int pixelIndex = 0;
    for (int i = 0; i < inputSize; i++) {
      for (int j = 0; j < inputSize; j++) {
        var pixel = image.getPixel(j, i);
        convertedBytes[pixelIndex++] = pixel.r.toInt();
        convertedBytes[pixelIndex++] = pixel.g.toInt();
        convertedBytes[pixelIndex++] = pixel.b.toInt();
      }
    }
    return convertedBytes;
  }

  void dispose() {
    _interpreter?.close();
  }
}
