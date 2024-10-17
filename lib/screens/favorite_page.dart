import 'package:flutter/material.dart';
import 'package:store/models/product_model.dart';
import 'package:store/widgets/custom_card.dart';
import 'package:store/widgets/shared_preferences.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({Key? key, required this.products}) : super(key: key);
  final List<ProductModel> products;

  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  List<ProductModel> favoriteProducts = [];

  @override
  void initState() {
    super.initState();
    loadFavoriteProducts();
  }

  void loadFavoriteProducts() async {
    final allProducts = widget.products;
    final updatedProducts = <ProductModel>[];

    for (var product in allProducts) {
      await SharedPreferencesHelper.loadProductFromPreferences(product);
      if (await SharedPreferencesHelper.getFavoriteStatus(
          product.id.toString())) {
        if (!updatedProducts.any((p) => p.id == product.id)) {
          updatedProducts.add(product);
        }
      }
    }

    setState(() {
      favoriteProducts = updatedProducts;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Favorite Page')),
      body: Padding(
        padding: const EdgeInsets.only(top: 100),
        child: GridView.builder(
          itemCount: favoriteProducts.length,
          clipBehavior: Clip.none,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.5,
            crossAxisSpacing: 10,
            mainAxisSpacing: 100,
          ),
          itemBuilder: (context, index) {
            final product = favoriteProducts[index];
            return CustomCard(
              product: product,
              onEditComplete: () async {
                await SharedPreferencesHelper.updateProductInPreferences(
                    product);
                loadFavoriteProducts(); // إعادة تحميل المنتجات المفضلة بعد التحديث
              },
              onFavoriteUpdated: loadFavoriteProducts,
            );
          },
        ),
      ),
    );
  }
}
