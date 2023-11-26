part of 'product_details.dart';

/// A widget that allows the user to add or remove items from the cart.
///
/// This widget displays a row with a decrement button, the current quantity, and an increment button.
/// The user can click the decrement button to decrease the quantity by 1, down to a minimum of 1.
/// The user can click the increment button to increase the quantity by 1.
class _AddRemoveWidgetWithAddToCart extends StatefulWidget {
  const _AddRemoveWidgetWithAddToCart();

  @override
  State<_AddRemoveWidgetWithAddToCart> createState() =>
      _AddRemoveWidgetWithAddToCartState();
}

class _AddRemoveWidgetWithAddToCartState
    extends State<_AddRemoveWidgetWithAddToCart> {
  /// The current quantity of items.
  int qty = 1;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Theme.of(context).colorScheme.primary),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                /// Decrement button: Decreases the quantity by 1 when clicked.
                /// Disabled when the quantity is 1.
                IconButton(
                  icon: const Icon(Icons.remove, size: 18),
                  onPressed: qty > 1 ? () => setState(() => qty--) : null,
                ),
                const SizedBox(width: 8),

                /// Displays the current quantity.
                Text(qty.toString()),
                const SizedBox(width: 8),

                /// Increment button: Increases the quantity by 1 when clicked.
                IconButton(
                  icon: const Icon(Icons.add, size: 18),
                  onPressed: () => setState(() => qty++),
                ),
              ],
            ),
          ),
          const SizedBox(width: 24),
          const _AddToCartWidget(),
        ],
      ),
    );
  }
}

/// A widget that displays an "Add to cart" button with a slide animation.
///
/// This widget displays a row with a text widget and a decorated box. The text widget displays the text "Add to cart".
/// The decorated box contains an icon that slides in and out when the widget is hovered over.
///
/// The `controller` controls the slide animation.
/// The `slideOutAnimation` and `slideInAnimation` define the slide out and slide in animations for the icon.
/// The `icon` is the icon that is displayed inside the decorated box.
class _AddToCartWidget extends StatefulWidget {
  const _AddToCartWidget();

  /// The border radius of the decorated box.
  static BorderRadius borderRadius = BorderRadius.circular(12);

  @override
  State<_AddToCartWidget> createState() => _AddToCartWidgetState();
}

class _AddToCartWidgetState extends State<_AddToCartWidget>
    with SingleTickerProviderStateMixin {
  /// The animation controller for the slide animation.
  late final AnimationController controller = AnimationController(
    duration: const Duration(milliseconds: 300),
    vsync: this,
  );

  /// The slide out and slide in animations for the icon.
  late Animation<Offset> slideOutAnimation;
  late Animation<Offset> slideInAnimation;

  /// The icon that is displayed inside the decorated box.
  final Icon icon = const Icon(
    Icons.arrow_forward,
    color: Colors.white,
    size: 18,
  );

  @override
  void initState() {
    // Define the slide out and slide in animations
    slideOutAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(1.5, 0.0),
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOut,
    ));
    slideInAnimation = Tween<Offset>(
      begin: const Offset(-1.5, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOutBack,
    ));
    super.initState();
  }

  @override
  void dispose() {
    // Dispose of the animation controller when it's no longer needed
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Build the "Add to cart" button with a slide animation
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => controller.forward(),
      onExit: (_) => controller.reverse(),
      child: Row(
        children: [
          Text(
            'Add to cart',
            style: Theme.of(context).textTheme.labelLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(width: 8),
          ClipRRect(
            borderRadius: _AddToCartWidget.borderRadius,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: _AddToCartWidget.borderRadius,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Stack(
                  children: [
                    SlideTransition(
                      position: slideOutAnimation,
                      child: icon,
                    ),
                    SlideTransition(
                      position: slideInAnimation,
                      child: icon,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
