class StorageService {
  List<Map<String, dynamic>> _expenses = [];
  List<Map<String, dynamic>> _categories = [];

  Future<void> saveExpenses(List<Map<String, dynamic>> expenses) async {
    _expenses = expenses;
  }

  Future<List<Map<String, dynamic>>> loadExpenses() async {
    return _expenses;
  }

  Future<void> saveCategories(List<Map<String, dynamic>> categories) async {
    _categories = categories;
  }

  Future<List<Map<String, dynamic>>> loadCategories() async {
    return _categories;
  }

  Future<void> clearAll() async {
    _expenses = [];
    _categories = [];
  }
}
