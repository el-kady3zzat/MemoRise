import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/widgets.dart' as flutter;

class CustomTextFormField extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final String label;
  final TextInputType keyboardType;

  const CustomTextFormField({
    super.key,
    required this.controller,
    required this.hint,
    required this.label,
    required this.keyboardType,
  });

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  late bool state = true;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: TextFormField(
          controller: widget.controller,
          keyboardType: widget.keyboardType,
          obscureText: (widget.keyboardType == TextInputType.visiblePassword)
              ? state
              : false,
          validator: (value) {
            if (value!.isEmpty) {
              return 'required_field'.tr;
            }
            return null;
          },
          textDirection:
              widget.controller.text.contains(RegExp(r'[\u0600-\u06FF]'))
                  ? flutter.TextDirection.rtl
                  : flutter.TextDirection.ltr,
          decoration: InputDecoration(
              suffixIcon: widget.keyboardType == TextInputType.visiblePassword
                  ? InkWell(
                      onTap: () {
                        setState(() {
                          state = !state;
                        });
                      },
                      child: state == true
                          ? Icon(
                              Icons.visibility_off_rounded,
                              color: Colors.blue[900],
                            )
                          : Icon(
                              Icons.visibility_rounded,
                              color: Colors.blue[900],
                            ))
                  : null,
              label: Text(widget.label),
              labelStyle: const TextStyle(
                  color: Color(0xb4b4b4b4),
                  fontSize: 14,
                  fontWeight: FontWeight.bold),
              fillColor: const Color(0xefefefef),
              filled: true,
              hintText: widget.hint,
              hintStyle:
                  const TextStyle(color: Color(0xb4b4b4b4), fontSize: 12),
              focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              border: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.all(Radius.circular(20))))),
    );
  }

  checkPassState(state) {
    if (state) {
      setState(() {});
    }
  }
}
