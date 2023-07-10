import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/photo_model.dart';


class WallpaperRepository {
  static final _apiKey =
      'nKc6gYYQCfM3fvS9yCCEfl3kNEPjmAaX3hWmjOm2zdqRMYthlGThTHe3';
  static final _baseUrl = 'https://api.pexels.com/v1';

  Future<List<Photos>> getWallpapers() async {
    List<Photos> wallpapers = [];
    final response = await http.get(
      Uri.parse('$_baseUrl/curated?per_page=40'),
      headers: {
        'Authorization': _apiKey,
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      List photos = data['photos'];
      for (int i = 0; i < photos.length; i++) {
        wallpapers.add(Photos.fromJson(photos[i]));
      }
      return wallpapers;
    } else {
      throw Exception('Failed to load wallpapers');
    }
  }

  Future<List<Photos>> searchWallpapers(String query) async {
    List<Photos> wallpapers = [];
    final response = await http.get(
      Uri.parse('$_baseUrl/search?query=$query&per_page=40'),
      headers: {
        'Authorization': _apiKey,
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      List photos = data['photos'];
      for (int i = 0; i < photos.length; i++) {
        wallpapers.add(Photos.fromJson(photos[i]));
      }
      return wallpapers;
    } else {
      throw Exception('Failed to load wallpapers');
    }
  }

  // Future<String> downloadImage(String imageUrl) async {
  //   final response = await http.get(Uri.parse(imageUrl));

  //   if (response.statusCode == 200) {
  //     final directory = await getApplicationDocumentsDirectory();
  //     final fileName = basename(imageUrl);
  //     final filePath = '${directory.path}/$fileName';

  //     final file = File(filePath);
  //     await file.writeAsBytes(response.bodyBytes);

  //     return filePath;
  //   } else {
  //     throw Exception('Failed to download image');
  //   }
  // }
}
