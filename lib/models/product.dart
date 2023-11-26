/// Represents a product with information such as name, description, price, and image.
class Product {
  /// The name of the product.
  final String name;

  /// A detailed description of the product.
  final String description;

  /// The price of the product.
  final double price;

  /// The path to the image representing the product.
  final String image;

  Product({
    required this.name,
    required this.description,
    required this.price,
    required this.image,
  });

  /// Factory method to create a mocked instance of the [Product] class.
  ///
  /// This method creates a pre-defined instance of the [Product] class for demo purposes
  /// and returns a mocked instance of the [Product] class.
  factory Product.mocked() => Product(
        name: 'QuantumSync Pro',
        description:
            "QuantumSync Pro revolutionizes data synchronization with quantum entanglement technology. Experience instant and secure connectivity across your devices. Trust in cutting-edge encryption for a harmonized digital world. Upgrade to QuantumSync Pro for a synchronized future.",
        price: 799.99,
        image: 'assets/random_image.jpg',
      );
}
