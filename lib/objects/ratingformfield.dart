import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:profs_and_cons/styles.dart';

class RatingFormField extends FormField<double> {
  RatingFormField(
      {required Widget title,
      required FormFieldSetter<double> onSaved,
      required FormFieldValidator<double> validator,
      double initialValue = 0.0,
      bool autovalidate = false})
      : super(
            onSaved: onSaved,
            validator: validator,
            initialValue: initialValue,
            builder: (FormFieldState<double> state) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  title,
                  RatingBar.builder(
                    minRating: 1,
                    itemSize: 30,
                    itemBuilder: (context, _) =>
                        Icon(Icons.star, color: Colors.blue),
                    onRatingUpdate: (rating) {
                      state.didChange(rating);
                    },
                  )
                ],
              );
            });
}
