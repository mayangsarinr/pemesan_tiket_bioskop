// lib/firebase_options.dart

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform, kIsWeb;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    // Diperbaiki: Sekarang jika dijalankan di Web/Chrome, dia akan mengembalikan data config web
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      default:
        throw UnsupportedError('Platform tidak dikenali.');
    }
  }

  // CONFIG UNTUK WEB
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyA4ZAMtl0DaqWzFzpAl5WemDSv_9BeRT4g',
    appId: '1:409647643043:web:b5033945654c0ab6ed0216',
    messagingSenderId: '409647643043',
    projectId: 'cinema-go-bbf06',
    authDomain: 'cinema-go-bbf06.firebaseapp.com',
    storageBucket: 'cinema-go-bbf06.firebasestorage.app',
    measurementId: 'G-L621F1SN1Q',
  );

  // CONFIG UNTUK ANDROID
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBwKm-3uL-Ih7qU-kPTvDaevVnxL6yV4jw',
    appId: '1:409647643043:android:ecc7e5947dac059fed0216',
    messagingSenderId: '409647643043',
    projectId: 'cinema-go-bbf06',
    storageBucket: 'cinema-go-bbf06.firebasestorage.app',
  );
}
