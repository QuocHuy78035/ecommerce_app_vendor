import 'package:flutter/material.dart';

class TextFieldCustom extends StatefulWidget {
  final String? hintText;
  final TextInputType? type;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  final bool? isPass;

  const TextFieldCustom({
    super.key,
    this.hintText,
    this.type,
    this.onChanged,
    this.validator,
    this.isPass = false
  });

  @override
  State<TextFieldCustom> createState() => _TextFieldCustomState();
}

class _TextFieldCustomState extends State<TextFieldCustom> {

  Widget icon = const Icon(Icons.visibility);
  bool isHiddenPass = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: widget.isPass == true ? isHiddenPass : false,
      validator: widget.validator,
      keyboardType: widget.type,
      onChanged: widget.onChanged,
      decoration: InputDecoration(hintText: widget.hintText, suffixIcon: widget.isPass == true ? GestureDetector(
        child: icon,
        onTap: (){
          setState(() {
            isHiddenPass = !isHiddenPass;
            isHiddenPass == true ? icon = const Icon(Icons.visibility_off) : icon = const Icon(Icons.visibility);
          });
        },
      ): null),
    );
  }
}
