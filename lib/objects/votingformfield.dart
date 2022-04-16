import 'package:flutter/material.dart';
import 'package:profs_and_cons/styles.dart';
import 'package:profs_and_cons/objects/review.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class VotingFormField extends FormField<int> {
  VotingFormField({
    required Review review,
    required FormFieldSetter<int> onSaved,
    required FormFieldValidator<int> validator,
    int initialValue = 0,
    bool autovalidate = false,
  }) : super(
            onSaved: onSaved,
            validator: validator,
            initialValue: initialValue,
            builder: (FormFieldState<int> state) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.arrow_upward),
                    onPressed: () {
                      state.didChange(review.votes + 1);
                      final collection =
                          FirebaseFirestore.instance.collection('reviews');
                      collection
                          .doc(review.id)
                          .update({'votes': review.votes})
                          .then((_) => debugPrint('Updated'))
                          .catchError(
                              (error) => debugPrint('Update Failed: $error'));
                    },
                  ),
                  Text(review.votes.toString()),
                  IconButton(
                    icon: Icon(Icons.arrow_downward),
                    onPressed: () {
                      state.didChange(review.votes - 1);
                      onSaved;
                    },
                  ),
                ],
              );
            });
}
