import 'package:flutter/material.dart';
import 'package:flutter_easy/components/base.dart';

import '../utils/distance_util.dart';
import '../utils/global_util.dart';

class PlaceholderView extends StatelessWidget {
  final String title;
  final String image;
  final VoidCallback onTap;

  const PlaceholderView({
    Key key,
    this.title = '暂无数据',
    this.image = 'empty',
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: distanceWith150,
        child: Column(
          children: <Widget>[
            Image.asset(
              assetsImagesPath(image),
              width: distanceWith100,
              height: distanceWith100,
            ),
            SizedBox(height: distanceWith15),
            BaseText(
              title,
              style: TextStyle(
                color: Colors.black38,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
