# Camara ML - Clasificador de Imágenes en Flutter

Camara ML es una aplicación hecha con Flutter que utiliza **TensorFlow Lite (TFLite)** para realizar la clasificación de imágenes en tiempo real utilizando la cámara del dispositivo.

## Características

- **Vista Previa de Cámara en Tiempo Real**: Integración fluida con la cámara del dispositivo.
- **Inferencia de ML en el Dispositivo**: Utiliza un modelo MobileNet V1.
- **Puntuación de Confianza**: Representación visual de la precisión de la predicción con barras de progreso codificadas por colores.

## Stack Tecnológico

- **Framework**: [Flutter](https://flutter.dev/)
- **Machine Learning**: [tflite_flutter ^0.11.0](https://pub.dev/packages/tflite_flutter)
- **Manejo de Cámara**: [camera ^0.11.0+1](https://pub.dev/packages/camera)
- **Procesamiento de Imágenes**: [image ^4.0.17](https://pub.dev/packages/image)
- **Utilidades**: `path_provider`, `path`

## 🏗 Arquitectura del Proyecto

El proyecto sigue una arquitectura limpia y por capas para facilitar el mantenimiento:

```text
lib/
├── core/             # Utilidades estándar y constantes
├── data/
│   └── services/     # MLService para carga de modelos e inferencia
├── presentation/
│   └── pages/        # CameraPage y componentes de UI
└── main.dart         # Punto de entrada e inicialización de la cámara
```

## Comenzando

### Prerrequisitos

- Flutter SDK (probado en la versión 3.38.7 o superior)
- Dart SDK (versión 3.10.7 o superior)
- Un dispositivo físico (Android o iOS) – *Las funciones de cámara pueden no funcionar completamente en emuladores.*

### Instalación

1.  **Clonar el repositorio**:
    ```bash
    git clone [url-del-repositorio]
    cd camara_ml
    ```

2.  **Instalar dependencias**:
    ```bash
    flutter pub get
    ```

3.  **Asegurar que los assets estén presentes**:
    Verifica que existan `assets/models/mobilenet_v1_1.0_224.tflite` y `assets/models/labels.txt`.

4.  **Ejecutar la aplicación**:
    ```bash
    flutter run
    ```

## ⚙️ Configuración

### Android
Los permisos ya están configurados en `android/app/src/main/AndroidManifest.xml`:
- `android.permission.CAMERA`
- `android.permission.WRITE_EXTERNAL_STORAGE`
- `android.permission.READ_EXTERNAL_STORAGE`

### iOS
Los permisos están configurados en `ios/Runner/Info.plist`:
- `NSCameraUsageDescription`: Requerido para capturar imágenes y clasificarlas.
- `NSMicrophoneUsageDescription`: Requerido para el soporte completo del plugin de cámara.
