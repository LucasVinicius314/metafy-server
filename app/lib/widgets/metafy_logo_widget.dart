import 'package:flutter/material.dart';
import 'package:metafy_app/utils/assets.dart';

class MetafyLogo extends StatelessWidget {
  const MetafyLogo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      child: Image.asset(resolveAsset(ImageAssets.logoT)),
      constraints: BoxConstraints.loose(const Size(200, 200)),
    );
  }
}
