import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_tenet_kit/flutter_tenet_kit.dart';
import 'package:tenet_svg_collection/tenet_svg_collection.dart';

/// Base type for fields supported by [PrimaryFormBuilder].
///
/// This class intentionally contains no common state because text and
/// dropdown fields have different configuration requirements.
class PrimaryField<T> {
  PrimaryField(this.value);
  T value;
  void setValue(T value) {
    this.value = value;
  }
}

class PrimaryCustomField<T> extends PrimaryField<T?> {
  Widget child;
  PrimaryCustomField({T? value, required this.child}) : super(value);
}

/// Configuration and runtime value for a text-based form field.
class PrimaryFormField extends PrimaryField<String> {
  PrimaryFormField({
    required this.placeholder,
    this.title,
    String value = '',
    this.inputType = FieldInputType.string,
    this.textDirection = TextDirection.rtl,
    this.textAlign = TextAlign.right,
    this.persianDigit = true,
    this.trailingBuilder,
    this.formatters,
    this.onChanged,
    GlobalKey<PrimaryTextFieldState>? key,
  }) : key = key ?? GlobalKey<PrimaryTextFieldState>(),
       super(value);

  /// Optional label displayed above the field.
  String? title;

  /// Placeholder displayed when the field has no value.
  final String placeholder;

  /// Current value of the field.
  ///
  /// This is mutable because the form uses the field object as its
  /// runtime value holder.

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
class PrimaryDropdownField extends PrimaryField<DropdownItem> {
  PrimaryDropdownField({
    required this.items,
    required this.defaultItem,
    this.textDirection = TextDirection.rtl,
    this.onChanged,
  }) : super(defaultItem);

  /// Available dropdown options.
  final List<DropdownItem> items;

  /// Initial dropdown selection.
  final DropdownItem defaultItem;

  /// Current selected value.
  // DropdownItem value;

  /// Direction used by the dropdown.
  final TextDirection textDirection;

  /// Called when the selected item changes.
  final ValueChanged<DropdownItem>? onChanged;
}

/// A reusable form container supporting multiple [PrimaryField] types.
///
/// The form manages the visual layout while each field object holds its
/// current value.
class PrimaryFormBuilder extends StatefulWidget {
  PrimaryFormBuilder({
    super.key,
    required this.title,
    required this.fields,
    this.maxHeight = 500,
    this.padding = const EdgeInsets.all(10),
    this.physics = const ClampingScrollPhysics(),
    this.onConfirmed,
    this.onCanceled,
    this.decoration,
    this.actionsWrap = false,
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

  bool actionsWrap;

  static const double _width = 400;
  static const double _borderRadius = 7;
  static const double _titleFontSize = 14;
  static const double _fieldSpacing = 10;
  static const double _fieldListVerticalPadding = 14;
  static const double _buttonWidth = 100;
  static const double _buttonHeight = 35;
  static const double _buttonSpacing = 10;

  @override
  State<PrimaryFormBuilder> createState() => _PrimaryFormBuilderState();
}

class _PrimaryFormBuilderState extends State<PrimaryFormBuilder> {
  late final List<PrimaryField> fields;
  @override
  void initState() {
    super.initState();
    fields = widget.fields;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Center(
        child: Container(
          width: PrimaryFormBuilder._width,
          constraints: BoxConstraints(maxHeight: widget.maxHeight),
          padding: widget.padding,
          decoration: widget.decoration ?? _defaultDecoration,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _buildTitle(),
              const SizedBox(
                height: PrimaryFormBuilder._fieldListVerticalPadding,
              ),
              Expanded(child: _buildFieldList()),
              const SizedBox(
                height: PrimaryFormBuilder._fieldListVerticalPadding,
              ),
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
      borderRadius: BorderRadius.circular(PrimaryFormBuilder._borderRadius),
      border: Border.all(color: Colors.black12),
    );
  }

  Widget _buildTitle() {
    return Text(
      widget.title,
      style: const TextStyle(
        fontFamily: 'yekan bakh',
        fontWeight: FontWeight.bold,
        fontSize: PrimaryFormBuilder._titleFontSize,
      ),
    );
  }

  Widget _buildFieldList() {
    return SingleChildScrollView(
      physics: widget.physics,
      child: Column(
        spacing: PrimaryFormBuilder._fieldSpacing,
        children: List.generate(fields.length, (i) {
          final field = fields[i];
          return _PrimaryFieldView(
            field: field,
            onChanged: (field) {
              fields[i].setValue(field.value);
            },
          );
        }),
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    Widget cancelButton = GlowButton(
      label: 'لغو',
      shadowColor: Colors.grey.shade50,
      backgroundColor: Colors.grey.shade100,
      color: Colors.black,
      onClicked: () {
        if (widget.onCanceled != null) {
          widget.onCanceled!();
          return;
        }

        Navigator.of(context).pop();
      },
    );

    Widget confirmButton = GlowButton(
      onClicked: () {
        if (widget.onConfirmed != null) {
          widget.onConfirmed!(fields);
          return;
        }

        Navigator.of(context).pop(fields);
      },
    );
    return SizedBox(
      width: double.infinity,
      height: PrimaryFormBuilder._buttonHeight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        spacing: PrimaryFormBuilder._buttonSpacing,
        children:
            widget.actionsWrap
                ? [
                  Flexible(flex: 1, fit: FlexFit.tight, child: cancelButton),
                  Flexible(flex: 1, fit: FlexFit.tight, child: confirmButton),
                ]
                : [
                  SizedBox(
                    width: PrimaryFormBuilder._buttonWidth,
                    child: cancelButton,
                  ),
                  SizedBox(
                    width: PrimaryFormBuilder._buttonWidth,
                    child: confirmButton,
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
  Function(PrimaryField) onChanged;
  _PrimaryFieldView({required this.field, required this.onChanged});

  final PrimaryField field;

  @override
  Widget build(BuildContext context) {
    if (field is PrimaryFormField) {
      return _buildTextField(field as PrimaryFormField);
    }
    if (field is PrimaryDropdownField) {
      return _buildDropdownField(field as PrimaryDropdownField);
    }
    if (field is PrimaryCustomField) {
      return (field as PrimaryCustomField).child;
    }

    return Container();
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
        field.setValue(value);
        field.onChanged?.call(value);
        onChanged(field);
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
            onSelected: (DropdownItem value) {
              field.setValue(value);
              field.onChanged?.call(value);
              onChanged(field);
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
