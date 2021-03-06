import 'package:flutter/material.dart';
import 'package:flutter_easy/components/base.dart';
import 'package:flutter_easy/components/base_animation_image.dart';
import 'package:flutter_easy/utils/color_util.dart';

import 'base_animation_image.dart';

class LoadingView extends StatelessWidget {
  final String message;

  const LoadingView({Key key, this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (baseDefaultAnimationImage != null) {
      return message?.isNotEmpty == true
          ? Stack(
              alignment: Alignment.bottomCenter,
              fit: StackFit.expand,
              children: <Widget>[
                baseDefaultAnimationImage,
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    margin: EdgeInsets.only(top: 100),
                    child: BaseTitle(
                      message,
                      fontSize: 14,
                      color: colorWithHex9,
                    ),
                  ),
                ),
              ],
            )
          : baseDefaultAnimationImage;
    }
    return Padding(
      padding: EdgeInsets.all((message == null) ? 30 : 15),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: _buildChildren(),
      ),
    );
  }

  List<Widget> _buildChildren() {
    List<Widget> list = [CircularProgressIndicator()];
    if (message != null && message.isNotEmpty) {
      list.add(Padding(
        padding: const EdgeInsets.only(top: 15),
        child: BaseText(
          message,
          maxLines: 2,
          style: TextStyle(
            color: colorWithHex9,
            fontSize: 14,
          ),
        ),
      ));
    }
    return list;
  }
}
