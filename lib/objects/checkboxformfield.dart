import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

// class CheckBoxFormField extends FormField<bool> {
//   final bool isChecked;
//   final Widget label;
//   final void Function(bool?) onChanged;
//   CheckBoxFormField({
//     required this.isChecked,
//     required this.label,
//     required this.onChanged,
//     FormFieldValidator<bool>? validator,
//   }) : super(
//           initialValue: isChecked,
//           validator: validator,
//           builder: (field) {
//             void onChangedHandler(bool? value) {
//               field.didChange(value);
//               onChanged(value);
//             }

//             return Container(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     children: [
//                       Checkbox(
//                         value: isChecked,
//                         onChanged: onChangedHandler,
//                       ),
//                       SizedBox(
//                         width: 10,
//                       ),
//                       label,
//                     ],
//                   ),
//                   field.isValid
//                       ? Container()
//                       : Padding(
//                           padding: const EdgeInsets.only(left: 0.0),
//                           child: Text(
//                             field.errorText ?? "",
//                             style: TextStyle(
//                               color: Colors.red[700],
//                               fontSize: 13.0,
//                             ),
//                           ),
//                         ),
//                 ],
//               ),
//             );
//           },
//         );

//   @override
//   _CheckBoxFormFieldState createState() => _CheckBoxFormFieldState();
// }

// class _CheckBoxFormFieldState extends FormFieldState<bool> {
//   @override
//   CheckBoxFormField get widget => super.widget as CheckBoxFormField;

//   @override
//   void didChange(bool? value) {
//     super.didChange(value);
//   }
// }

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
              return CheckboxListTile(
                dense: state.hasError,
                title: title,
                value: state.value,
                onChanged: state.didChange,
                // subtitle: state.hasError
                //     ? Builder(
                //         builder: (BuildContext context) =>  Text(
                //           state.errorText,
                //           style: TextStyle(color: Theme.of(context).errorColor),
                //         ),
                //       )
                //     : null,
                controlAffinity: ListTileControlAffinity.leading,
              );
            });
}
