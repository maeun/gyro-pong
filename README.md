# Gyro Pong

Minimal Gyro-controlled Pong game built with Flutter.

Quick start

1. Install Flutter and Android SDK on your machine.
2. From project root run:

```powershell
flutter pub get
flutter run -d <your-android-device-id>
```

Notes

- This project uses `sensors_plus` for gyroscope events and `google_mobile_ads` for AdMob. Ad unit IDs in the code are AdMob test IDs. Replace with your own when publishing.
- High score is stored locally using `shared_preferences`.
- If you don't have Flutter set up, see https://flutter.dev/docs/get-started/install
