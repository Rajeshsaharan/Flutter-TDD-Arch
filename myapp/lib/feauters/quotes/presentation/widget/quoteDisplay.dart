
import 'package:flutter/material.dart';
import 'package:myapp/feauters/quotes/domain/entities/quote.dart';

class QuoteDisplay extends StatelessWidget {
  final Quote quote;

  const QuoteDisplay({
    Key? key,
    required this.quote,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 3,
      child: Column(
        children: <Widget>[
          Text(
            quote.id.toString(),
            style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                child: Text(
                  quote.quote,
                  style: TextStyle(fontSize: 25),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
