class ConfigurationImage {
  final double maxImageSize;
  final List<String> extImageAllowed;

  ConfigurationImage({
    this.maxImageSize = 2, // MB
    this.extImageAllowed = const ['.jpg', '.jpeg'],
  });
}
