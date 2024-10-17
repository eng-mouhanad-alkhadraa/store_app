import 'package:flutter/material.dart';
import 'package:store/models/product_model.dart';
import 'package:store/widgets/custom_card.dart';

class ProductGrid extends StatefulWidget {
  final Future<List<ProductModel>> futureProducts;
  final VoidCallback onEditComplete;
  final VoidCallback onFavoriteUpdated; // إضافة المعامل

  ProductGrid({
    required this.futureProducts,
    required this.onEditComplete,
    required this.onFavoriteUpdated, // إضافة المعامل
  });

  @override
  _ProductGridState createState() => _ProductGridState();
}

class _ProductGridState extends State<ProductGrid> {
  late Future<List<ProductModel>> futureProducts;

  @override
  void initState() {
    super.initState();
    futureProducts = widget.futureProducts;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ProductModel>>(
      future: futureProducts,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<ProductModel> products = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.only(
              top: 100,
            ),
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
                      futureProducts = widget.futureProducts;
                    });
                    widget.onEditComplete();
                  },
                  onFavoriteUpdated: widget.onFavoriteUpdated, // تمرير المعامل
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
    );
  }
}


