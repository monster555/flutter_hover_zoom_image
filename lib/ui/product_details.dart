import 'package:flutter/material.dart';
import 'package:flutter_hover_zoom_image/models/product.dart';
import 'package:flutter_hover_zoom_image/ui/hover_to_zoom.dart';

part 'product_details_widgets.dart';

/// A widget that displays the details of a product.
///
/// This widget displays a row with a [HoverToZoom] widget and a column of product details.
/// The [HoverToZoom] widget displays the product image that can be zoomed in on hover.
/// The column of product details displays the product name, price, and description.
///
/// The [product] parameter is the [Product] to display the details of.
class ProductDetails extends StatelessWidget {
  const ProductDetails(this.product, {super.key});

  /// The product to display the details of.
  final Product product;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // The product image that can be zoomed in on hover
        HoverToZoom(imagePath: product.image),
        const SizedBox(width: 16),
        Flexible(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // The product name
                Text(
                  product.name,
                  style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 16),
                // The product price
                Text(
                  '\$${product.price}',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                // The product description
                Text(
                  product.description,
                ),
                // The widget to add or remove the product from the cart
                const _AddRemoveWidgetWithAddToCart(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
