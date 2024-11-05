import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:news1_app/models/ekonomi_news_model.dart';

class NewsEkonomiProvider with ChangeNotifier {
  List<EkonomiNewsModel> _ekonomiList = [];
  bool _isloading = false;

  List<EkonomiNewsModel> get ekonomiList => _ekonomiList;
  bool get isLoading => _isloading;

  Future<void> fetchEkonomihNews() async {
    _isloading = true;
    notifyListeners();

    final url =
        Uri.parse('https://api-berita-indonesia.vercel.app/cnn/ekonomi/');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['data'];
        _ekonomiList = [EkonomiNewsModel.fromJson(data)];
      }
    } catch (error) {
      rethrow;
    }
    _isloading = false;
    notifyListeners();
  }
}
