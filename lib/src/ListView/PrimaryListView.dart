import 'package:flutter/material.dart';
import '../builders/hover_tracker.dart';

/// Configuration for a single item in [PrimaryListView].
///
/// A tile can optionally contain nested [subs], allowing the list to
/// represent hierarchical data.
class PrimaryListTile {
  const PrimaryListTile(
    this.label, {
    this.key,
    this.builder,
    this.renameBuilder,
    this.onRemoved,
    this.onRenamed,
    this.onClicked,
    this.leading,
    this.subs,
    this.padding,
    this.selectedWidget,
    this.textDirection = TextDirection.rtl,
    this.selected = false,
    this.backgroundColor = Colors.white,
    this.selectedBackgroundColor = const Color(0xFFF0F0F0),
    this.hoverColor,
    this.color = Colors.black,
    this.selectedColor = Colors.black,
  });

  /// Text displayed by the tile.
  final String label;

  /// Optional wrapper around the rendered tile.
  ///
  /// This can be used to add custom layout, animation, or behavior.
  final Widget Function(Widget child)? builder;

  /// Optional builder for a rename/edit UI.
  final Widget Function(Widget child)? renameBuilder;

  /// Called when the tile is removed.
  final VoidCallback? onRemoved;

  /// Called when the tile is renamed.
  final VoidCallback? onRenamed;

  /// Called when the tile is clicked.
  final VoidCallback? onClicked;

  /// Optional leading widget.
  final Widget? leading;

  /// Nested child tiles.
  final List<PrimaryListTile>? subs;

  /// Internal tile padding.
  final EdgeInsetsGeometry? padding;

  /// Widget displayed instead of the normal tile content when selected.
  final Widget? selectedWidget;

  /// Text direction used by the label.
  final TextDirection textDirection;

  /// Whether the tile is selected.
  final bool selected;

  /// Normal background color.
  final Color backgroundColor;

  /// Background color while selected.
  final Color selectedBackgroundColor;

  /// Background color while hovered.
  final Color ? hoverColor;

  /// Normal label color.
  final Color color;

  /// Selected label color.
  final Color selectedColor;

  /// Optional key associated with the tile.
  final Key? key;
}

/// Displays a vertical list of [PrimaryListTile] items.
///
/// Supports:
/// - hover state
/// - selection state
/// - nested children
/// - custom tile builders
/// - leading widgets
/// - custom selected content
class PrimaryListView extends StatelessWidget {
  const PrimaryListView({
    super.key,
    required this.children,
  });

  final List<PrimaryListTile> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: children.map(_buildTile).toList(),
    );
  }

  Widget _buildTile(PrimaryListTile tile) {
    Widget child = Column(
      children: [
        _buildTileContent(tile),
        if (tile.subs != null && tile.subs!.isNotEmpty)
          PrimaryListView(
            children: tile.subs!,
          ),
      ],
    );

    if (tile.builder != null) {
      child = tile.builder!(child);
    }

    return KeyedSubtree(
      key: tile.key,
      child: child,
    );
  }

  Widget _buildTileContent(PrimaryListTile tile) {
    return HoverTracker(
      builder: (isHovered) {
        return GestureDetector(
          onTap: tile.onClicked,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Container(
              height: 28,
              padding: tile.padding ?? EdgeInsets.zero,
              decoration: BoxDecoration(
                color: _resolveBackgroundColor(
                  tile,
                  isHovered,
                ),
              ),
              child: _buildContent(
                tile,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildContent(PrimaryListTile tile) {
    if (tile.selected && tile.selectedWidget != null) {
      return tile.selectedWidget!;
    }

    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 5,
            ),
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                tile.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textDirection: tile.textDirection,
                style: TextStyle(
                  fontFamily: 'yekan bakh',
                  color: tile.selected
                      ? tile.selectedColor
                      : tile.color,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ),
        if (tile.leading != null)
          SizedBox.square(
            dimension: 28,
            child: tile.leading!,
          ),
      ],
    );
  }

  Color _resolveBackgroundColor(
    PrimaryListTile tile,
    bool isHovered,
  ) {
    if (tile.selected) {
      return tile.selectedBackgroundColor;
    }

    if (isHovered) {
      return tile.hoverColor??const Color(0xFFFAFAFA);
    }

    return tile.backgroundColor;
  }
}
