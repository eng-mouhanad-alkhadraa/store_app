import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:store/models/product_model.dart';

class ProductDetailsPage extends StatelessWidget {
  final ProductModel product;
  const ProductDetailsPage({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              onPressed: () {},
              icon: Icon(
                FontAwesomeIcons.circleInfo,
                color: Colors.white,
              ),
            ),
          )
        ],
        backgroundColor: Colors.blueAccent.shade400,

        title: Center(child: Text('Product details')), // العنوان في المنتصف
      ),
      body: Stack(
        children: [
          ClipPath(
            clipper: BackgroundClipper(),
            child: Container(
              height: 300,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blueAccent.shade400, Colors.white],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    // لجعل الصورة في المنتصف
                    child: Container(
                      width: screenWidth * 2 / 3,
                      child: AspectRatio(
                        aspectRatio: 1,
                        child:
                            Image.network(product.image, fit: BoxFit.contain),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Center(
                    // لجعل العنوان في المنتصف
                    child: Text(
                      product.title,
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    product.description,
                    style: TextStyle(fontSize: 17),
                  ), // الوصف يبدأ من اليسار
                  SizedBox(height: 8),
                  Text(
                    'السعر: \$${product.price}',
                    style: TextStyle(
                        color: Colors.blueAccent.shade400, fontSize: 20),
                  ), // السعر يبدأ من اليسار
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BackgroundClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 100);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 100);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

