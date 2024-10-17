// //!refactor shared_preferences   

import 'package:flutter/material.dart';
import 'package:store/models/product_model.dart';
import 'package:store/screens/update_product_page.dart';
import 'package:store/widgets/custom_icon.dart';
import 'package:store/widgets/shared_preferences.dart';


class CustomCard extends StatefulWidget {
  CustomCard({
    required this.product,
    required this.onEditComplete,
    required this.onFavoriteUpdated,
    Key? key,
  }) : super(key: key);

  final ProductModel product;
  final VoidCallback onEditComplete;
  final VoidCallback onFavoriteUpdated;

  @override
  _CustomCardState createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard> {
  bool isFavorite = false;
  bool showFullTitle = false;
  bool showFullDescription = false;

  @override
  void initState() {
    super.initState();
    loadFavoriteStatus();
  }

  void loadFavoriteStatus() async {
    isFavorite = await SharedPreferencesHelper.getFavoriteStatus(widget.product.id.toString());
    setState(() {});
  }

  void toggleFavoriteStatus() async {
    isFavorite = !isFavorite;
    await SharedPreferencesHelper.setFavoriteStatus(widget.product.id.toString(), isFavorite);
    widget.onFavoriteUpdated();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        SizedBox(height: 20),
        Container(
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
              blurRadius: 50,
              color: Colors.grey.withOpacity(.1),
              spreadRadius: 20,
              offset: Offset(10, 10),
            ),
          ]),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 10,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          showFullTitle = !showFullTitle;
                        });
                      },
                      child: Text(
                        showFullTitle
                            ? widget.product.title
                            : widget.product.title.length > 6
                                ? widget.product.title.substring(0, 6) + '...'
                                : widget.product.title,
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    SizedBox(height: 3),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          showFullDescription = !showFullDescription;
                        });
                      },
                      child: Text(
                        showFullDescription
                            ? widget.product.description
                            : widget.product.description.length > 20
                                ? widget.product.description.substring(0, 20) + '...'
                                : widget.product.description,
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    SizedBox(height: 3),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  content: Text(r'$' + widget.product.price.toString()),
                                ),
                              );
                            },
                            child: Text(
                              widget.product.price.toString().length > 6
                                  ? r'$' + widget.product.price.toString().substring(0, 6) + '...'
                                  : r'$' + widget.product.price.toString(),
                              style: TextStyle(
                                fontSize: 16,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            CustomIcon(
                              color: Colors.red,
                              icon: isFavorite ? Icons.favorite : Icons.favorite_border,
                              onPressed: toggleFavoriteStatus,
                            ),
                            SizedBox(width: 8),
                            CustomIcon(
                              color: Colors.blue,
                              icon: Icons.edit,
                              onPressed: () async {
                                var result = await Navigator.pushNamed(
                                  context,
                                  UpdateProductPage.id,
                                  arguments: widget.product,
                                );
                                if (result == 'updated') {
                                  widget.onEditComplete();
                                }
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Positioned(
          right: 32,
          top: -85,
          child: Image.network(
            widget.product.image,
            height: 100,
            width: 100,
          ),
        ),
      ],
    );
  }
}
