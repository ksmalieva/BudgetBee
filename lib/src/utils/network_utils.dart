import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NetworkUtils {
  static Future<bool> checkFirestoreConnection() async {
    try {
      // Try to write a test document
      final testDoc = await FirebaseFirestore.instance
          .collection('_test_connection')
          .doc('test')
          .get();
      return true;
    } catch (e) {
      
      return false;
    }
  }
  
  static Future<void> retryOperation(Function operation, {int maxRetries = 3}) async {
    for (int i = 0; i < maxRetries; i++) {
      try {
        await operation();
        return;
      } catch (e) {
        
        if (i == maxRetries - 1) rethrow;
        await Future.delayed(Duration(seconds: i + 1));
      }
    }
  }
}