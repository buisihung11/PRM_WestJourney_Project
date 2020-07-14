import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class FirebaseRepository {
  final FirebaseStorage _storage =
      FirebaseStorage(storageBucket: 'gs://prm-journey-west.appspot.com/');
  static final String rootImagePath = 'images';
  static final String rootFilePath = 'files';

  static String getFileName(String path) {
    return path?.split("/")?.last;
  }

  Future<String> uploadFile({File uploadFile, bool isImage = true}) async {
    try {
      String fileName = getFileName(uploadFile.path);
      print("Upload file $fileName");
      String filePath =
          "${isImage ? rootImagePath : rootFilePath}/${DateTime.now()}_$fileName";
      final uploadTask = _storage.ref().child(filePath).putFile(uploadFile);

      final snapshot = await uploadTask.onComplete;
      final downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print("!!!!!Upload fail: $e");
      return null;
    }
  }
}
