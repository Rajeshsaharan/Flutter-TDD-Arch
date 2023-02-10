import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/feauters/quotes/presentation/bloc/quote_block.dart';

import '../../../../injection_conatiner.dart';
import '../bloc/quote_state_bloc.dart';
import '../widget/Quote_control.dart';
import '../widget/loadingWidget.dart';
import '../widget/messageWidget.dart';
import '../widget/quoteDisplay.dart';

class QuoteWidget extends StatelessWidget {
  const QuoteWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Quote App')),
      body: bodyBuild(context),
    );
  }

  BlocProvider<QuoteBloc> bodyBuild(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<QuoteBloc>(),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              SizedBox(height: 10),
              // Top half
              BlocBuilder<QuoteBloc, QuoteState>(
                builder: (context, state) {
                  if (state is Empty) {
                    return MessageDisplay(
                      message: 'Start searching!',
                    );
                  } else if (state is IsLoading) {
                    return LoadingWidget();
                  } else if (state is Loaded) {
                    return QuoteDisplay(quote: state.quote);
                  } else if (state is Error) {
                    return MessageDisplay(
                      message: state.error,
                    );
                  } else {
                    throw Exception();
                  }
                },
              ),

              SizedBox(height: 20),
              // Bottom half
              //
              QuoteControl(),

            ],
        ),
      ),
    ));
  }
}
