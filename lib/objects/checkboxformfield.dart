import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CheckboxFormField extends FormField<bool> {
  CheckboxFormField(
      {required Widget title,
      required FormFieldSetter<bool> onSaved,
      required FormFieldValidator<bool> validator,
      bool initialValue = false,
      bool autovalidate = false})
      : super(
            onSaved: onSaved,
            validator: validator,
            initialValue: initialValue,
            builder: (FormFieldState<bool> state) {
              return Column(children: [
                CheckboxListTile(
                  dense: state.hasError,
                  title: title,
                  value: state.value,
                  subtitle: state.hasError
                      ? Builder(
                          builder: (BuildContext context) => Text(
                            state.errorText ?? '',
                            style: TextStyle(color: Colors.red),
                          ),
                        )
                      : null,
                  onChanged: state.didChange,
                  controlAffinity: ListTileControlAffinity.leading,
                ),
              ]);
            });
}
