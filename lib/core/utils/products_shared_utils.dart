import 'package:shared_preferences/shared_preferences.dart';

class ProductsSharedUtilService {

  static SharedPreferences? _prefs;
  static Future initSharedPreferences() async => _prefs = await SharedPreferences.getInstance();

  // Future<void> initSharedPreferences() async {
  //   _prefs = await SharedPreferences.getInstance();
  // }

  Future<int> getLastInteractedCardId() async {
    return _prefs!.getInt('lastInteractedProductId') ?? -1;
  }

  List<String> getPendingProducts() {
    return _prefs!.getStringList('pendingProducts') ?? <String>[];
  }

  Future<void> addPendingProduct({
    required int productId,
    required String applicantName,
  }) async {
    List<String> pendingProducts = getPendingProducts();

    final entry = '$productId|$applicantName';

    // Check if the entry already exists in the list
    if (pendingProducts.contains(entry)) {
      // Remove it from its current position
      pendingProducts.remove(entry);
    }

    pendingProducts.insert(0, entry);

    _prefs!.setStringList('pendingProducts', pendingProducts);
  }

  List<Map<String, dynamic>> getLastInteractedProducts() {
    List<String> pendingProducts = getPendingProducts();

    List<Map<String, dynamic>> lastInteractedProducts = [];

    for (String entry in pendingProducts) {
      List<String> parts = entry.split('|');
      if (parts.length == 2) {
        lastInteractedProducts.add({
          'productId': int.tryParse(parts[0]) ?? 0,
          'applicantName': parts[1],
        });
      }
    }

    return lastInteractedProducts;
  }

}