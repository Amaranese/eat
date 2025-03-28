import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CloudinaryService {
  final String cloudName =
      "drb35fnzy"; // Replace with your Cloudinary cloud name
  final String uploadPreset =
      "profile_preset"; // Replace with your upload preset

  /// Upload Image to Cloudinary
  Future<String?> uploadImageToCloudinary(File file) async {
    final url =
        Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/upload');
    try {
      final request = http.MultipartRequest('POST', url);
      request.fields['upload_preset'] = uploadPreset;

      // Attach the image file
      request.files.add(
        await http.MultipartFile.fromPath('file', file.path),
      );

      final response = await request.send();
      if (response.statusCode == 200) {
        final responseData = jsonDecode(await response.stream.bytesToString());
        return responseData['secure_url'];
      } else {
        final errorResponse = jsonDecode(await response.stream.bytesToString());
        print("Failed to upload: ${errorResponse['error']['message']}");
        return null;
      }
    } catch (e) {
      print("Error uploading image to Cloudinary: $e");
      return null;
    }
  }
}
