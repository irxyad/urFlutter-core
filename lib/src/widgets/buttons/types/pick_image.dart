part of '../urbutton.dart';

Future<void> _pickImage(
  BuildContext context,
  FormFieldState<File?> field,
) async {
  final cropped = await onPickImage(context);
  if (cropped?.croppedImage == null || cropped?.originalImage == null) {
    return;
  }

  final filename = DirectoryUtils.thumbnailFilename(
    cropped!.originalImage!.path,
  );

  final file = await DirectoryUtils.writeToTemp(
    cropped.croppedImage!,
    filename,
  );

  field.didChange(file);
}

Future<void> _previewImage(BuildContext context, File? image) async {
  if (image == null) return;

  await showFullscreenImage(context, images: [image.path]);
}

class _PickImage extends StatelessWidget {
  const _PickImage({required this.props});

  final PropsPickImgButton props;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    final imageName = DirectoryUtils.extractSuffix(props.selectedImage?.path);

    return FormField<File?>(
      initialValue: props.selectedImage,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (value == null && props.isRequired) {
          return 'Thumbnail belum dipilih';
        }
        return null;
      },
      builder: (field) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (props.label != null)
              _Label(label: props.label!, isRequired: props.isRequired),

            const SizedBox(height: 6),

            _PickerBox(
              theme: theme,
              imageName: imageName ?? props.hintPickImage,
              selectedImage: props.selectedImage,
              onPick: () => _pickImage(context, field),
              onPreview: () => _previewImage(context, field.value),
              onClear: () {
                field.didChange(null);
                props.onChanged?.call(null);
              },
              backgroundColor: props.backgroundColor,
            ),

            if (field.errorText != null) ...[
              const SizedBox(height: 4),
              Text(
                field.errorText!,
                style: textTheme.bodySmall?.copyWith(color: colorScheme.error),
              ),
            ],
          ],
        );
      },
    );
  }
}

class _Label extends StatelessWidget {
  const _Label({required this.label, required this.isRequired});

  final String label;
  final bool isRequired;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Text(label, style: textTheme.bodyMedium),
        if (isRequired)
          Text(
            ' *',
            style: textTheme.bodyMedium?.copyWith(color: colorScheme.error),
          ),
      ],
    );
  }
}

class _IconBtn extends StatelessWidget {
  const _IconBtn({
    required this.icon,
    required this.onPressed,
    required this.colorScheme,
    this.isPrimary = false,
    this.isDestructive = false,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final ColorScheme colorScheme;
  final bool isPrimary;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    final bg = isDestructive
        ? colorScheme.error
        : isPrimary
        ? colorScheme.primary
        : colorScheme.surfaceContainerHighest;

    final fg = isDestructive || isPrimary
        ? colorScheme.onPrimary
        : colorScheme.onSurface;

    return SizedBox(
      height: UrDimension.buttonHeight - 10,
      width: UrDimension.buttonHeight - 10,
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, size: 18),
        style: IconButton.styleFrom(backgroundColor: bg, foregroundColor: fg),
      ),
    );
  }
}

class _PickerBox extends StatelessWidget {
  const _PickerBox({
    required this.theme,
    required this.imageName,
    required this.selectedImage,
    required this.onPick,
    required this.onPreview,
    required this.onClear,
    this.backgroundColor,
  });

  final ThemeData theme;
  final String imageName;
  final File? selectedImage;
  final VoidCallback onPick;
  final VoidCallback onPreview;
  final VoidCallback onClear;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return Container(
      height: UrDimension.buttonHeight,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: backgroundColor ?? colorScheme.surface,
        borderRadius: UrDimension.borderRadius,
      ),
      child: Row(
        children: [
          const Icon(IconsaxPlusBold.image, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              imageName,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          if (selectedImage != null) ...[
            _IconBtn(
              icon: Icons.zoom_in_rounded,
              onPressed: onPreview,
              colorScheme: colorScheme,
            ),
            _IconBtn(
              icon: Icons.clear,
              onPressed: onClear,
              colorScheme: colorScheme,
              isDestructive: true,
            ),
          ] else
            _IconBtn(
              icon: Icons.add_a_photo,
              onPressed: onPick,
              colorScheme: colorScheme,
              isPrimary: true,
            ),
        ],
      ),
    );
  }
}
