import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:firebase_chatapp/config/app_config.dart';

class UploadService {
  static Future<List<String?>> uploadImages(List<File> listImageFiles) async {
    final String cloudName = EnvConfig.cloudName;
    final String apiKey = EnvConfig.cloudinaryApiKey;
    final String apiSecret = EnvConfig.cloudinaryApiSecret; // Thêm api_secret

    final url =
        Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/upload');

    int timestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    String stringToSign = "timestamp=$timestamp&upload_preset=firebase_chatapp";
    String signature =
        sha1.convert(utf8.encode(stringToSign + apiSecret)).toString();

    List<String?> uploadedUrls = [];

    for (File imageFile in listImageFiles) {
      try {
        var request = http.MultipartRequest('POST', url)
          ..fields['timestamp'] = timestamp.toString()
          ..fields['api_key'] = apiKey
          ..fields['signature'] = signature
          ..fields['upload_preset'] = 'firebase_chatapp'
          ..files.add(await http.MultipartFile.fromPath(
            'file',
            imageFile.path,
            contentType:
                MediaType.parse(lookupMimeType(imageFile.path) ?? 'image/jpeg'),
          ));

        var response = await request.send();

        if (response.statusCode == 200) {
          var responseData = await response.stream.bytesToString();
          var jsonMap = jsonDecode(responseData);
          uploadedUrls.add(jsonMap['secure_url']);
        } else {
          var errorData = await response.stream.bytesToString();
          print("Upload failed: $errorData");
          uploadedUrls.add(null);
        }
      } catch (e) {
        print("Error uploading image: $e");
        uploadedUrls.add(null);
      }
    }

    return uploadedUrls;
  }
}
