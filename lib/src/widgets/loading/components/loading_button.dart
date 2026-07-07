import 'package:flutter/material.dart';

import '../types/loading_type.dart';
import 'loading_indicator.dart';

class LoadingButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final Future<void> Function()? onPressedAsync;
  final Widget child;
  final bool isLoading;
  final LoadingType loadingType;
  final Color? loadingColor;
  final ButtonStyle? style;
  final bool disabled;

  const LoadingButton({
    super.key,
    this.onPressed,
    this.onPressedAsync,
    required this.child,
    this.isLoading = false,
    this.loadingType = LoadingType.circular,
    this.loadingColor,
    this.style,
    this.disabled = false,
  }) : assert(
         onPressed != null || onPressedAsync != null,
         'Either onPressed or onPressedAsync must be provided',
       );

  @override
  State<LoadingButton> createState() => _LoadingButtonState();
}

class _LoadingButtonState extends State<LoadingButton> {
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    final isLoading = widget.isLoading || _isProcessing;
    final isDisabled = widget.disabled || isLoading;

    return ElevatedButton(
      onPressed: isDisabled ? null : _handlePress,
      style: widget.style,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: isLoading
            ? SizedBox(
                height: 20,
                width: 20,
                child: LoadingIndicator(
                  type: widget.loadingType,
                  color: widget.loadingColor ?? Colors.white,
                  size: 20,
                ),
              )
            : widget.child,
      ),
    );
  }

  Future<void> _handlePress() async {
    if (widget.onPressedAsync != null) {
      setState(() => _isProcessing = true);
      try {
        await widget.onPressedAsync!();
      } finally {
        if (mounted) {
          setState(() => _isProcessing = false);
        }
      }
    } else {
      widget.onPressed?.call();
    }
  }
}

class LoadingOutlinedButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final Future<void> Function()? onPressedAsync;
  final Widget child;
  final bool isLoading;
  final LoadingType loadingType;
  final Color? loadingColor;
  final ButtonStyle? style;

  const LoadingOutlinedButton({
    super.key,
    this.onPressed,
    this.onPressedAsync,
    required this.child,
    this.isLoading = false,
    this.loadingType = LoadingType.circular,
    this.loadingColor,
    this.style,
  });

  @override
  State<LoadingOutlinedButton> createState() => _LoadingOutlinedButtonState();
}

class _LoadingOutlinedButtonState extends State<LoadingOutlinedButton> {
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    final isLoading = widget.isLoading || _isProcessing;

    return OutlinedButton(
      onPressed: isLoading ? null : _handlePress,
      style: widget.style,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: isLoading
            ? SizedBox(
                height: 20,
                width: 20,
                child: LoadingIndicator(
                  type: widget.loadingType,
                  color:
                      widget.loadingColor ??
                      Theme.of(context).colorScheme.primary,
                  size: 20,
                ),
              )
            : widget.child,
      ),
    );
  }

  Future<void> _handlePress() async {
    if (widget.onPressedAsync != null) {
      setState(() => _isProcessing = true);
      try {
        await widget.onPressedAsync!();
      } finally {
        if (mounted) {
          setState(() => _isProcessing = false);
        }
      }
    } else {
      widget.onPressed?.call();
    }
  }
}

class LoadingTextButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final Future<void> Function()? onPressedAsync;
  final Widget child;
  final bool isLoading;
  final LoadingType loadingType;
  final Color? loadingColor;
  final ButtonStyle? style;

  const LoadingTextButton({
    super.key,
    this.onPressed,
    this.onPressedAsync,
    required this.child,
    this.isLoading = false,
    this.loadingType = LoadingType.circular,
    this.loadingColor,
    this.style,
  });

  @override
  State<LoadingTextButton> createState() => _LoadingTextButtonState();
}

class _LoadingTextButtonState extends State<LoadingTextButton> {
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    final isLoading = widget.isLoading || _isProcessing;

    return TextButton(
      onPressed: isLoading ? null : _handlePress,
      style: widget.style,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: isLoading
            ? SizedBox(
                height: 20,
                width: 20,
                child: LoadingIndicator(
                  type: widget.loadingType,
                  color:
                      widget.loadingColor ??
                      Theme.of(context).colorScheme.primary,
                  size: 20,
                ),
              )
            : widget.child,
      ),
    );
  }

  Future<void> _handlePress() async {
    if (widget.onPressedAsync != null) {
      setState(() => _isProcessing = true);
      try {
        await widget.onPressedAsync!();
      } finally {
        if (mounted) {
          setState(() => _isProcessing = false);
        }
      }
    } else {
      widget.onPressed?.call();
    }
  }
}
