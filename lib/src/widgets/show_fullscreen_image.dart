import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:urflutter_core/src/styles/colors.dart';
import 'package:urflutter_core/src/urflutter_config.dart';
import 'package:urflutter_core/src/widgets/buttons/urbutton.dart';
import 'package:urflutter_core/utils.dart';

import '../extensions/context_extension.dart';

Future<void> showFullscreenImage(
  BuildContext context, {
  required List<String> images,
  int? initialIndex,
  bool useAssetImageProvider = false,
}) async {
  await showDialog(
    context: context,
    useSafeArea: false,
    barrierColor: Colors.black,
    barrierDismissible: false,
    builder: (context) => _FullscreenImageViewer(
      images: images,
      initialIndex: initialIndex ?? 0,
      useAssetImageProvider: useAssetImageProvider,
    ),
  );
}

class _FullscreenImageViewer extends StatefulWidget {
  const _FullscreenImageViewer({
    required this.images,
    required this.initialIndex,
    this.useAssetImageProvider = false,
  });

  final List<String> images;
  final int initialIndex;
  final bool useAssetImageProvider;

  @override
  State<_FullscreenImageViewer> createState() => __FullscreenImageViewerState();
}

class __FullscreenImageViewerState extends State<_FullscreenImageViewer> {
  late ValueNotifier<int> _currentIndexCarousel;

  @override
  void initState() {
    super.initState();
    _currentIndexCarousel = ValueNotifier<int>(widget.initialIndex);
  }

  @override
  void dispose() {
    _currentIndexCarousel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PhotoViewGallery.builder(
            itemCount: widget.images.length,
            onPageChanged: (index) => _currentIndexCarousel.value = index,
            pageController: PageController(initialPage: widget.initialIndex),
            builder: (context, index) {
              return PhotoViewGalleryPageOptions(
                imageProvider: widget.useAssetImageProvider
                    ? MemoryImage(File(widget.images[index]).readAsBytesSync())
                    : CachedNetworkImageProvider(widget.images[index]),
                minScale: PhotoViewComputedScale.contained,
                maxScale: PhotoViewComputedScale.covered * 2,
                heroAttributes: PhotoViewHeroAttributes(
                  tag: widget.images[index],
                ),
              );
            },
            scrollPhysics: const BouncingScrollPhysics(),
            backgroundDecoration: const BoxDecoration(color: Colors.black),
          ),
          Positioned(
            top: 40,
            left: 16,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () => context.pop(),
            ),
          ),
          if (widget.images.length > 1)
            ValueListenableBuilder<int>(
              valueListenable: _currentIndexCarousel,
              builder: (context, value, child) => _dots(
                context,
                totalCarousel: widget.images.length,
                indexActive: value,
              ),
            ),

          Align(
            alignment: Alignment.bottomCenter.add(const Alignment(0, -.2)),
            child: SizedBox(
              width: context.screenWidth * .6,
              height: UrDimension.buttonHeight - 10,
              child: UrButton.text(
                props: PropsButton(
                  foregroundColor: UrColors.white,
                  backgroundColor: UrColors.black,
                  onPressed: () {
                    context.pop();
                  },
                  label: 'Tutup',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget _dots(
  BuildContext context, {
  required int totalCarousel,
  required int indexActive,
}) {
  return Align(
    alignment: Alignment.bottomCenter.add(const Alignment(0, -.4)),

    child: SizedBox(
      width: context.screenWidth,
      child: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 5,
          children: List.generate(totalCarousel, (index) {
            final isActive = index == indexActive;

            return AnimatedContainer(
              height: 7,
              width: isActive ? 14 : 7,
              decoration: BoxDecoration(
                color: isActive
                    ? UrFlutterConfig.appColors.appPrimary
                    : UrColors.gray,
                borderRadius: UrDimension.borderRadius,
              ),
              duration: const Duration(milliseconds: 500),
            );
          }),
        ),
      ),
    ),
  );
}
