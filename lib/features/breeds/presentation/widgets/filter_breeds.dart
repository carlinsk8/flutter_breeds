import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/breeds_provider.dart';

class FilterBreeds extends StatefulWidget {
  const FilterBreeds({
    super.key,
  });

  @override
  FilterBreedsState createState() => FilterBreedsState();
}

class FilterBreedsState extends State<FilterBreeds> {
  final List<String> _listChip = <String>[];
  List<String> _toppings = <String>[];
  List<String> _suggestions = <String>[];
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final provider = context.read<BreedsProvider>();
      _listChip.addAll(provider.listBreed.map((e) => e.id));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ChipsInput<String>(
            values: _toppings,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: 'Search breed',
              border: OutlineInputBorder(),
            ),
            strutStyle: const StrutStyle(fontSize: 15),
            onChanged: _onChanged,
            // onSubmitted: _onSubmitted,
            chipBuilder: _chipBuilder,
            onTextChanged: _onSearchChanged,
          ),
        ),
        if (_suggestions.isNotEmpty)
          ConstrainedBox(
            constraints: const BoxConstraints(
              maxHeight: 200, // Adjust the max height as needed
            ),
            child: Container(
              margin: const EdgeInsets.only(left: 20, right: 20, top: 1),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.white),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _suggestions.length,
                itemBuilder: (BuildContext context, int index) => ToppingSuggestion(_suggestions[index],
                      onTap: _selectSuggestion),
              ),
            ),
          ),
      ],
    );

  Future<void> _onSearchChanged(String value) async {
    final List<String> results = await _suggestionCallback(value);
    setState(() {
      _suggestions = results
          .where((String topping) => !_toppings.contains(topping))
          .toList();
    });
  }

  Widget _chipBuilder(BuildContext context, String topping) => ToppingInputChip(
        topping: topping, onDeleted: _onChipDeleted, onSelected: _onChipTapped);

  void _selectSuggestion(String topping) {
    final provider = context.read<BreedsProvider>();
    FocusScope.of(context).unfocus();
    setState(() {
      _toppings.add(topping);
      provider.selectListId = _toppings;
      _suggestions = <String>[];
    });
    provider.getListImagesBreeds();
  }

  void _onChipTapped(String topping) {}

  void _onChipDeleted(String topping) {
    final provider = context.read<BreedsProvider>();
    FocusScope.of(context).unfocus();
    setState(() {
      _toppings.remove(topping);
      provider.selectListId = _toppings;
      _suggestions = <String>[];
    });
    provider.getListImagesBreeds();
  }

  // void _onSubmitted(String text) {
  //   if (text.trim().isNotEmpty) {
  //     setState(() {
  //       _toppings = <String>[..._toppings, text.trim()];
  //     });
  //   } else {
  //     _chipFocusNode.unfocus();
  //     setState(() {
  //       _toppings = <String>[];
  //     });
  //   }
  // }

  void _onChanged(List<String> data) {
    setState(() {
      _toppings = data;
    });
  }

  FutureOr<List<String>> _suggestionCallback(String text) {
    if (text.isNotEmpty) {
      return _listChip.where((String topping) => topping.toLowerCase().contains(text.toLowerCase())).toList();
    }
    return const <String>[];
  }
}

class ChipsInput<T> extends StatefulWidget {
  const ChipsInput({
    super.key,
    required this.values,
    this.decoration = const InputDecoration(),
    this.style,
    this.strutStyle,
    required this.chipBuilder,
    required this.onChanged,
    this.onChipTapped,
    this.onSubmitted,
    this.onTextChanged,
  });

  final List<T> values;
  final InputDecoration decoration;
  final TextStyle? style;
  final StrutStyle? strutStyle;

  final ValueChanged<List<T>> onChanged;
  final ValueChanged<T>? onChipTapped;
  final ValueChanged<String>? onSubmitted;
  final ValueChanged<String>? onTextChanged;

  final Widget Function(BuildContext context, T data) chipBuilder;

  @override
  ChipsInputState<T> createState() => ChipsInputState<T>();
}

class ChipsInputState<T> extends State<ChipsInput<T>> {
  @visibleForTesting
  late final ChipsInputEditingController<T> controller;

  String _previousText = '';
  TextSelection? _previousSelection;

  @override
  void initState() {
    super.initState();
    controller = ChipsInputEditingController<T>(
        <T>[...widget.values], widget.chipBuilder);
    controller.addListener(_textListener);
  }

  @override
  void dispose() {
    controller.removeListener(_textListener);
    controller.dispose();

    super.dispose();
  }

  void _textListener() {
    final String currentText = controller.text;

    if (_previousSelection != null) {
      final int currentNumber = countReplacements(currentText);
      final int previousNumber = countReplacements(_previousText);

      final int cursorEnd = _previousSelection!.extentOffset;
      final int cursorStart = _previousSelection!.baseOffset;

      final List<T> values = <T>[...widget.values];

      if (currentNumber < previousNumber && currentNumber != values.length) {
        if (cursorStart == cursorEnd) {
          values.removeRange(cursorStart - 1, cursorEnd);
        } else {
          if (cursorStart > cursorEnd) {
            values.removeRange(cursorEnd, cursorStart);
          } else {
            values.removeRange(cursorStart, cursorEnd);
          }
        }
        widget.onChanged(values);
      }
    }

    _previousText = currentText;
    _previousSelection = controller.selection;
  }

  static int countReplacements(String text) => text.codeUnits
        .where(
            (int u) => u == ChipsInputEditingController.kObjectReplacementChar)
        .length;

  @override
  Widget build(BuildContext context) {
    controller.updateValues(<T>[...widget.values]);

    return TextField(
      decoration: widget.decoration,
      minLines: 1,
      maxLines: 4,
      textInputAction: TextInputAction.done,
      style: widget.style,
      strutStyle: widget.strutStyle,
      controller: controller,
      onChanged: (String value) =>
          widget.onTextChanged?.call(controller.textWithoutReplacements),
      onSubmitted: (String value) =>
          widget.onSubmitted?.call(controller.textWithoutReplacements),
    );
  }
}

class ChipsInputEditingController<T> extends TextEditingController {
  ChipsInputEditingController(this.values, this.chipBuilder)
      : super(
            text: String.fromCharCode(kObjectReplacementChar) * values.length);

  static const int kObjectReplacementChar = 0xFFFE;

  List<T> values;

  final Widget Function(BuildContext context, T data) chipBuilder;

  void updateValues(List<T> values) {
    if (values.length != this.values.length) {
      final String char = String.fromCharCode(kObjectReplacementChar);
      final int length = values.length;
      value = TextEditingValue(
        text: char * length,
        selection: TextSelection.collapsed(offset: length),
      );
      this.values = values;
    }
  }

  String get textWithoutReplacements {
    final String char = String.fromCharCode(kObjectReplacementChar);
    return text.replaceAll(RegExp(char), '');
  }

  String get textWithReplacements => text;

  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
  }) {
    final Iterable<WidgetSpan> chipWidgets = values.map(
      (T v) => WidgetSpan(child: chipBuilder(context, v)),
    );

    return TextSpan(
      style: style,
      children: <InlineSpan>[
        ...chipWidgets,
        if (textWithoutReplacements.isNotEmpty)
          TextSpan(text: textWithoutReplacements),
      ],
    );
  }
}

class ToppingSuggestion extends StatelessWidget {
  const ToppingSuggestion(this.topping, {super.key, this.onTap});

  final String topping;
  final ValueChanged<String>? onTap;

  @override
  Widget build(BuildContext context) => ListTile(
      key: ObjectKey(topping),
      title: Text(topping),
      onTap: () => onTap?.call(topping),
    );
}

class ToppingInputChip extends StatelessWidget {
  const ToppingInputChip({
    super.key,
    required this.topping,
    required this.onDeleted,
    required this.onSelected,
  });

  final String topping;
  final ValueChanged<String> onDeleted;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) => Container(
      margin: const EdgeInsets.only(right: 3),
      child: InputChip(
        key: ObjectKey(topping),
        label: Text(topping),
        onDeleted: () => onDeleted(topping),
        onSelected: (bool value) => onSelected(topping),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        padding: const EdgeInsets.all(2),
      ),
    );
}
