import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:news1_app/models/tech_news_model.dart';

class TechNewsProvider with ChangeNotifier {
  List<TechnoNewsModel> _techList = [];
  bool _isloading = false;

  List<TechnoNewsModel> get techList => _techList;
  bool get isLoading => _isloading;

  Future<void> fetchTechNews() async {
    _isloading = true;
    notifyListeners();

    final url =
        Uri.parse('https://api-berita-indonesia.vercel.app/antara/tekno/');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['data'];
        _techList = [TechnoNewsModel.fromJson(data)];
      }
    } catch (error) {
      rethrow;
    }
    _isloading = false;
    notifyListeners();
  }
}
