import 'package:flutter/material.dart';
class TextFieldSearch extends StatelessWidget {
  final TextEditingController textEditingController;
  final ValueChanged<String> onChanged;
  final VoidCallback ?callBackClear, callBackPrefix, callBackSearch;
  final isPrefixIconVisible;
  final String hintText;
  TextFieldSearch(
      {required this.textEditingController,
        required this.onChanged,
        this.callBackClear,
        this.isPrefixIconVisible = false,
        this.callBackSearch,
        this.callBackPrefix,
        this.hintText = 'Search'});
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 40,
        margin: EdgeInsets.all(10),
        child: TextField(
            controller: textEditingController,
            onChanged: onChanged,
            textInputAction: TextInputAction.search,
            textCapitalization: TextCapitalization.words,
            style: TextStyle(fontSize: 15),
            decoration: InputDecoration(
                border: InputBorder.none,
                isCollapsed: true,
                contentPadding:
                EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
                prefixIcon: isPrefixIconVisible
                    ? IconButton(
                    icon: Icon(Icons.search, size: 20, color: Colors.blue),
                    onPressed: callBackPrefix)
                    : null,
                enabledBorder: OutlineInputBorder(
                    borderRadius:
                    const BorderRadius.all(const Radius.circular(10.0)),
                    borderSide: BorderSide(color: Colors.black)),
                focusedBorder: OutlineInputBorder(
                    borderRadius:
                    const BorderRadius.all(const Radius.circular(10.0)),
                    borderSide: BorderSide(color: Colors.blue)),
                filled: true,
                hintStyle: TextStyle(
                    fontSize: 15,
                    color: Colors.black54,
                    textBaseline: TextBaseline.alphabetic),
                hintText: hintText,
                fillColor: Colors.grey.withOpacity(0.1))));
  }
}