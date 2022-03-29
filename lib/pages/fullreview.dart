import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:profs_and_cons/pages/revlist.dart';
import 'package:profs_and_cons/styles.dart';

class FullReview extends StatelessWidget {
  const FullReview({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Full Review Screen',
        home: Scaffold(
          appBar: AppBar(
            leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                color: Colors.black87,
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const RevList()));
                }),
            actions: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 8.0, 18.0, 8.0),
                child: Image.asset('assets/appbar-logo.png'),
              ),
            ],
            centerTitle: false,
            backgroundColor: Colors.white,
            title: const Text(
              'Profs and Cons',
              textAlign: TextAlign.left,
            ),
          ),
          body: Container(
            constraints: const BoxConstraints.expand(),
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [profName, Card(child: review)],
            ),
          ),
        ));
  }
}

Widget profName = Container(
    padding: const EdgeInsets.fromLTRB(25, 32, 25, 0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [const Text('Juan Dela Cruz', style: header)],
    ));

Widget review = Container(
    padding: const EdgeInsets.fromLTRB(25, 32, 25, 32),
    child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [ratingBar(4)]),
          SizedBox(height: 5),
          const Text('Lorem Ipsum', style: header2),
          SizedBox(height: 5),
          Wrap(
            alignment: WrapAlignment.start,
            spacing: 5,
            children: [
              const Text('Simon Garcia', style: smallText),
              const Text('1st Sem', style: smallText),
              const Text('2019-2020', style: smallText),
            ],
          ),
          SizedBox(height: 5),
          const Text(
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam placerat congue lectus, tincidunt efficitur risus posuere ut. Mauris in vehicula libero, ut pulvinar enim. Etiam bibendum condimentum lacus sit amet maximus. Ut ultrices condimentum ex.',
            style: bodyText,
          ),
          SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [const Text('Teaching Skill'), ratingBar(4)],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [const Text('Personality'), ratingBar(3)],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [const Text('Grading'), ratingBar(4)],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [const Text('Workload'), ratingBar(3)],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [const Text('Leniency'), ratingBar(5)],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [const Text('Attendance'), ratingBar(4)],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [const Text('Feedback'), ratingBar(4)],
          ),
          SizedBox(height: 5),
          Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            Wrap(spacing: 10, children: [
              DecoratedBox(
                  decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(5)),
                  child: const Padding(
                      padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                      child: Text('CSCI 115', style: buttonText))),
              DecoratedBox(
                  decoration: BoxDecoration(
                      color: Colors.yellow,
                      borderRadius: BorderRadius.circular(5)),
                  child: const Padding(
                      padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                      child: Text('CSCI 42', style: buttonText))),
            ])
          ])
        ]));

RatingBar ratingBar(double rating) {
  return RatingBar(
      initialRating: rating,
      itemSize: 20,
      direction: Axis.horizontal,
      allowHalfRating: true,
      itemCount: 5,
      ratingWidget: RatingWidget(
          full: const Icon(Icons.star, color: Colors.blue),
          half: const Icon(
            Icons.star_half,
            color: Colors.blue,
          ),
          empty: const Icon(
            Icons.star,
            color: Colors.black38,
          )),
      onRatingUpdate: (value) {}
      //   setState(() {
      //     _ratingValue = value;
      // }
      );
}
