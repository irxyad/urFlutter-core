import 'dart:typed_data';

import 'package:crop_your_image/crop_your_image.dart';
import 'package:flutter/material.dart';
import 'package:urflutter_core/src/extensions/context_extension.dart';
import 'package:urflutter_core/src/urflutter_config.dart';
import 'package:urflutter_core/src/utils/app_dimension.dart';
import 'package:urflutter_core/src/widgets/buttons/urbutton.dart';
import 'package:urflutter_core/src/widgets/loading/ur_loading.dart';
import 'package:urflutter_core/src/widgets/ur_loading_widget.dart';

class ImageCrop extends StatefulWidget {
  const ImageCrop({
    required this.imageList,
    required this.onCropped,
    super.key,
    this.aspectRatio,
    this.appBar,
  });

  final Uint8List imageList;
  final void Function(CropResult result) onCropped;
  final double? aspectRatio;
  final PreferredSizeWidget? appBar;

  @override
  State<ImageCrop> createState() => _ImageCropState();
}

class _ImageCropState extends State<ImageCrop> {
  final _controller = CropController();

  ValueNotifier<bool> isLoading = ValueNotifier<bool>(true);

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: widget.appBar,
        body: Crop(
          image: widget.imageList,
          onCropped: widget.onCropped,
          aspectRatio: widget.aspectRatio,
          controller: _controller,
          radius: UrDimension.radius,
          maskColor: Colors.black.withValues(alpha: .8),
          progressIndicator: const UrLoadingWidget(),
          onStatusChanged: (value) {
            if (value == CropStatus.ready) {
              isLoading.value = false;
            }
          },
          cornerDotBuilder: (size, edgeAlignment) =>
              DotControl(color: UrFlutterConfig.appColors.appPrimary),
        ),

        bottomNavigationBar: BottomAppBar(
          color: context.theme.scaffoldBackgroundColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            spacing: UrDimension.spacing,
            children: [
              Expanded(
                child: UrButton.text(
                  props: PropsButton(
                    label: 'Cancel',
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ),
              Expanded(
                child: ValueListenableBuilder(
                  valueListenable: isLoading,
                  builder: (context, isLoading, child) {
                    return UrButton.text(
                      props: PropsButton(
                        label: "Save",

                        onPressed: isLoading
                            ? null
                            : () {
                                UrLoading.show();
                                _controller.crop();
                              },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
