import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http_parser/http_parser.dart';

Future<String?> uploadToCloudinary(String childName, Uint8List file, bool isPost) async {

  String cloudName = dotenv.env["CLOUDINARY_CLOUD_NAME"] ?? "";

  var uri = Uri.parse("https://api.cloudinary.com/v1_1/$cloudName/image/upload");
  var request = http.MultipartRequest("POST", uri);

  var multipleFile = http.MultipartFile.fromBytes(
    "file",
    file,
    filename: DateTime.now().millisecondsSinceEpoch.toString(),
    contentType: MediaType("application", "octet-stream"),
  );



  request.files.add(multipleFile);

  request.fields["upload_preset"] = "instagram-preset-file";
  request.fields["folder"] = "instagram-clone/$childName";

  var response = await request.send();

  var responseBody = await response.stream.bytesToString();

  print(responseBody);

  var jsonResponse = jsonDecode(responseBody);

  if(response.statusCode == 200) {
    print("Upload successful!");
    return jsonResponse["secure_url"];
  } else {
    print("Upload failed with status: ${response.statusCode}");
    return null;
  }
}