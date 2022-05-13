// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';

// class CheckboxFormField extends FormField<bool> {
//   CheckboxFormField(
//       {required Widget title,
//       required FormFieldSetter<bool> onSaved,
//       required FormFieldValidator<bool> validator,
//       bool initialValue = false,
//       bool autovalidate = false})
//       : super(
//             onSaved: onSaved,
//             validator: validator,
//             initialValue: initialValue,
//             builder: (FormFieldState<bool> state) {
//               return CheckboxListTile(
//                 dense: state.hasError,
//                 title: title,
//                 subtitle: Text(state.errorText ?? '',
//                     style: TextStyle(color: Color.fromARGB(255, 239, 108, 108))),
//                 value: state.value,
//                 onChanged: state.didChange,
//                 controlAffinity: ListTileControlAffinity.leading,
//               );
//             });
// }
