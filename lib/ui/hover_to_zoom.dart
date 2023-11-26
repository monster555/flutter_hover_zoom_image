import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// A widget that implements a hover-to-zoom effect.
///
/// This widget displays an image that can be zoomed in on hover.
/// The zoomed image is shown in an overlay next to the widget.
///
/// The [imagePath] parameter is the path to the image to be displayed.
/// The [dimension] parameter is the width and height of the widget.
/// The [showPreviewArea] parameter controls whether a preview area is shown on hover.
///
/// The [previewSize] constant is the size of the preview area.
/// The [zoomScale] constant is the scale of the zoom effect.
/// The [zoomDuration] constant is the duration of the zoom animation.
/// The [borderRadius] constant is the border radius of the widget and the preview area.
///
/// ## Example
///
/// ```dart
/// HoverToZoom(
///   imagePath: 'assets/images/sample.jpg',
///   dimension: 400.0,
///   showPreviewArea: true,
/// )
/// ```
class HoverToZoom extends StatefulWidget {
  /// The path to the image to display.
  final String imagePath;

  /// The size of the image and zoom preview.
  final double dimension;

  /// Whether to show the zoom preview area.
  final bool showPreviewArea;

  /// The size of the zoom preview area.
  static const double previewSize = 150.0;

  /// The scale factor for the zoomed image.
  static const double zoomScale = 3.0;

  /// The duration for the zoom animation.
  static const Duration zoomDuration = Duration(milliseconds: 200);

  /// The border radius applied to the image and preview area.
  static final BorderRadius borderRadius = BorderRadius.circular(8);

  const HoverToZoom({
    super.key,
    required this.imagePath,
    this.dimension = 400.0,
    this.showPreviewArea = true,
  });

  @override
  State<HoverToZoom> createState() => _HoverToZoomState();
}

class _HoverToZoomState extends State<HoverToZoom>
    with SingleTickerProviderStateMixin {
  /// The X-coordinate of the current hover position.
  double hoverX = 0.0;

  /// The Y-coordinate of the current hover position.
  double hoverY = 0.0;

  /// The X-coordinate for the zoomed-in hover position.
  double zoomHoverX = 0.0;

  /// The Y-coordinate for the zoomed-in hover position.
  double zoomHoverY = 0.0;

  /// Determines whether to show the zoom preview.
  bool showPreview = false;

  /// The image to be displayed and zoomed.
  late Image image;

  /// Entry in the overlay for displaying the zoomed image.
  OverlayEntry? overlayEntry;

  /// Controller for managing the zoom animation.
  late final AnimationController controller;

  @override
  void initState() {
    super.initState();

    /// Load the image asset specified in the widget configuration.
    image = Image.asset(widget.imagePath);

    /// Initialize the animation controller for zooming with the provided duration.
    controller = AnimationController(
      vsync: this,
      duration: HoverToZoom.zoomDuration,
    );
  }

  @override
  void dispose() {
    /// Dispose of the animation controller.
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /// Creates a square widget with specified dimensions containing an image.
    return SizedBox.square(
      dimension: widget.dimension,

      /// Enables mouse interaction for hover events.
      child: MouseRegion(
        onHover: handleHover,

        /// Toggles the zoom preview on mouse enter and exit.
        onEnter: (_) => togglePreview(true),
        onExit: (_) => togglePreview(false),

        /// Stack widget containing the clipped image and the optional preview area.
        child: Stack(
          children: [
            /// Clipped rectangular border for the displayed image.
            ClipRRect(
              borderRadius: HoverToZoom.borderRadius,
              child: image,
            ),

            /// Conditionally adds the zoom preview area if enabled.
            if (showPreview && widget.showPreviewArea) buildPreviewArea(),
          ],
        ),
      ),
    );
  }

  /// Builds the preview area.
  ///
  /// This method is called to build the preview area that is shown on the widget when it's hovered.
  /// The preview area is a semi-transparent square that indicates the part of the image that will be zoomed.
  ///
  /// The [Positioned] widget is used to position the preview area based on the hover coordinates ([hoverX], [hoverY]).
  ///
  /// The [FadeTransition] widget is used to animate the opacity of the preview area. The opacity animation is controlled by the [controller].
  ///
  /// The [Container] widget is used to create the preview area. It's styled with a semi-transparent white background, a rounded border radius, and a white border.
  Widget buildPreviewArea() => Positioned(
        left: hoverX,
        top: hoverY,
        child: FadeTransition(
          opacity: controller,
          child: Container(
            width: HoverToZoom.previewSize,
            height: HoverToZoom.previewSize,
            decoration: BoxDecoration(
              color: Colors.white30,
              borderRadius: HoverToZoom.borderRadius,
              border: const Border.fromBorderSide(
                BorderSide(
                  color: Colors.white,
                  width: 2,
                ),
              ),
            ),
          ),
        ),
      );

  /// Builds the zoomed image.
  ///
  /// This method is called to build the zoomed image that is shown in the overlay when the widget is hovered.
  /// It uses a [LayoutBuilder] to get the constraints of the parent widget, which are used to calculate the available width.
  ///
  /// The [offsetX] is calculated based on the hover position and the dimension of the widget. It's clamped to ensure the zoomed image stays within the bounds of the overlay.
  ///
  /// The [IgnorePointer] widget is used to prevent the zoomed image from responding to pointer events.
  /// The [ClipRRect] widget is used to clip the zoomed image with a rounded rectangle.
  ///
  /// The zoomed image is translated and scaled based on the hover position and the zoom scale.
  Widget buildZoomedImage() => LayoutBuilder(
        builder: (context, constraints) {
          // Get the available width
          final availableWidth = constraints.maxWidth;

          // Calculate the offset for the zoomed image
          final offsetX = min(-zoomHoverX * widget.dimension,
              availableWidth - widget.dimension);

          // Build the zoomed image
          return IgnorePointer(
            child: ClipRRect(
              borderRadius: HoverToZoom.borderRadius,
              child: Transform.translate(
                offset: Offset(
                  offsetX,
                  -zoomHoverY * widget.dimension,
                ),
                child: Transform.scale(
                  scale: HoverToZoom.zoomScale,
                  child: image,
                ),
              ),
            ),
          );
        },
      );

  /// Handles hover events on the widget.
  ///
  /// This method is called when the mouse pointer hovers over the widget. It updates
  /// the hover coordinates and the zoom hover coordinates based on the position of
  /// the mouse pointer.
  ///
  /// The hover coordinates ([hoverX], [hoverY]) determine the position of the preview area.
  /// They are clamped to ensure the preview area stays within the bounds of the widget.
  ///
  /// The zoom hover coordinates ([zoomHoverX], [zoomHoverY]) determine the position of the
  /// zoomed image in the overlay. They are normalized to a range of -1 to 1.
  ///
  /// After updating the coordinates, this method marks the overlay entry as needing to be built.
  void handleHover(PointerHoverEvent event) {
    setState(() {
      // Update the hover coordinates
      hoverX = (event.localPosition.dx - HoverToZoom.previewSize / 2)
          .clamp(0, widget.dimension - HoverToZoom.previewSize);
      hoverY = (event.localPosition.dy - HoverToZoom.previewSize / 2)
          .clamp(0, widget.dimension - HoverToZoom.previewSize);

      // Update the zoom hover coordinates
      zoomHoverX = (event.localPosition.dx / widget.dimension * 2) - 1;
      zoomHoverY = (event.localPosition.dy / widget.dimension * 2) - 1;
    });

    // Mark the overlay entry as needing to be built
    overlayEntry?.markNeedsBuild();
  }

  /// Toggles the preview of the zoomed image.
  ///
  /// When [value] is true, this method creates an [OverlayEntry] with the zoomed image
  /// and inserts it into the [Overlay]. It then starts the fade-in animation.
  ///
  /// When [value] is false, this method starts the fade-out animation and then removes
  /// the [OverlayEntry] from the [Overlay].
  ///
  /// The [showPreview] state is updated to reflect the new [value].
  void togglePreview(bool value) async {
    if (value) {
      // Create an OverlayEntry with the zoomed image
      overlayEntry = OverlayEntry(
        builder: (context) => Positioned(
          left: widget.dimension,
          child: FadeTransition(
            opacity: controller,
            child: SizedBox(
              width: widget.dimension,
              height: widget.dimension,
              child: buildZoomedImage(),
            ),
          ),
        ),
      );

      // Insert the OverlayEntry into the Overlay
      Overlay.of(context).insert(overlayEntry!);

      // Start the fade-in animation
      controller.forward();
    } else {
      // Start the fade-out animation
      await controller.reverse();

      // Remove the OverlayEntry from the Overlay
      overlayEntry?.remove();
      overlayEntry = null;
    }

    // Update the showPreview state
    setState(() => showPreview = value);
  }
}
