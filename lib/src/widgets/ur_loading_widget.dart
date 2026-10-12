import 'package:flutter/material.dart';
import 'package:urflutter_core/src/extensions/context_extension.dart';
import 'package:urflutter_core/src/utils/app_dimension.dart';
import 'package:urflutter_core/src/widgets/loading/loading.dart';
import 'package:urflutter_core/urflutter_config.dart';

class UrLoadingWidgetProps {
  UrLoadingWidgetProps({
    this.showLabel = true,
    this.mainAxisAlignment,
    this.nameData,
    this.fullLabel,
    this.foregroundColor,
    this.size,
  });

  final String? nameData;
  final String? fullLabel;
  final Color? foregroundColor;
  final bool showLabel;
  final double? size;
  final MainAxisAlignment? mainAxisAlignment;
}

class UrLoadingWidget extends StatelessWidget {
  const UrLoadingWidget({super.key, this.props});

  final UrLoadingWidgetProps? props;

  LoadingConfig get loadingConfig => UrFlutterConfig.loadingConfig;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: UrDimension.padding,
        child: Column(
          mainAxisAlignment:
              props?.mainAxisAlignment ?? MainAxisAlignment.center,
          spacing: UrDimension.spacingSmall,
          children: [
            LoadingIndicator(
              color: props?.foregroundColor ?? loadingConfig.indicatorColor,
              type: loadingConfig.type,
              secColor: loadingConfig.indicatorSecColor,
              thirdColor: loadingConfig.indicatorThirdColor,
              size: props?.size ?? 30,
              customIndicator: loadingConfig.customWidget,
            ),

            if (props?.showLabel ?? true)
              Text(
                props?.fullLabel ?? 'Loading ${props?.nameData ?? ""}...',
                style: context.textTheme.bodyMedium?.copyWith(
                  color:
                      props?.foregroundColor ?? context.colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
          ],
        ),
      ),
    );
  }
}
