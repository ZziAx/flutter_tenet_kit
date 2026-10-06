import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tenet_svg_collection/tenet_svg_collection.dart';
import '../Buttons/GlowButton.dart';
import '../TextFields/PrimaryTextField.dart';
import '../builders/hover_tracker.dart';
import '../buttons/PrimaryDropDownButton.dart';
import '../containers/WithLabelContainer.dart';
import '../data/svg_collection.dart';
import '../enums/field_input_type.dart';
import '../shadow_store/shadow_store.dart';

/// Base type for fields supported by [PrimaryFormBuilder].
///
/// This class intentionally contains no common state because text and
/// dropdown fields have different configuration requirements.
sealed class PrimaryField {
  const PrimaryField();
}

/// Configuration and runtime value for a text-based form field.
class PrimaryFormField extends PrimaryField {
  PrimaryFormField({
    required this.placeholder,
    this.title,
    this.value = '',
    this.inputType = FieldInputType.string,
    this.textDirection = TextDirection.rtl,
    this.textAlign = TextAlign.right,
    this.persianDigit = true,
    this.trailingBuilder,
    this.formatters,
    this.onChanged,
    GlobalKey<PrimaryTextFieldState>? key,
  }) : key = key ?? GlobalKey<PrimaryTextFieldState>();

  /// Optional label displayed above the field.
  String? title;

  /// Placeholder displayed when the field has no value.
  final String placeholder;

  /// Current value of the field.
  ///
  /// This is mutable because the form uses the field object as its
  /// runtime value holder.
  String value;

  /// Input behavior of the text field.
  final FieldInputType inputType;

  /// Called whenever the text changes.
  final ValueChanged<String>? onChanged;

  /// Direction of the text.
  final TextDirection textDirection;

  /// Alignment of the text.
  final TextAlign textAlign;

  /// Whether Persian digits should be used.
  final bool persianDigit;

  /// Optional widget displayed at the end of the field.
  final Widget Function()? trailingBuilder;

  /// Optional input formatters.
  final List<TextInputFormatter>? formatters;

  /// Key used to access the underlying [PrimaryTextFieldState].
  final GlobalKey<PrimaryTextFieldState> key;

  /// Returns the confirmed value from the underlying text field.
  String getValue() {
    return key.currentState?.confirm() ?? value;
  }
}

/// Configuration and runtime value for a dropdown form field.
class PrimaryDropdownField extends PrimaryField {
  PrimaryDropdownField({
    required this.items,
    required this.defaultItem,
    this.textDirection = TextDirection.rtl,
    this.onChanged,
  }) : value = defaultItem;

  /// Available dropdown options.
  final List<DropdownItem> items;

  /// Initial dropdown selection.
  final DropdownItem defaultItem;

  /// Current selected value.
  DropdownItem value;

  /// Direction used by the dropdown.
  final TextDirection textDirection;

  /// Called when the selected item changes.
  final ValueChanged<DropdownItem>? onChanged;
}

/// A reusable form container supporting multiple [PrimaryField] types.
///
/// The form manages the visual layout while each field object holds its
/// current value.
class PrimaryFormBuilder extends StatelessWidget {
  const PrimaryFormBuilder({
    super.key,
    required this.title,
    required this.fields,
    this.maxHeight = 500,
    this.padding = const EdgeInsets.all(10),
    this.physics = const ClampingScrollPhysics(),
    this.onConfirmed,
    this.onCanceled,
    this.decoration,
  });

  /// Form title.
  final String title;

  /// Fields displayed by the form.
  final List<PrimaryField> fields;

  /// Maximum height of the form.
  final double maxHeight;

  final EdgeInsetsGeometry padding;

  /// Scroll behavior for the field list.
  final ScrollPhysics physics;

  /// Called when the user confirms the form.
  ///
  /// The supplied list contains the current field values.
  final ValueChanged<List<PrimaryField>>? onConfirmed;

  /// Called when the user cancels the form.
  final VoidCallback? onCanceled;

  /// Optional custom form decoration.
  final BoxDecoration? decoration;

  static const double _width = 400;
  static const double _borderRadius = 7;
  static const double _titleFontSize = 14;
  static const double _fieldSpacing = 10;
  static const double _fieldListVerticalPadding = 14;
  static const double _buttonWidth = 100;
  static const double _buttonHeight = 35;
  static const double _buttonSpacing = 10;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Center(
        child: Container(
          width: _width,
          constraints: BoxConstraints(maxHeight: maxHeight),
          padding: padding,
          decoration: decoration ?? _defaultDecoration,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _buildTitle(),
              const SizedBox(height: _fieldListVerticalPadding),
              Expanded(child: _buildFieldList()),
              const SizedBox(height: _fieldListVerticalPadding),
              _buildActions(context),
            ],
          ),
        ),
      ),
    );
  }

  /// Default appearance used when no custom decoration is supplied.
  BoxDecoration get _defaultDecoration {
    return BoxDecoration(
      color: Colors.white,
      boxShadow: ShadowStore.shadowV2,
      borderRadius: BorderRadius.circular(_borderRadius),
      border: Border.all(color: Colors.black12),
    );
  }

  Widget _buildTitle() {
    return Text(
      title,
      style: const TextStyle(
        fontFamily: 'yekan bakh',
        fontWeight: FontWeight.bold,
        fontSize: _titleFontSize,
      ),
    );
  }

  Widget _buildFieldList() {
    return SingleChildScrollView(
      physics: physics,
      child: Column(
        spacing: _fieldSpacing,
        children: [for (final field in fields) _PrimaryFieldView(field: field)],
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: _buttonHeight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        spacing: _buttonSpacing,
        children: [
          SizedBox(
            width: _buttonWidth,
            child: GlowButton(
              label: 'لغو',
              shadowColor: Colors.grey.shade50,
              backgroundColor: Colors.grey.shade100,
              color: Colors.black,
              onClicked: () {
                if (onCanceled != null) {
                  onCanceled!();
                  return;
                }

                Navigator.of(context).pop();
              },
            ),
          ),
          SizedBox(
            width: _buttonWidth,
            child: GlowButton(
              onClicked: () {
                if (onConfirmed != null) {
                  onConfirmed!(fields);
                  return;
                }

                Navigator.of(context).pop(fields);
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// Renders a single [PrimaryField].
///
/// Keeping field-specific rendering here prevents [PrimaryFormBuilder]
/// from becoming a large conditional widget.
class _PrimaryFieldView extends StatelessWidget {
  const _PrimaryFieldView({required this.field});

  final PrimaryField field;

  @override
  Widget build(BuildContext context) {
    return switch (field) {
      PrimaryFormField field => _buildTextField(field),
      PrimaryDropdownField field => _buildDropdownField(field),
    };
  }

  Widget _buildTextField(PrimaryFormField field) {
    final textField = PrimaryTextField(
      key: field.key,
      height: 25,
      placeHolder: field.placeholder,
      trailingBuilder: field.trailingBuilder,
      fontSize: 13,
      autoFocus: false,
      persianDigit: field.persianDigit,
      margin: EdgeInsets.zero,
      formatters: field.formatters,
      textAlign: field.textAlign,
      textDirection: field.textDirection,
      inputType: field.inputType,
      text: field.value,
      onFocusedOut: (value) => value,
      onChanged: (value) {
        field.value = value;
        field.onChanged?.call(value);
      },
    );

    final title = field.title;

    if (title == null || title.isEmpty) {
      return textField;
    }

    return WithLabelContainer(label: title, child: textField);
  }

  Widget _buildDropdownField(PrimaryDropdownField field) {
    return HoverTracker(
      builder: (isHovered) {
        return SizedBox(
          width: double.infinity,
          height: 30,
          child: Primarydropdown(
            alignment: OverlayAlignment.left,
            items: field.items,
            decoration: const BoxDecoration(),
            defaultItem: field.value.value,
            onSelected: (value) {
              field.value = value;
              field.onChanged?.call(value);
            },
            child: _buildDropdownChild(field: field, isHovered: isHovered),
          ),
        );
      },
    );
  }

  Widget _buildDropdownChild({
    required PrimaryDropdownField field,
    required bool isHovered,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: isHovered ? Colors.black26 : Colors.black12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        spacing: 10,
        children: [
          Text(
            field.value.value,
            textDirection: field.textDirection,
            style: const TextStyle(
              fontFamily: 'yekan bakh',
              color: Colors.black87,
              fontSize: 12,
            ),
          ),
          _buildDropdownIcon(isHovered),
        ],
      ),
    );
  }

  Widget _buildDropdownIcon(bool isHovered) {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
          boxShadow: ShadowStore.shadowV2,
          border: Border.all(
            color: isHovered ? Colors.black26 : Colors.transparent,
          ),
        ),
        child: SvgPicture.string(
          SvgCollection.arrowDown,
          color: Colors.black87,
          width: 12,
          height: 12,
        ),
      ),
    );
  }
}
