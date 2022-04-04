enum ImageAssets {
  background,
  logoT,
  logoIconT,
}

String resolveAsset(ImageAssets imageAssets) {
  const baseDescriptor = 'assets/images';

  final map = {
    ImageAssets.background: 'background.png',
    ImageAssets.logoT: 'logo-t.png',
    ImageAssets.logoIconT: 'logo-icon-t.png',
  };

  return '$baseDescriptor/${map[imageAssets]}';
}
