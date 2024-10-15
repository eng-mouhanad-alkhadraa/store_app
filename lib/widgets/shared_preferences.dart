//! الاساسي
import 'package:shared_preferences/shared_preferences.dart';
import 'package:store/models/product_model.dart';

class SharedPreferencesHelper {
  static Future<void> setFavoriteStatus(String productId, bool isFavorite) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('product_${productId}_favorite', isFavorite);
  }

  static Future<bool> getFavoriteStatus(String productId) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('product_${productId}_favorite') ?? false;
  }

  static Future<void> saveProductToPreferences(ProductModel product) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('product_${product.id}_name', product.title);
    await prefs.setString('product_${product.id}_desc', product.description);
    await prefs.setString('product_${product.id}_price', product.price.toString()); // تأكد من تحويل السعر إلى نص
    await prefs.setString('product_${product.id}_image', product.image);
  }

  static Future<void> loadProductFromPreferences(ProductModel product) async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('product_${product.id}_name');
    final desc = prefs.getString('product_${product.id}_desc');
    final price = prefs.getString('product_${product.id}_price');
    final image = prefs.getString('product_${product.id}_image');

    if (name != null) product.updateTitle(name);
    if (desc != null) product.updateDescription(desc);
    if (price != null) product.updatePrice(double.parse(price!)); // تحويل السعر من نص إلى رقم
    if (image != null) product.updateImage(image);
  }
}




