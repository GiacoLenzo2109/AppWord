import 'package:flutter/material.dart';

class SearchFilterModel extends ChangeNotifier {
  String? get semanticField => _semanticField;
  String? _semanticField;

  void setSemanticField(String? value) {
    _semanticField = value;
  }

  String? get synonym => _synonym;
  String? _synonym;

  void setSynonym(String? value) {
    _synonym = value;
  }

  String? get antonym => _antonym;
  String? _antonym;

  void setAntonym(String? value) {
    _antonym = value;
  }

  bool get search => _search;
  bool _search = false;

  void setSearch(bool value) {
    _search = value;
  }

  void clear() {
    _semanticField = null;
    _synonym = null;
    _antonym = null;
    _search = false;
  }
}
