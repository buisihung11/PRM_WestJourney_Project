import 'package:flutter/material.dart';
import 'package:mobile/widgets/info_item.dart';

class Input extends StatelessWidget {
  const Input({
    Key key,
    this.initialValue,
    this.readOnly = false,
    this.isRequired = false,
    @required this.label,
    this.onSaved,
    this.validator,
    this.keyboardType,
    this.obscureText = false,
    this.minLines = 1,
    this.maxLines = 1,
  }) : super(key: key);

  final String initialValue;
  final bool readOnly;
  final bool isRequired;
  final String label;
  final Function onSaved;
  final Function validator;
  final TextInputType keyboardType;
  final bool obscureText;
  final int minLines;
  final int maxLines;
  String validateEmpty(value) {
    return value.isEmpty ? 'Please enter $label' : null;
  }

  @override
  Widget build(BuildContext context) {
    String labelText = '$label' + (isRequired == true ? "*" : "");
    return readOnly
        ? Info(
            label: label,
            content: initialValue,
          )
        : TextFormField(
            keyboardType: keyboardType,
            readOnly: readOnly,
            initialValue: initialValue,
            minLines: minLines,
            maxLines: maxLines,
            obscureText: obscureText,
            decoration: new InputDecoration(
              labelText: labelText,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey, width: 1.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue, width: 1.0),
              ),
            ),
            onSaved: onSaved,
            validator: (String value) {
              if (validator != null) {
                String validate = validator(value);
                if (validate != null) return validate;
              }
              if (isRequired) {
                return validateEmpty(value);
              }
              return null;
            },
          );
  }
}
