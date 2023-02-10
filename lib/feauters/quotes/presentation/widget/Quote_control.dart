
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/feauters/quotes/domain/usecase/getQuote.dart';
import 'package:myapp/feauters/quotes/presentation/bloc/quote_block.dart';
import 'package:myapp/feauters/quotes/presentation/bloc/quote_event_bloc.dart';

class QuoteControl extends StatefulWidget {
  const QuoteControl({
    Key? key,
  }) : super(key: key);

  @override
  _TriviaControlsState createState() => _TriviaControlsState();
}

class _TriviaControlsState extends State<QuoteControl> {
  final controller = TextEditingController();
  late String inputStr;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Input a number',
          ),
          onChanged: (value) {
            inputStr = value;
          },
          onSubmitted: (_) {
            dispatchConcrete();
          },
        ),
        SizedBox(height: 10),
        Row(
          children: <Widget>[
            Expanded(
              child: RaisedButton(
                child: Text('Search'),
                color: Theme.of(context).accentColor,
                textTheme: ButtonTextTheme.primary,
                onPressed: dispatchConcrete,
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: RaisedButton(
                child: Text('Get random trivia'),
                onPressed: dispatchRandom,
              ),
            ),
          ],
        )
      ],
    );
  }

  void dispatchConcrete() {
    controller.clear();
    BlocProvider.of<QuoteBloc>(context)
        .add(GetQuoteFromNumber(inputStr));
  }

  void dispatchRandom() {
    controller.clear();
    BlocProvider.of<QuoteBloc>(context).add(GetQuoteFromRandomNumber());
  }
}
