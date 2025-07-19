import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class CustomInteractiveViewerController {
  _CustomInteractiveViewerState? _state;

  void resetView() => _state?._resetTransform();
  void center() => _state?._center();
  void jumpTo(Offset offset) => _state?._jumpTo(offset);

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

class _CustomInteractiveViewerState extends State<CustomInteractiveViewer> {
  Offset offset = Offset.zero;
  double scale = 1.0;
  Offset? lastFocalPoint;
  double? initialScaleAtGestureStart;

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
