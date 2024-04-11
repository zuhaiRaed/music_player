import 'dart:math' as math;

import 'package:flutter/material.dart';

class SelectionNotifier extends ChangeNotifier {
  late int lastIndex;
  int currentIndex;
  final ValueChanged<int>? onTap;

  SelectionNotifier(this.currentIndex, this.onTap);

  void selectIndex(int index) {
    lastIndex = currentIndex;
    currentIndex = index;
    onTap?.call(index);
    notifyListeners();
  }
}

class SnakeView extends StatefulWidget {
  final int itemsCount;
  final double widgetEdgePadding;
  final SelectionNotifier notifier;
  final Duration animationDuration;
  final Duration delayTransition;
  final Curve snakeCurve;
  final double indicatorHeight;
  final double height;

  const SnakeView({
    Key? key,
    required this.itemsCount,
    required this.widgetEdgePadding,
    required this.notifier,
    this.animationDuration = const Duration(milliseconds: 200),
    this.delayTransition = const Duration(milliseconds: 50),
    this.snakeCurve = Curves.easeInOut,
    this.indicatorHeight = 4,
    required this.height,
  }) : super(key: key);

  @override
  _SnakeViewState createState() => _SnakeViewState();
}

class _SnakeViewState extends State<SnakeView> {
  double left = 0;
  int snakeSize = 1;
  int? currentIndex;
  Orientation? orientation;
  double? oneItemWidth;
  double? prevItemWidth;

  bool get isRTL => Directionality.of(context) == TextDirection.rtl;

  void addListener() {
    widget.notifier.addListener(() {
      if (widget.notifier.lastIndex < widget.notifier.currentIndex) {
        _goRight();
      } else if (widget.notifier.lastIndex > widget.notifier.currentIndex) {
        _goLeft();
      }
      currentIndex = widget.notifier.currentIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = SnakeBottomBarTheme.of(context)!;
    oneItemWidth =
        (MediaQuery.of(context).size.width - widget.widgetEdgePadding) /
            widget.itemsCount;
    oneItemWidth =
        (MediaQuery.of(context).size.width - widget.widgetEdgePadding) /
            widget.itemsCount;

    addListener();

    if (currentIndex == null ||
        currentIndex != widget.notifier.currentIndex ||
        orientation != MediaQuery.of(context).orientation ||
        prevItemWidth != oneItemWidth) {
      left = oneItemWidth! * widget.notifier.currentIndex;
      currentIndex = widget.notifier.currentIndex;
      orientation = MediaQuery.of(context).orientation;
      prevItemWidth = oneItemWidth;
    }

    final viewPadding = theme.snakeShape.type == theme.snakeShape.centered!
        ? () {
            final maxSize = math.min(oneItemWidth!, widget.height);
            return EdgeInsets.symmetric(
                  vertical: (widget.height - maxSize) / 2,
                  horizontal: (oneItemWidth! - maxSize) / 2,
                ) +
                theme.snakeShape.padding;
          }()
        : theme.snakeShape.padding;

    final snakeViewWidth = oneItemWidth! * snakeSize - viewPadding.horizontal;

    return AnimatedPositioned(
      left: isRTL ? null : left,
      right: isRTL ? left : null,
      duration: widget.animationDuration,
      curve: widget.snakeCurve,
      child: AnimatedContainer(
        margin: viewPadding,
        curve: widget.snakeCurve,
        duration: widget.animationDuration,
        width: snakeViewWidth,
        height: 4,
        child: Material(
          shape: _getRoundShape(2),
          clipBehavior: Clip.antiAlias,
        ),
      ),
    );
  }

  void _goRight() {
    final newSnakeSize =
        widget.notifier.currentIndex + 1 - widget.notifier.lastIndex;
    setState(() => snakeSize = newSnakeSize);
    Future.delayed(
      widget.animationDuration + widget.delayTransition,
      () => setState(() {
        snakeSize = 1;
        left = oneItemWidth! * widget.notifier.currentIndex;
      }),
    );
  }

  void _goLeft() {
    final newSnakeSize =
        (widget.notifier.currentIndex - widget.notifier.lastIndex).abs();
    setState(() {
      left = oneItemWidth! * widget.notifier.currentIndex;
      snakeSize = newSnakeSize + 1;
    });
    Future.delayed(
      widget.animationDuration + widget.delayTransition,
      () => setState(() => snakeSize = 1),
    );
  }

  ShapeBorder _getRoundShape(double radius) => RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(radius)),
      );
}

class SnakeShape {
  final ShapeBorder? shape;

  final bool? centered;

  final SnakeShapeType? type;

  final EdgeInsets padding;

  final double? height;

  const SnakeShape({
    required this.shape,
    this.centered = true,
    this.padding = EdgeInsets.zero,
    this.height,
  }) : type = SnakeShapeType.indicator;

  const SnakeShape._({
    this.shape,
    this.type,
    this.centered,
    this.padding = EdgeInsets.zero,
    this.height,
  });

  SnakeShape copyWith({
    ShapeBorder? shape,
    bool? centered,
    EdgeInsets? padding,
  }) {
    return SnakeShape._(
      shape: shape ?? this.shape,
      type: type,
      centered: centered ?? this.centered,
      padding: padding ?? this.padding,
    );
  }

  static const SnakeShape indicator = SnakeShape._(
      shape: null, type: SnakeShapeType.indicator, centered: false);
}

enum SnakeShapeType {
  indicator,
}

class SnakeBottomBarTheme extends InheritedWidget {
  const SnakeBottomBarTheme({
    required this.data,
    Key? key,
    required Widget child,
  }) : super(key: key, child: child);

  final SnakeBottomBarThemeData data;

  static SnakeBottomBarThemeData? of(BuildContext context) {
    final bottomNavTheme =
        context.dependOnInheritedWidgetOfExactType<SnakeBottomBarTheme>();
    return bottomNavTheme?.data;
  }

  @override
  bool updateShouldNotify(SnakeBottomBarTheme oldWidget) => false;
}

class SnakeBottomBarThemeData {
  final Gradient snakeGradient;
  final Gradient backgroundGradient;
  final Gradient selectedItemGradient;
  final Gradient unselectedItemGradient;
  final bool showSelectedLabels;
  final bool showUnselectedLabels;
  final SnakeShape snakeShape;
  final SelectionStyle selectionStyle;
  final TextStyle? selectedLabelStyle;
  final TextStyle? unselectedLabelStyle;

  SnakeBottomBarThemeData({
    required this.snakeGradient,
    required this.backgroundGradient,
    required this.selectedItemGradient,
    required this.unselectedItemGradient,
    required this.showSelectedLabels,
    required this.showUnselectedLabels,
    required this.snakeShape,
    required this.selectionStyle,
    required this.selectedLabelStyle,
    required this.unselectedLabelStyle,
  });
}

enum SelectionStyle { color, gradient }

class MySnakeNavigationBar extends StatelessWidget {
  final List<BottomNavigationBarItem>? items;

  final Gradient? backgroundGradient;

  final Gradient? snakeViewGradient;

  final Gradient? selectedItemGradient;

  final Gradient? unselectedItemGradient;

  final bool showSelectedLabels;

  final bool showUnselectedLabels;

  final int currentIndex;

  final Color shadowColor;

  final SnakeShape snakeShape;

  final SnakeBarBehaviour behaviour;

  final ShapeBorder? shape;
  final EdgeInsets padding;
  final double elevation;

  final TextStyle? selectedLabelStyle;

  final TextStyle? unselectedLabelStyle;

  final ValueChanged<int>? onTap;

  final SelectionStyle _selectionStyle;

  final double height;

  MySnakeNavigationBar._(
    this._selectionStyle, {
    Key? key,
    this.snakeViewGradient,
    this.backgroundGradient,
    this.selectedItemGradient,
    this.unselectedItemGradient,
    bool showSelectedLabels = false,
    this.showUnselectedLabels = false,
    this.items,
    this.currentIndex = 0,
    this.shape,
    this.padding = EdgeInsets.zero,
    this.elevation = 0,
    this.onTap,
    this.behaviour = SnakeBarBehaviour.pinned,
    this.snakeShape = SnakeShape.indicator,
    this.shadowColor = Colors.black,
    this.selectedLabelStyle,
    this.unselectedLabelStyle,
    required this.height,
  })  : showSelectedLabels = showSelectedLabels,
        super(key: key);

  factory MySnakeNavigationBar.color({
    Key? key,
    Color? snakeViewColor,
    Color? backgroundColor,
    Color? selectedItemColor,
    Color? unselectedItemColor,
    bool showSelectedLabels = false,
    bool showUnselectedLabels = false,
    List<BottomNavigationBarItem>? items,
    int currentIndex = 0,
    ShapeBorder? shape,
    EdgeInsets padding = EdgeInsets.zero,
    double elevation = 0.0,
    ValueChanged<int>? onTap,
    SnakeBarBehaviour behaviour = SnakeBarBehaviour.pinned,
    SnakeShape snakeShape = SnakeShape.indicator,
    Color shadowColor = Colors.black,
    TextStyle? selectedLabelStyle,
    TextStyle? unselectedLabelStyle,
    double? height,
  }) =>
      MySnakeNavigationBar._(
        SelectionStyle.color,
        key: key,
        snakeViewGradient: snakeViewColor?.toGradient,
        backgroundGradient: backgroundColor?.toGradient,
        selectedItemGradient: selectedItemColor?.toGradient,
        unselectedItemGradient: unselectedItemColor?.toGradient,
        showSelectedLabels: showSelectedLabels,
        showUnselectedLabels: showUnselectedLabels,
        items: items,
        currentIndex: currentIndex,
        shape: shape,
        padding: padding,
        elevation: elevation,
        onTap: onTap,
        behaviour: behaviour,
        snakeShape: snakeShape,
        shadowColor: shadowColor,
        selectedLabelStyle: selectedLabelStyle,
        unselectedLabelStyle: unselectedLabelStyle,
        height: height ?? kBottomNavigationBarHeight,
      );

  factory MySnakeNavigationBar.gradient({
    Key? key,
    Gradient? snakeViewGradient,
    Gradient? backgroundGradient,
    Gradient? selectedItemGradient,
    Gradient? unselectedItemGradient,
    bool showSelectedLabels = false,
    bool showUnselectedLabels = false,
    List<BottomNavigationBarItem>? items,
    int currentIndex = 0,
    ShapeBorder? shape,
    EdgeInsets padding = EdgeInsets.zero,
    double elevation = 0.0,
    ValueChanged<int>? onTap,
    SnakeBarBehaviour behaviour = SnakeBarBehaviour.pinned,
    SnakeShape snakeShape = SnakeShape.indicator,
    Color shadowColor = Colors.black,
    TextStyle? selectedLabelStyle,
    TextStyle? unselectedLabelStyle,
    double? height,
  }) =>
      MySnakeNavigationBar._(
        SelectionStyle.gradient,
        key: key,
        snakeViewGradient: snakeViewGradient,
        backgroundGradient: backgroundGradient,
        selectedItemGradient: selectedItemGradient,
        unselectedItemGradient: unselectedItemGradient,
        showSelectedLabels: showSelectedLabels,
        showUnselectedLabels: showUnselectedLabels,
        items: items,
        currentIndex: currentIndex,
        shape: shape,
        padding: padding,
        elevation: elevation,
        onTap: onTap,
        behaviour: behaviour,
        snakeShape: snakeShape,
        shadowColor: shadowColor,
        selectedLabelStyle: selectedLabelStyle,
        unselectedLabelStyle: unselectedLabelStyle,
        height: height ?? kBottomNavigationBarHeight,
      );

  SnakeBottomBarThemeData _createTheme(BuildContext context) {
    final theme = BottomNavigationBarTheme.of(context);
    return SnakeBottomBarThemeData(
      snakeGradient: snakeViewGradient ??
          Theme.of(context).colorScheme.secondary.toGradient,
      backgroundGradient: backgroundGradient ??
          theme.backgroundColor?.toGradient ??
          Theme.of(context).cardColor.toGradient,
      selectedItemGradient: selectedItemGradient ??
          theme.selectedItemColor?.toGradient ??
          Theme.of(context).cardColor.toGradient,
      unselectedItemGradient: unselectedItemGradient ??
          theme.unselectedItemColor?.toGradient ??
          Theme.of(context).colorScheme.secondary.toGradient,
      showSelectedLabels: showSelectedLabels,
      showUnselectedLabels: showUnselectedLabels,
      snakeShape: snakeShape,
      selectionStyle: _selectionStyle,
      selectedLabelStyle: selectedLabelStyle,
      unselectedLabelStyle: unselectedLabelStyle,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SnakeBottomBarTheme(
      data: _createTheme(context),
      child: _SnakeNavigationBar(
        padding: padding,
        elevation: elevation,
        shadowColor: shadowColor,
        shape: shape,
        behaviour: behaviour,
        items: items,
        height: height,
        notifier: SelectionNotifier(currentIndex, onTap),
      ),
    );
  }
}

class _SnakeNavigationBar extends StatelessWidget {
  final EdgeInsets padding;
  final double elevation;
  final double height;
  final Color shadowColor;
  final ShapeBorder? shape;
  final SnakeBarBehaviour behaviour;
  final List<BottomNavigationBarItem>? items;
  final SelectionNotifier notifier;

  const _SnakeNavigationBar({
    Key? key,
    required this.padding,
    required this.elevation,
    required this.shadowColor,
    required this.shape,
    required this.behaviour,
    required this.items,
    required this.notifier,
    required this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = SnakeBottomBarTheme.of(context)!;

    final List<Widget> tiles = items!
        .mapIndexed((index, item) => SnakeItemTile(
              icon:
                  notifier.currentIndex == index ? item.activeIcon : item.icon,
              label: item.label,
              position: index,
              isSelected: notifier.currentIndex == index,
              onTap: () => notifier.selectIndex(index),
            ))
        .toList();

    return AnimatedPadding(
      padding: padding,
      duration: kThemeChangeDuration,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          SafeArea(
            left: false,
            right: false,
            child: Material(
              shadowColor: shadowColor,
              elevation: elevation,
              clipBehavior: Clip.antiAlias,
              color: Colors.transparent,
              shape: shape,
              child: AnimatedContainer(
                duration: kThemeChangeDuration,
                decoration: BoxDecoration(gradient: theme.backgroundGradient),
                height: height,
                child: Stack(
                  children: [
                    SnakeView(
                      itemsCount: items!.length,
                      height: height,
                      widgetEdgePadding: padding.left + padding.right,
                      notifier: notifier,
                    ),
                    Row(children: tiles),
                  ],
                ),
              ),
            ),
          ),
          AnimatedContainer(
            height: isPinned ? MediaQuery.of(context).padding.bottom : 0,
            decoration: BoxDecoration(gradient: theme.backgroundGradient),
            duration: kThemeChangeDuration,
          ),
        ],
      ),
    );
  }

  bool get isPinned => behaviour == SnakeBarBehaviour.pinned;
}

enum SnakeBarBehaviour {
  floating,

  pinned
}

extension GradientExt on Gradient {
  Shader defaultShader(Rect bounds) =>
      createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height));
}

extension ColorExt on Color {
  Gradient get toGradient => LinearGradient(colors: [this, this]);
}

extension IndexedIterable<E> on Iterable<E> {
  Iterable<T> mapIndexed<T>(T Function(int i, E e) f) {
    var i = 0;
    return map((e) => f(i++, e));
  }
}

class SnakeItemTile extends StatelessWidget {
  final Widget? icon;
  final String? label;
  final int? position;
  final bool? isSelected;
  final VoidCallback? onTap;

  const SnakeItemTile({
    Key? key,
    this.icon,
    this.label,
    this.position,
    this.isSelected,
    this.onTap,
  }) : super(key: key);

  bool isIndicatorStyle(SnakeBottomBarThemeData theme) =>
      theme.snakeShape.type == SnakeShapeType.indicator;

  @override
  Widget build(BuildContext context) {
    final theme = SnakeBottomBarTheme.of(context)!;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.translucent,
        child: Center(
          child: Container(
            margin: theme.snakeShape.padding,
            child: () {
              if (isSelected!) {
                return theme.showSelectedLabels && label != null
                    ? _getLabeledItem(theme)
                    : _getThemedIcon(theme);
              } else {
                return theme.showUnselectedLabels && label != null
                    ? _getLabeledItem(theme)
                    : _getThemedIcon(theme);
              }
            }(),
          ),
        ),
      ),
    );
  }

  Widget _getLabeledItem(SnakeBottomBarThemeData theme) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _getThemedIcon(theme),
        const SizedBox(height: 1),
        _getThemedTitle(theme),
      ],
    );
  }

  Widget _getThemedIcon(SnakeBottomBarThemeData theme) {
    final itemGradient =
        isSelected! ? theme.selectedItemGradient : theme.unselectedItemGradient;
    final iconWidget = theme.selectionStyle == SelectionStyle.gradient
        ? ShaderMask(
            blendMode: BlendMode.srcIn,
            shaderCallback: itemGradient.defaultShader,
            child: icon,
          )
        : IconTheme(
            data: IconThemeData(color: itemGradient.colors.first),
            child: icon!,
          );

    return isIndicatorStyle(theme)
        ? Opacity(
            opacity: isSelected! ? 1 : 0.6,
            child: iconWidget,
          )
        : iconWidget;
  }

  Widget _getThemedTitle(SnakeBottomBarThemeData theme) {
    final textTheme =
        (isSelected! ? theme.selectedLabelStyle : theme.unselectedLabelStyle) ??
            const TextStyle();
    final itemGradient =
        isSelected! ? theme.selectedItemGradient : theme.unselectedItemGradient;

    final labelWidget = theme.selectionStyle == SelectionStyle.gradient
        ? ShaderMask(
            shaderCallback: itemGradient.defaultShader,
            child: Text(label ?? '',
                style: textTheme.copyWith(color: Colors.white)),
          )
        : Text(
            label ?? '',
            style: textTheme.copyWith(color: itemGradient.colors.first),
          );

    return isIndicatorStyle(theme)
        ? Opacity(
            opacity: isSelected! ? 1 : 0.6,
            child: labelWidget,
          )
        : labelWidget;
  }
}
