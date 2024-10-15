//!  home_page فقط بملف ال refactor shared_preferences و curved_navigation_bar بدون

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:store/models/product_model.dart';
import 'package:store/widgets/custom_card.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:store/services/get_all_product_service.dart';
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  static String id = 'HomePage';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<ProductModel>> futureProducts;

  @override
  void initState() {
    super.initState();
    futureProducts = getAllProducts();
  }

  Future<List<ProductModel>> getAllProducts() async {
    final products = await AllProductsService().getAllProducts();
    final prefs = await SharedPreferences.getInstance();
    for (var product in products) {
      final name = prefs.getString('product_${product.id}_name');
      final desc = prefs.getString('product_${product.id}_desc');
      final price = prefs.getString('product_${product.id}_price');
      final image = prefs.getString('product_${product.id}_image');
      if (name != null) product.updateTitle(name);
      if (desc != null) product.updateDescription(desc);
      if (price != null) product.updatePrice(double.parse(price!));
      if (image != null) product.updateImage(image);
    }
    return products;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              FontAwesomeIcons.cartPlus,
              color: Colors.black,
            ),
          )
        ],
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'New Trend',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: FutureBuilder<List<ProductModel>>(
        future: futureProducts,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<ProductModel> products = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.only(top: 100),
              child: GridView.builder(
                itemCount: products.length,
                clipBehavior: Clip.none,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.5,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 100,
                ),
                itemBuilder: (context, index) {
                  return CustomCard(
                    product: products[index],
                    onEditComplete: () {
                      setState(() {
                        futureProducts = getAllProducts();
                      });
                    },
                  );
                },
              ),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
