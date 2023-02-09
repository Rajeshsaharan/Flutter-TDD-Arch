import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:myapp/core/utils/InputConvertor.dart';
import 'package:myapp/feauters/quotes/domain/entities/quote.dart';
import 'package:myapp/feauters/quotes/domain/usecase/getQuote.dart';
import 'package:myapp/feauters/quotes/domain/usecase/get_random_quote.dart';
import 'package:myapp/feauters/quotes/presentation/bloc/quote_event_bloc.dart';
import 'package:myapp/feauters/quotes/presentation/bloc/quote_state_bloc.dart';

import '../../../../core/error/failure.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';
const String INVALID_INPUT_FAILURE_MESSAGE =
    'Invalid Input - The number must be a positive integer or zero.';

class QuoteBloc extends Bloc<QuoteEvent, QuoteState> {
  final GetQuote getQuote;
  final GetRandomQuote getRandomQuote;
  final InputConvertor inputConvertor;

  QuoteBloc(
      {required this.getQuote,
      required this.getRandomQuote,
      required this.inputConvertor});

  @override
  QuoteState get initialState => Empty();

  @override
  Stream<QuoteState> mapEventToState(QuoteEvent event) async* {
    if (event is GetQuoteFromNumber) {
      final inputEither =
          inputConvertor.getunsignedIntfromString(event.stringnumber);

      yield* inputEither.fold(
        (failure) async* {
          yield Error(error: INVALID_INPUT_FAILURE_MESSAGE);
        },
        // Although the "success case" doesn't interest us with the current test,
        // we still have to handle it somehow.
        (integer) async* {
          yield IsLoading();
          final quoteorfailure = await getQuote(integer);
          yield _eitherLoadedOrErrorState(quoteorfailure);
        },
      );
    } else if(event is GetQuoteFromRandomNumber) {
      // yield IsLoading();

      final failureOrquote = await getRandomQuote(
        NoParams(),
      );
      yield _eitherLoadedOrErrorState(failureOrquote);
    }
  }
}

QuoteState _eitherLoadedOrErrorState(
  Either<Failure, Quote> either,
)  {
  return either.fold(
    (failure) => Error(error: _mapFailureToMessage(failure)),
    (quote) => Loaded(quote: quote),
  );
}

String _mapFailureToMessage(Failure failure) {
  switch (failure.runtimeType) {
    case ServerFailure:
      return SERVER_FAILURE_MESSAGE;
    case CacheFailure:
      return CACHE_FAILURE_MESSAGE;
    default:
      return 'Unexpected Error';
  }
}
