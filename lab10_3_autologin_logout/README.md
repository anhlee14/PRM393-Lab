# Lab 10.3 - Auto Login & Logout

1. Open terminal inside project directory:
   `flutter pub get`
2. Run on emulator or device:
   `flutter run`

## Features
- Save token to SharedPreferences upon login
- SplashScreen checks session on startup
- Auto-login to Dashboard if token exists
- Logout clears SharedPreferences and redirects to Login screen

## Test Account (DummyJSON)
- Username: `emilys`
- Password: `emilyspass`