// //!   curved_navigation_bar مع اضافة ال  refactor shared_preferences  هام
// //! يتم  حفظ و عرض تغييرات تحديث بيانات المنتج بالصفحة الرئيسية و صفحة تفاصيل المنتج مباشرة بشكل سليم
// //!refactor shared_preferences  


import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:store/models/product_model.dart';
import 'package:store/screens/product_details_page.dart';
import 'package:store/services/get_all_product_service.dart';
import 'package:store/widgets/custom_card.dart';
import 'package:store/widgets/custom_icon.dart';
import 'package:store/widgets/shared_preferences.dart';

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
    for (var product in products) {
      await SharedPreferencesHelper.loadProductFromPreferences(product);
    }
    return products;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.white,
        color: Colors.blueAccent.shade400,
        animationDuration: Duration(milliseconds: 300),
        onTap: (index) {
          print('object');
        },
        items: [
          CustomIcon(icon: Icons.home, color: Colors.white),
          CustomIcon(icon: Icons.favorite, color: Colors.white),
        ],
      ),
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              onPressed: () {},
              icon: Icon(
                FontAwesomeIcons.cartPlus,
                color: Colors.white,
              ),
            ),
          )
        ],
        backgroundColor: Colors.blueAccent.shade400,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Store App',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: FutureBuilder<List<ProductModel>>(
        future: futureProducts,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<ProductModel> products = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.only(top: 100, bottom: 50),
              child: GridView.builder(
                itemCount: products.length,
                clipBehavior: Clip.none,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.5,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 100,
                ),

                // هو الذي  عندما نضغط  على المنتج يعرض صفحة التفاصيلitemBuilder
              itemBuilder: (context, index) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProductDetailsPage(product: products[index]),
        ),
      );
    },
    child: CustomCard(
      product: products[index],
      onEditComplete: () {
        setState(() {
          futureProducts = getAllProducts();
        });
      },
    ),
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

