// Firebase Storage Service
// Handles file uploads (images, videos, documents) to Firebase Cloud Storage

import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

/// StorageService - Manages file uploads and downloads
class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  /// Upload file to Firebase Storage
  /// Returns the download URL on success, null on failure
  Future<String?> uploadFile({
    required File file,
    required String path,
    Function(double)? onProgress,
  }) async {
    try {
      // Create a reference to the file location
      final ref = _storage.ref().child(path);

      // Upload the file
      final uploadTask = ref.putFile(file);

      // Listen to upload progress
      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        double progress = snapshot.bytesTransferred / snapshot.totalBytes;
        onProgress?.call(progress);
        print('Upload progress: ${(progress * 100).toStringAsFixed(2)}%');
      });

      // Wait for upload to complete
      final snapshot = await uploadTask;

      // Get download URL
      final downloadUrl = await snapshot.ref.getDownloadURL();
      print('✅ File uploaded: $downloadUrl');
      return downloadUrl;
    } catch (e) {
      print('❌ Upload error: $e');
      return null;
    }
  }

  /// Upload image with user ID
  Future<String?> uploadUserImage({
    required File imageFile,
    required String userId,
    String folder = 'profile_pictures',
  }) async {
    final fileName = '${userId}_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final path = '$folder/$fileName';
    return uploadFile(file: imageFile, path: path);
  }

  /// Delete file from Firebase Storage
  Future<bool> deleteFile(String path) async {
    try {
      await _storage.ref().child(path).delete();
      print('✅ File deleted: $path');
      return true;
    } catch (e) {
      print('❌ Delete error: $e');
      return false;
    }
  }

  /// Get download URL for a file
  Future<String?> getDownloadUrl(String path) async {
    try {
      final url = await _storage.ref().child(path).getDownloadURL();
      return url;
    } catch (e) {
      print('❌ Error getting download URL: $e');
      return null;
    }
  }

  /// List all files in a directory
  Future<List<String>> listFiles(String path) async {
    try {
      final result = await _storage.ref().child(path).listAll();
      return result.items.map((ref) => ref.fullPath).toList();
    } catch (e) {
      print('❌ Error listing files: $e');
      return [];
    }
  }
}
