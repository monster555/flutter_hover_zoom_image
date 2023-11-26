import 'package:flutter/material.dart';
import 'package:flutter_hover_zoom_image/models/product.dart';
import 'package:flutter_hover_zoom_image/ui/product_details.dart';
import 'package:google_fonts/google_fonts.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Hover To Zoom Image Demo',

      /// Configures the theme, using the Poppins font and a custom color scheme.
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme,
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),

      /// Sets the home screen to display the product details with mock data.
      home: Scaffold(
        body: ProductDetails(Product.mocked()),
      ),
    );
  }
}
