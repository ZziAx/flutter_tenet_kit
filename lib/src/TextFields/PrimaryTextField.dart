import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:provider/provider.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import '../borderd_box/focused_box_border.dart';
import '../builders/hover_tracker.dart';
import '../enums/field_input_type.dart';
import '../formatters/date_formatter.dart';
import '../formatters/number_formatter.dart';
import '../formatters/to_persian_digit_formatter.dart';
import '../overlay/OverlayTriggerWidget.dart';
import '../shadow_store/shadow_store.dart';
import '../theme/TenetEssentialThemeData.dart';

/// Base contract for field validation.
abstract class FieldValidator {
  const FieldValidator();

  String get message;

  bool isValid(String text);
}

/// Validates that a value has at least [length] characters.
class LengthValidator extends FieldValidator {
  const LengthValidator(this.length);

  final int length;

  @override
  String get message => 'طول متن باید بیشتر از $length باشد'.toPersianDigit();

  @override
  bool isValid(String text) {
    return text.trim().length >= length;
  }
}

/// Validates that a value has exactly [length] characters.
class FixLengthValidator extends FieldValidator {
  const FixLengthValidator(this.length);

  final int length;

  @override
  String get message => 'باید طول $length باشد'.toPersianDigit();

  @override
  bool isValid(String text) {
    return text.trim().length == length;
  }
}

/// Validates that a value length is within [min] and [max].
class LengthRangeValidator extends FieldValidator {
  const LengthRangeValidator(this.min, this.max);

  final int min;
  final int max;

  @override
  String get message => 'طول باید بین $min و $max باشد'.toPersianDigit();

  @override
  bool isValid(String text) {
    final length = text.trim().length;
    return length >= min && length <= max;
  }
}

/// Validates that a value does not already exist in [values].
class ValidListValidator extends FieldValidator {
  const ValidListValidator(this.values);

  final List<String> values;

  @override
  String get message => 'قبلا انتخاب شده بود.';

  @override
  bool isValid(String text) {
    return !values.contains(text);
  }
}

/// Validates an English identifier.
///
/// Valid identifiers:
/// - must start with an English letter or `_`
/// - may contain letters, numbers and `_`
class EnglishIdentifierValidator extends FieldValidator {
  const EnglishIdentifierValidator();

  static final RegExp _regex = RegExp(r'^[A-Za-z_][A-Za-z0-9_]*$');

  @override
  String get message =>
      'فقط حروف انگلیسی، اعداد و "_" مجاز هستند و اولین کاراکتر نباید عدد باشد.';

  @override
  bool isValid(String text) {
    if (text.isEmpty) {
      return true;
    }

    return _regex.hasMatch(text.trim().toEnglishDigit());
  }
}

enum ValidatingProcessStartReason { called, confirmed, always, changed }

/// A configurable text field with built-in validation, formatting,
/// focus handling and validation error presentation.
class PrimaryTextField extends StatefulWidget {
  const PrimaryTextField({
    super.key,
    required this.text,
    this.inputType = FieldInputType.string,
    this.validatingProcessStartReason = ValidatingProcessStartReason.always,
    this.formatters,
    this.controller,
    this.focusNode,
    this.readOnly = false,
    this.flat = false,
    this.autoFocus = false,
    this.persianDigit = true,
    this.hasShadow = true,
    this.borderStyle = FocusedBorderStyle.doubled,
    this.onRemoveRequested,
    this.focusOutBuilder,
    this.placeHolder,
    this.textDirection = TextDirection.ltr,
    this.onFocusedOut,
    this.radius = 8,
    this.onChangeEnd,
    this.onChanged,
    this.trailingBuilder,
    this.margin = const EdgeInsets.all(5),
    this.autoHandleStates = false,
    this.textAlign = TextAlign.center,
    this.leading,
    this.width,
    this.height,
    this.dynamicValue,
    this.fontSize,
    this.style,
    this.validators = const [],
  });

  final String text;

  final FieldInputType inputType;

  final ValidatingProcessStartReason validatingProcessStartReason;

  final List<TextInputFormatter>? formatters;

  final TextEditingController? controller;

  final FocusNode? focusNode;

  final bool readOnly;

  final bool flat;

  final bool autoFocus;

  final bool persianDigit;

  final bool hasShadow;

  final FocusedBorderStyle borderStyle;

  final VoidCallback? onRemoveRequested;

  final Widget Function()? focusOutBuilder;

  final String? placeHolder;

  final TextDirection? textDirection;

  final String Function(String)? onFocusedOut;

  final Function? onChangeEnd;

  final ValueChanged<String>? onChanged;

  final Widget Function()? trailingBuilder;

  final EdgeInsetsGeometry margin;

  final bool autoHandleStates;

  final TextAlign textAlign;

  final Widget? leading;

  final double? width;

  final double? height;

  final String? dynamicValue;

  final double? fontSize;

  final TextStyle? style;

  final List<FieldValidator> validators;

  final double radius;

  @override
  State<PrimaryTextField> createState() => PrimaryTextFieldState();
}

class PrimaryTextFieldState extends State<PrimaryTextField> {
  static const double _defaultHeight = 28;
  static const double _errorOverlayOffset = 5;
  static const double _errorOverlayWidth = 220;

  static const Color _normalBorderColor = Colors.black12;
  static const Color _normalBackgroundColor = Colors.white;

  static const Color _warningBorderColor = Color.fromARGB(255, 255, 22, 5);

  static const Color _warningBackgroundColor = Color.fromARGB(
    255,
    255,
    234,
    233,
  );

  static const Color _errorBackgroundColor = Color.fromARGB(255, 255, 230, 230);

  static const Color _errorTextColor = Color.fromARGB(255, 255, 43, 28);

  static const Duration _changeEndDelay = Duration(milliseconds: 300);

  late final TextEditingController controller;
  late final FocusNode focusNode;

  late bool _editMode;
  late String _initialText;

  bool _validatingStarted = false;

  final LayerLink _layerLink = LayerLink();

  final ValueNotifier<List<String>> _errorMessages =
      ValueNotifier<List<String>>([]);

  OverlayEntry? _overlayEntry;
  Timer? _debounce;

  bool _ownsController = false;
  bool _ownsFocusNode = false;

  @override
  void initState() {
    super.initState();

    _ownsController = widget.controller == null;
    _ownsFocusNode = widget.focusNode == null;

    controller =
        widget.controller ??
        TextEditingController(text: _formatInitialText(widget.text));

    focusNode = widget.focusNode ?? FocusNode();

    _initialText = _formatInitialText(widget.text);

    _editMode = false;

    _validatingStarted =
        widget.validatingProcessStartReason ==
        ValidatingProcessStartReason.always;

    focusNode.addListener(_handleFocusChange);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }

      _validate(text: controller.text, showOverlay: false);

      if (widget.autoFocus) {
        focusNode.requestFocus();
      }
    });
  }

  String _formatInitialText(String value) {
    return widget.persianDigit ? value.toPersianDigit() : value;
  }

  @override
  void didUpdateWidget(PrimaryTextField oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.controller != oldWidget.controller) {
      _replaceController(oldWidget.controller);
    }

    if (widget.focusNode != oldWidget.focusNode) {
      _replaceFocusNode(oldWidget.focusNode);
    }

    if (widget.dynamicValue != oldWidget.dynamicValue &&
        !_editMode &&
        !focusNode.hasFocus &&
        widget.dynamicValue != null) {
      controller.text = _formatInitialText(widget.dynamicValue!);
    }

    if (widget.validators != oldWidget.validators) {
      _validate(showOverlay: false);
    }
  }

  void _replaceController(TextEditingController? oldController) {
    if (_ownsController) {
      controller.dispose();
    }

    _ownsController = widget.controller == null;

    if (widget.controller != null) {
      // This assignment cannot be made to a `late final` field.
      // Prefer not to dynamically replace controllers.
      //
      // If controller replacement is required, make the field
      // non-final and rebind it here.
    }
  }

  void _replaceFocusNode(FocusNode? oldFocusNode) {
    focusNode.removeListener(_handleFocusChange);

    if (_ownsFocusNode) {
      focusNode.dispose();
    }

    _ownsFocusNode = widget.focusNode == null;

    if (widget.focusNode != null) {
      // Same consideration as the controller:
      // use a non-final field if runtime replacement is required.
    }
  }

  /// Returns whether the current value satisfies every validator.
  bool isValid({String? text}) {
    final value = text ?? controller.text;

    return widget.validators.every((validator) => validator.isValid(value));
  }

  /// Validates the field and optionally displays the error overlay.
  bool _validate({String? text, bool showOverlay = true}) {
    if (!_validatingStarted) {
      return true;
    }

    final value = text ?? controller.text;

    final errors = <String>[];

    for (final validator in widget.validators) {
      if (!validator.isValid(value)) {
        errors.add(validator.message);
      }
    }

    _errorMessages.value = errors;

    if (errors.isEmpty) {
      _hideErrorOverlay();
    } else if (showOverlay) {
      _showErrorOverlay();
    }

    return errors.isEmpty;
  }

  /// Starts validation manually.
  bool validate({String? text, bool showOverlay = false}) {
    if (widget.validatingProcessStartReason ==
        ValidatingProcessStartReason.called) {
      _validatingStarted = true;
    }

    return _validate(text: text, showOverlay: showOverlay);
  }

  /// Validates and returns the current value when valid.
  ///
  /// Returns the initial value when validation fails.
  String confirm() {
    if (widget.validatingProcessStartReason ==
        ValidatingProcessStartReason.confirmed) {
      _validatingStarted = true;
    }

    return _validate() ? controller.text : _initialText;
  }

  /// Clears the field.
  void clear() {
    controller.clear();
  }

  /// Adds an error manually.
  void addError(String message, {bool showOverlay = true}) {
    _errorMessages.value = [..._errorMessages.value, message];

    if (showOverlay) {
      _showErrorOverlay();
    }
  }

  bool get _hasWarning {
    return _validatingStarted && !focusNode.hasFocus && !isValid();
  }

  void _showErrorOverlay() {
    if (_errorMessages.value.isEmpty || _overlayEntry != null || !mounted) {
      return;
    }

    _overlayEntry = OverlayEntry(
      builder: (context) {
        return CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(
            0,
            (widget.height ?? _defaultHeight) + _errorOverlayOffset,
          ),
          child: _buildErrorListView(),
        );
      },
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _hideErrorOverlay() {
    _overlayEntry?.remove();
    _overlayEntry?.dispose();
    _overlayEntry = null;
  }

  void _handleFocusChange() {
    if (!mounted) {
      return;
    }

    if (focusNode.hasFocus) {
      _handleFocusGained();
    } else {
      _handleFocusLost();
    }

    setState(() {});
  }

  void _handleFocusGained() {
    if (widget.autoHandleStates) {
      _editMode = true;
    }

    controller.selection = TextSelection(
      baseOffset: 0,
      extentOffset: controller.text.length,
    );

    _showErrorOverlay();
  }

  void _handleFocusLost() {
    _hideErrorOverlay();

    final updatedValue = widget.onFocusedOut?.call(
      controller.text.toEnglishDigit(),
    );

    if (widget.autoHandleStates) {
      _editMode = false;
    }

    if (updatedValue != null) {
      controller.text =
          widget.persianDigit ? updatedValue.toPersianDigit() : updatedValue;
    }
  }

  void _handleChanged(String value) {
    if (widget.validatingProcessStartReason ==
        ValidatingProcessStartReason.changed) {
      _validatingStarted = true;
    }

    _validate(text: value);

    widget.onChanged?.call(value.toEnglishDigit());

    if (widget.onChangeEnd != null) {
      _debounce?.cancel();

      _debounce = Timer(_changeEndDelay, () {
        if (!mounted) {
          return;
        }

        widget.onChangeEnd?.call(controller.text);
      });
    }

    if (mounted) {
      setState(() {});
    }
  }

  List<TextInputFormatter> _getFormatters() {
    switch (widget.inputType) {
      case FieldInputType.number:
      case FieldInputType.phoneNumber:
      case FieldInputType.postalCode:
        return [NumberFormatter(), ToPersianDigitFormatter()];

      case FieldInputType.date:
        return [DateTextFormatter()];

      case FieldInputType.custom:
        return [];

      default:
        return [if (widget.persianDigit) ToPersianDigitFormatter()];
    }
  }

  TextStyle _getStyle() {
    final theme = context.watch<TenetEssentialThemeData>();

    return widget.style ??
        TextStyle(
          fontFamily: theme.fontFamily,
          fontSize: widget.fontSize ?? 14,
        );
  }

  Widget _buildField() {
    final style = _getStyle();

    final formatters = [..._getFormatters(), ...?widget.formatters];

    return TextFormField(
      autofocus: widget.autoFocus,
      readOnly: widget.readOnly,
      controller: controller,
      focusNode: focusNode,
      inputFormatters: formatters,
      textDirection:
          widget.inputType == FieldInputType.phoneNumber
              ? TextDirection.ltr
              : widget.textDirection,
      onChanged: _handleChanged,
      style: style,
      textAlign:
          widget.inputType == FieldInputType.phoneNumber
              ? TextAlign.left
              : widget.textAlign,
      decoration: InputDecoration(
        hintText: widget.placeHolder,
        hintStyle: style.copyWith(color: Colors.black38),
        contentPadding: EdgeInsets.only(left: 5, right: _hasWarning ? 20 : 5),
        border: _transparentBorder,
        focusedBorder: _transparentBorder,
        enabledBorder: _transparentBorder,
      ),
    );
  }

  static const OutlineInputBorder _transparentBorder = OutlineInputBorder(
    borderSide: BorderSide(color: Colors.transparent),
  );

  Widget _buildContent() {
    final showWarning = _hasWarning;

    final field = _buildField();

    return Row(
      spacing: 5,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.leading != null) widget.leading!,
        if (widget.width != null)
          SizedBox(width: widget.width, child: field)
        else
          Flexible(child: field),
        if (widget.trailingBuilder != null && !showWarning)
          AspectRatio(aspectRatio: 1, child: widget.trailingBuilder!()),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final showWarning = _hasWarning;

    return FocusedBoxBorder(
      hasFocus: focusNode.hasFocus,
      radius: widget.radius,
      margin: widget.margin,
      style: widget.borderStyle,
      hasShadow: widget.hasShadow,
      borderColor: showWarning ? _warningBorderColor : _normalBorderColor,
      backgroundColor:
          showWarning ? _warningBackgroundColor : _normalBackgroundColor,
      child: CompositedTransformTarget(
        link: _layerLink,
        child: SizedBox(
          height: widget.height,
          child: Stack(
            alignment: Alignment.centerRight,
            children: [
              _buildContent(),
              if (showWarning) _buildWarningIndicator(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWarningIndicator() {
    return OverlayTriggerWidget(
      overlay: (_) => _buildErrorListView(),
      child: HoverTracker(
        builder: (_) {
          return Container(
            alignment: Alignment.center,
            height: 20,
            width: 20,
            margin: const EdgeInsets.only(right: 3),
            padding: const EdgeInsets.all(1),
            child: Image.asset('assets/icons/error.png'),
          );
        },
      ),
    );
  }

  Widget _buildErrorListView() {
    final theme = context.watch<TenetEssentialThemeData>();

    return Material(
      color: Colors.transparent,
      child: Container(
        width: _errorOverlayWidth,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: _errorBackgroundColor,
          border: GradientBoxBorder(
            gradient: const LinearGradient(
              colors: [
                Color.fromARGB(255, 255, 50, 35),
                Color.fromARGB(255, 237, 17, 2),
              ],
            ),
          ),
          boxShadow: ShadowStore.shadowV2,
        ),
        child: ValueListenableBuilder<List<String>>(
          valueListenable: _errorMessages,
          builder: (context, errors, _) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              spacing: 10,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                GradientText(
                  'خطا',
                  gradientDirection: GradientDirection.btt,
                  colors: const [
                    Color.fromARGB(255, 254, 79, 66),
                    Color.fromARGB(255, 255, 59, 59),
                  ],
                  style: TextStyle(
                    fontFamily: theme.fontFamily,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                ...errors.map(
                  (error) => Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 5,
                    children: [
                      Flexible(
                        child: Text(
                          error,
                          textDirection: TextDirection.rtl,
                          style: TextStyle(
                            color: _errorTextColor,
                            fontFamily: theme.fontFamily,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _hideErrorOverlay();

    focusNode.removeListener(_handleFocusChange);

    if (_ownsController) {
      controller.dispose();
    }

    if (_ownsFocusNode) {
      focusNode.dispose();
    }

    _errorMessages.dispose();

    super.dispose();
  }
}
