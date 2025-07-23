import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class CustomInteractiveViewerController {
  _CustomInteractiveViewerState? _state;

  void resetView() => _state?._resetTransform();
  void center() => _state?._center();
  void jumpTo(Offset offset) => _state?._jumpTo(offset);

  void animateTo(
    Offset targetOffset, {
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeInOut,
  }) {
    _state?._animateTo(targetOffset, duration: duration, curve: curve);
  }

  void animateZoomTo(
    double targetZoom, {
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeInOut,
  }) {
    _state?._animateZoomTo(targetZoom, duration: duration, curve: curve);
  }

  void animateZoomAndPanTo({
    required Offset targetOffset,
    required double targetZoom,
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeInOut,
  }) {
    _state?._animateZoomAndPanTo(
      targetOffset: targetOffset,
      targetZoom: targetZoom,
      duration: duration,
      curve: curve,
    );
  }

  Offset? get viewportCenter =>
      _state?._getViewportCenterInContentCoordinates();

  Size? get viewportSize => _state?._viewportSize;
  double get zoomLevel => _state?.scale ?? 1.0;
  double get mimZoomLevel => _state?.widget.minScale ?? .1;
  double get maxZoomLevel => _state?.widget.maxScale ?? 4.0;

  void _attach(_CustomInteractiveViewerState state) {
    _state = state;
  }

  void _detach() {
    _state = null;
  }
}

class CustomInteractiveViewer extends StatefulWidget {
  final Widget child;
  final double minScale;
  final double maxScale;
  final double initialScale;
  final EdgeInsets boundaryMargin;
  final bool constrained;
  final CustomInteractiveViewerController? controller;

  final Function(PointerDownEvent)? onPointerDown;
  final Function(PointerMoveEvent)? onPointerMove;
  final Function(PointerUpEvent)? onPointerUp;
  final Function(PointerHoverEvent)? onPointerHover;
  final Function(PointerCancelEvent)? onPointerCancel;
  final Function(PointerPanZoomStartEvent)? onPointerPanZoomStart;
  final Function(PointerPanZoomUpdateEvent)? onPointerPanZoomUpdate;
  final Function(PointerPanZoomEndEvent)? onPointerPanZoomEnd;
  final Function(PointerSignalEvent)? onPointerSignal;
  final HitTestBehavior behavior;

  const CustomInteractiveViewer({
    super.key,
    required this.child,
    this.minScale = 0.1,
    this.maxScale = 4.0,
    this.initialScale = 1.0,
    this.boundaryMargin = EdgeInsets.zero,
    this.constrained = true,
    this.controller,
    this.onPointerDown,
    this.onPointerMove,
    this.onPointerUp,
    this.onPointerHover,
    this.onPointerCancel,
    this.onPointerPanZoomStart,
    this.onPointerPanZoomUpdate,
    this.onPointerPanZoomEnd,
    this.onPointerSignal,
    this.behavior = HitTestBehavior.deferToChild,
  });

  @override
  State<CustomInteractiveViewer> createState() =>
      _CustomInteractiveViewerState();
}

class _CustomInteractiveViewerState extends State<CustomInteractiveViewer>
    with TickerProviderStateMixin {
  Offset offset = Offset.zero;
  double scale = 1.0;
  Offset? lastFocalPoint;
  double? initialScaleAtGestureStart;

  AnimationController? _animationController;
  Animation<Offset>? _offsetAnimation;

  AnimationController? _scaleAnimationController;
  Animation<double>? _scaleAnimation;

  AnimationController? _zoomPanController;
  Animation<Offset>? _zoomPanOffsetAnimation;
  Animation<double>? _zoomPanScaleAnimation;

  final GlobalKey _childKey = GlobalKey();
  Size? _childSize;
  Size? _viewportSize;

  bool _hasCenteredInitially = false;

  @override
  void initState() {
    super.initState();
    scale = widget.initialScale;
    widget.controller?._attach(this);
  }

  @override
  void dispose() {
    _animationController?.dispose();
    widget.controller?._detach();
    super.dispose();
  }

  void _resetTransform() {
    setState(() {
      scale = widget.initialScale;
      offset = _calculateCenteredOffset();
    });
  }

  void _center() {
    setState(() {
      offset = _calculateCenteredOffset();
    });
  }

  void _jumpTo(Offset pos) {
    setState(() {
      offset = pos;
    });
  }

  void _animateTo(
    Offset targetOffset, {
    required Duration duration,
    required Curve curve,
  }) {
    _animationController?.dispose();

    _animationController = AnimationController(vsync: this, duration: duration);

    _offsetAnimation =
        Tween<Offset>(begin: offset, end: _clampOffset(targetOffset)).animate(
          CurvedAnimation(parent: _animationController!, curve: curve),
        )..addListener(() {
          setState(() {
            offset = _offsetAnimation!.value;
          });
        });

    _animationController!.forward();
  }

  void _animateZoomTo(
    double targetZoom, {
    required Duration duration,
    required Curve curve,
  }) {
    _scaleAnimationController?.dispose();

    targetZoom = targetZoom.clamp(widget.minScale, widget.maxScale);

    _scaleAnimationController = AnimationController(
      vsync: this,
      duration: duration,
    );

    _scaleAnimation =
        Tween<double>(begin: scale, end: targetZoom).animate(
          CurvedAnimation(parent: _scaleAnimationController!, curve: curve),
        )..addListener(() {
          setState(() {
            scale = _scaleAnimation!.value;
            offset = _clampOffset(offset); // Clamp to avoid visual glitches
          });
        });

    _scaleAnimationController!.forward();
  }

  void _animateZoomAndPanTo({
    required Offset targetOffset,
    required double targetZoom,
    required Duration duration,
    required Curve curve,
  }) {
    _zoomPanController?.dispose();

    _zoomPanController = AnimationController(vsync: this, duration: duration);

    final clampedScale = targetZoom.clamp(widget.minScale, widget.maxScale);
    final clampedOffset = _clampOffset(targetOffset);

    _zoomPanOffsetAnimation = Tween<Offset>(
      begin: offset,
      end: clampedOffset,
    ).animate(CurvedAnimation(parent: _zoomPanController!, curve: curve));

    _zoomPanScaleAnimation = Tween<double>(
      begin: scale,
      end: clampedScale,
    ).animate(CurvedAnimation(parent: _zoomPanController!, curve: curve));

    _zoomPanController!.addListener(() {
      setState(() {
        scale = _zoomPanScaleAnimation!.value;
        offset = _clampOffset(_zoomPanOffsetAnimation!.value);
      });
    });

    _zoomPanController!.forward();
  }

  Offset _getViewportCenterInContentCoordinates() {
    if (_viewportSize == null) return Offset.zero;

    final centerInViewport = Offset(
      _viewportSize!.width / 2,
      _viewportSize!.height / 2,
    );

    final centerInContent = (centerInViewport - offset) / scale;

    return centerInContent;
  }

  void _onScaleStart(ScaleStartDetails details) {
    lastFocalPoint = details.focalPoint;
    initialScaleAtGestureStart = scale;
  }

  void _onScaleUpdate(ScaleUpdateDetails details) {
    final newScale = (initialScaleAtGestureStart! * details.scale).clamp(
      widget.minScale,
      widget.maxScale,
    );

    final delta = details.focalPoint - lastFocalPoint!;
    final proposedOffset = offset + delta;

    setState(() {
      scale = newScale;
      offset = _clampOffset(proposedOffset);
      lastFocalPoint = details.focalPoint;
    });
  }

  void _onPointerSignal(PointerSignalEvent event) {
    if (event is PointerScrollEvent) {
      const zoomSpeed = 0.0015;
      final zoomAmount = -event.scrollDelta.dy * zoomSpeed;
      final newScale = (scale * (1 + zoomAmount)).clamp(
        widget.minScale,
        widget.maxScale,
      );

      final focal = event.localPosition;
      final newOffset = (offset - focal) * (newScale / scale) + focal;

      setState(() {
        scale = newScale;
        offset = _clampOffset(newOffset);
      });
    }
  }

  Offset _clampOffset(Offset rawOffset) {
    if (_childSize == null || _viewportSize == null) return rawOffset;

    final scaledWidth = _childSize!.width * scale;
    final scaledHeight = _childSize!.height * scale;

    final minX =
        _viewportSize!.width - scaledWidth - widget.boundaryMargin.right;
    final maxX = widget.boundaryMargin.left;

    final minY =
        _viewportSize!.height - scaledHeight - widget.boundaryMargin.bottom;
    final maxY = widget.boundaryMargin.top;

    return Offset(
      rawOffset.dx.clamp(minX, maxX),
      rawOffset.dy.clamp(minY, maxY),
    );
  }

  Offset _calculateCenteredOffset() {
    if (_childSize == null || _viewportSize == null) return Offset.zero;

    final scaledWidth = _childSize!.width * scale;
    final scaledHeight = _childSize!.height * scale;

    final dx = (_viewportSize!.width - scaledWidth) / 2;
    final dy = (_viewportSize!.height - scaledHeight) / 2;

    return Offset(dx, dy);
  }

  void _maybeCenter() {
    if (_hasCenteredInitially || _childSize == null || _viewportSize == null) {
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && !_hasCenteredInitially) {
        setState(() {
          offset = _calculateCenteredOffset();
          _hasCenteredInitially = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        _viewportSize = Size(constraints.maxWidth, constraints.maxHeight);
        _maybeCenter();

        Widget child = _SizeReportingWidget(
          key: _childKey,
          onSizeChanged: (size) {
            if (_childSize != size) {
              setState(() {
                _childSize = size;
              });
            }
          },
          child: widget.child,
        );

        child = RepaintBoundary(
          child: Transform(
            transform: Matrix4.identity()
              ..translate(offset.dx, offset.dy)
              ..scale(scale),
            alignment: Alignment.topLeft,
            child: child,
          ),
        );

        if (widget.constrained) {
          child = SizedBox(
            width: constraints.maxWidth,
            height: constraints.maxHeight,
            child: child,
          );
        } else {
          child = UnconstrainedBox(
            clipBehavior: Clip.antiAlias,
            alignment: Alignment.topLeft,
            child: child,
          );
        }

        return Listener(
          onPointerSignal: (event) {
            _onPointerSignal(event);
            widget.onPointerSignal?.call(event);
          },
          onPointerCancel: widget.onPointerCancel,
          onPointerDown: widget.onPointerDown,
          onPointerHover: widget.onPointerHover,
          onPointerMove: widget.onPointerMove,
          onPointerPanZoomEnd: widget.onPointerPanZoomEnd,
          onPointerPanZoomStart: widget.onPointerPanZoomStart,
          onPointerPanZoomUpdate: widget.onPointerPanZoomUpdate,
          onPointerUp: widget.onPointerUp,
          behavior: widget.behavior,
          child: GestureDetector(
            onScaleStart: _onScaleStart,
            onScaleUpdate: _onScaleUpdate,
            behavior: HitTestBehavior.deferToChild,
            child: child,
          ),
        );
      },
    );
  }
}

class _SizeReportingWidget extends StatefulWidget {
  final Widget child;
  final ValueChanged<Size> onSizeChanged;

  const _SizeReportingWidget({
    required this.child,
    required this.onSizeChanged,
    super.key,
  });

  @override
  State<_SizeReportingWidget> createState() => _SizeReportingWidgetState();
}

class _SizeReportingWidgetState extends State<_SizeReportingWidget> {
  Size? _oldSize;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final newSize = context.size;
      if (newSize != null && newSize != _oldSize) {
        _oldSize = newSize;
        widget.onSizeChanged(newSize);
      }
    });

    return widget.child;
  }
}
