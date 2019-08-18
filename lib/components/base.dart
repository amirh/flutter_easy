import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/global_utils.dart';
import '../utils/color_utils.dart';

abstract class PlatformWidget<M extends Widget, C extends Widget>
    extends StatelessWidget {
  M buildMaterialWidget(BuildContext context);

  C buildCupertinoWidget(BuildContext context);

  @override
  Widget build(BuildContext context) {
    if (isIOS) {
      return buildCupertinoWidget(context);
    }
    return buildMaterialWidget(context);
  }
}

class BaseApp extends StatelessWidget {
  final RouteFactory onGenerateRoute;

  BaseApp({this.onGenerateRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        platform: TargetPlatform.iOS,
        primarySwatch: Colors.grey,
        splashColor: Colors.transparent,
        appBarTheme: AppBarTheme(
          textTheme: TextTheme(
            title: TextStyle(
                fontSize: 17,
                color: colorWithAppBarTint,
                fontWeight: FontWeight.w500),
          ),
        ),
        textTheme: TextTheme(
          button: TextStyle(
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      onGenerateRoute: onGenerateRoute,
    );
  }
}

Widget _buildLeading({BuildContext context, Widget leading, Color tintColor}) {
  final ModalRoute<dynamic> parentRoute = ModalRoute.of(context);

  final bool canPop = parentRoute?.canPop ?? false;
  final bool useCloseButton =
      parentRoute is PageRoute<dynamic> && parentRoute.fullscreenDialog;

  Widget _leading = leading;
  if (_leading == null) {
    if (canPop) {
      if (isIOS) {
        _leading = useCloseButton
            ? CupertinoButton(
                child: Icon(
                  Icons.close,
                  color: tintColor,
                ),
                padding: EdgeInsets.zero,
                onPressed: () {
                  Navigator.maybePop(context);
                },
              )
            : CupertinoNavigationBarBackButton(
                color: tintColor,
              );
      } else {
        _leading = IconButton(
          icon:
              useCloseButton ? const Icon(Icons.close) : const BackButtonIcon(),
          color: tintColor ?? colorWithAppBarTint,
          onPressed: () => Navigator.maybePop(context),
        );
      }
    }
  }
  return _leading;
}

class BaseAppBar extends PlatformWidget<AppBar, PreferredSize> {
  final Widget title;
  final Widget leading;
  final List<Widget> actions;
  final double elevation;
  final Color tintColor;
  final Color backgroundColor;
  final Brightness brightness;

  BaseAppBar({
    this.title,
    this.leading,
    this.actions,
    this.elevation = 0,
    this.tintColor,
    this.backgroundColor,
    this.brightness = Brightness.light,
  });

  @override
  AppBar buildMaterialWidget(BuildContext context) {
    return AppBar(
      leading: _buildLeading(
          context: context,
          leading: leading,
          tintColor: tintColor ?? colorWithAppBarTint),
      title: title,
      actions: actions == null ? [] : actions,
      elevation: elevation,
      backgroundColor: backgroundColor ?? colorWithAppBarBackground,
      brightness: brightness,
    );
  }

  @override
  PreferredSize buildCupertinoWidget(BuildContext context) {
    Widget leading = _buildLeading(
        context: context,
        leading: this.leading,
        tintColor: tintColor ?? colorWithAppBarTint);

    return PreferredSize(
      preferredSize: Size.fromHeight(44),
      child: AppBar(
        leading: leading,
        title: title,
        actions: actions == null ? [] : actions,
        elevation: elevation,
        backgroundColor: backgroundColor ?? colorWithAppBarBackground,
        brightness: brightness,
      ),
    );
  }
}

class BaseSliverAppBar extends PlatformWidget<SliverAppBar, PreferredSize> {
  final Widget title;
  final Widget leading;
  final List<Widget> actions;
  final double elevation;
  final Color tintColor;
  final Color backgroundColor;
  final Brightness brightness;
  final bool pinned;
  final double expandedHeight;
  final Widget flexibleSpace;

  BaseSliverAppBar({
    this.title,
    this.leading,
    this.actions,
    this.elevation = 0,
    this.tintColor,
    this.backgroundColor,
    this.brightness = Brightness.light,
    this.pinned,
    this.expandedHeight,
    this.flexibleSpace,
  });

  @override
  SliverAppBar buildMaterialWidget(BuildContext context) {
    return SliverAppBar(
      leading: _buildLeading(
          context: context,
          leading: this.leading,
          tintColor: tintColor ?? colorWithAppBarTint),
      title: title,
      actions: actions == null ? [] : actions,
      elevation: elevation,
      backgroundColor: backgroundColor ?? colorWithAppBarBackground,
      brightness: brightness,
      pinned: pinned,
      expandedHeight: expandedHeight,
      flexibleSpace: flexibleSpace,
    );
  }

  @override
  PreferredSize buildCupertinoWidget(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(44),
      child: SliverAppBar(
        leading: _buildLeading(
            context: context,
            leading: this.leading,
            tintColor: tintColor ?? colorWithAppBarTint),
        title: title,
        actions: actions == null ? [] : actions,
        elevation: elevation,
        backgroundColor: backgroundColor ?? colorWithAppBarBackground,
        brightness: brightness,
        pinned: pinned,
        expandedHeight: expandedHeight,
        flexibleSpace: flexibleSpace,
      ),
    );
  }
}

class BaseScaffold extends StatelessWidget {
  final BaseAppBar appBar;
  final Widget body;
  final Color backgroundColor;
  final Widget bottomNavigationBar;

  BaseScaffold({
    this.appBar,
    this.body,
    this.backgroundColor,
    this.bottomNavigationBar,
  });

  @override
  Widget build(BuildContext context) {
    if (appBar == null) {
      return Scaffold(
        body: body,
        backgroundColor: backgroundColor ?? colorWithScaffoldBackground,
        bottomNavigationBar: bottomNavigationBar,
      );
    }
    return Scaffold(
      appBar: isIOS
          ? appBar.buildCupertinoWidget(context)
          : appBar.buildMaterialWidget(context),
      body: body,
      backgroundColor: backgroundColor ?? colorWithScaffoldBackground,
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}

class BaseButton extends StatelessWidget {
  @required
  final EdgeInsetsGeometry padding;
  @required
  final Widget child;
  @required
  final VoidCallback onPressed;

  BaseButton({this.padding, this.child, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: padding,
      child: child,
      onPressed: onPressed,
    );
  }
}

class BaseGradientButton extends StatelessWidget {
  final double width;
  final double height;
  final EdgeInsetsGeometry padding;
  final Widget icon;
  final Widget title;
  final double borderRadius;
  final Gradient gradient;
  final Gradient disableGradient;
  final VoidCallback onPressed;

  const BaseGradientButton(
      {Key key,
      this.width = double.infinity,
      this.height = 44,
      this.padding,
      this.icon,
      this.title,
      this.borderRadius = 22,
      this.gradient =
          const LinearGradient(colors: [Color(0xFFFF6597), Color(0xFFFF4040)]),
      this.disableGradient =
          const LinearGradient(colors: [Color(0xFFE3E3E3), Color(0xFFD3D3D3)]),
      this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];
    if (icon != null) {
      children.add(icon);
      children.add(SizedBox(width: 10));
    }
    if (title != null) {
      children.add(title);
    }
    return Container(
      padding: padding,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          gradient: onPressed != null ? gradient : disableGradient,
        ),
        child: Container(
          width: width,
          height: height,
          child: FlatButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius)),
            splashColor: Colors.transparent,
            child: Center(
              child: Container(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: children),
              ),
            ),
            onPressed: onPressed,
          ),
        ),
      ),
    );
  }
}

class BaseBackgroundButton extends StatelessWidget {
  final double width;
  final double height;
  final EdgeInsetsGeometry padding;
  final Widget icon;
  final Widget title;
  final double borderRadius;
  final Color color;
  final Color disableColor;
  final VoidCallback onPressed;

  const BaseBackgroundButton(
      {Key key,
      this.width = double.infinity,
      this.height = 44,
      this.padding,
      this.icon,
      this.title,
      this.borderRadius = 22,
      this.color,
      this.disableColor,
      this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];
    if (icon != null) {
      children.add(icon);
      children.add(SizedBox(width: 10));
    }
    if (title != null) {
      children.add(title);
    }
    return Container(
      padding: padding,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          color: onPressed != null
              ? (color ?? colorWithTint)
              : (disableColor ?? Colors.grey),
        ),
        child: Container(
          width: width,
          height: height,
          child: FlatButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius)),
            splashColor: Colors.transparent,
            child: Center(
              child: Container(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: children),
              ),
            ),
            onPressed: onPressed,
          ),
        ),
      ),
    );
  }
}

class BaseAlertDialog extends StatelessWidget {
  final Widget title;
  final Widget content;
  final List<Widget> actions;

  const BaseAlertDialog({
    Key key,
    this.title = const Text('温馨提示'),
    this.content,
    this.actions = const <Widget>[],
  })  : assert(actions != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      key: key,
      title: title,
      content: content,
      actions: actions,
    );
  }
}

class BaseDialogAction extends StatelessWidget {
  const BaseDialogAction({
    this.onPressed,
    this.isDefaultAction = false,
    this.isDestructiveAction = false,
    this.textStyle,
    @required this.child,
  }) : assert(child != null);

  final VoidCallback onPressed;
  final bool isDefaultAction;
  final bool isDestructiveAction;
  final TextStyle textStyle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return CupertinoDialogAction(
      onPressed: onPressed,
      isDefaultAction: isDefaultAction,
      isDestructiveAction: isDestructiveAction,
      textStyle: textStyle,
      child: child,
    );
  }
}

Future<T> showBaseDialog<T>({
  @required BuildContext context,
  bool barrierDismissible = false,
  WidgetBuilder builder,
}) {
  return showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: builder);
}
