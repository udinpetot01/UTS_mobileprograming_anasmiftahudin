import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:news1_app/models/nasional_news_model.dart';

class NasionalNewsProvider with ChangeNotifier {
  List<NasionalNewsModel> _nasionalList = [];
  bool _isloading = false;

  List<NasionalNewsModel> get nasionalList => _nasionalList;
  bool get isLoading => _isloading;

  Future<void> fetchNasionalNews() async {
    _isloading = true;
    notifyListeners();

    final url =
        Uri.parse('https://api-berita-indonesia.vercel.app/cnn/nasional/');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['data'];
        _nasionalList = [NasionalNewsModel.fromJson(data)];
      }
    } catch (error) {
      rethrow;
    }
    _isloading = false;
    notifyListeners();
  }
}
