import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:myapp/core/error/failure.dart';
import 'package:myapp/core/utils/InputConvertor.dart';
import 'package:myapp/feauters/quotes/domain/entities/quote.dart';
import 'package:myapp/feauters/quotes/domain/usecase/getQuote.dart';
import 'package:myapp/feauters/quotes/domain/usecase/get_random_quote.dart';
import 'package:myapp/feauters/quotes/presentation/bloc/quote_block.dart';
import 'package:myapp/feauters/quotes/presentation/bloc/quote_event_bloc.dart';
import 'package:myapp/feauters/quotes/presentation/bloc/quote_state_bloc.dart';

class MockGetQuote extends Mock implements GetQuote {}

class MockGetRandomQuote extends Mock implements GetRandomQuote {}

class MockInputConvertor extends Mock implements InputConvertor {}

void main() {
  late MockGetQuote mockGetQuote;
  late MockGetRandomQuote mockGetRandomQuote;
  late MockInputConvertor mockInputConvertor;
  late QuoteBloc bloc;

  setUp(() {
    mockGetQuote = MockGetQuote();
    mockGetRandomQuote = MockGetRandomQuote();
    mockInputConvertor = MockInputConvertor();
    bloc = QuoteBloc(
        getQuote: mockGetQuote,
        getRandomQuote: mockGetRandomQuote,
        inputConvertor: mockInputConvertor);
  });

  group("intilalState", () {
    test("initila state should be empty", () {
      //arrange

      //act

      //assert
      expect(bloc.initialState, Empty());
    });
  });

  group("EventtoState method", () {
    group("GetQuoteFromNumber Event", () {
      final tStringNumber = "1";
      final tNumber = 1;
      final Quote quote =
          Quote(quote: "test", id: 1, author: "rajesh j saharan");

      test("should call the Inputconvertor to change string to valid int",
          () async* {
        //arrange
        when(mockInputConvertor.getunsignedIntfromString(tStringNumber))
            .thenReturn(Right(1));

        //act

        bloc.add(GetQuoteFromNumber(tStringNumber));
        await untilCalled(
            mockInputConvertor.getunsignedIntfromString(tStringNumber));
        //assert

        verify(mockInputConvertor.getunsignedIntfromString(tStringNumber));
      });

      test("should Emit the Error message when input is invalid input",
          () async* {
        //arrange
        when(mockInputConvertor.getunsignedIntfromString(tStringNumber))
            .thenReturn(Left(InvalidInputFailue()));

        //act
        bloc.add(GetQuoteFromNumber(tStringNumber));
        //assert later
        final expected = [Empty(), Error(error: INVALID_INPUT_FAILURE_MESSAGE)];
        expect(bloc.state, emitsInOrder(expected));
      });

      test("should call the GetQuote usecase with parsed int", () async {
        //arrange
        when(mockInputConvertor.getunsignedIntfromString(tStringNumber))
            .thenReturn(Right(tNumber));
        when(mockGetQuote(1)).thenAnswer((_) async => Right(quote));

        //act
        bloc.add(GetQuoteFromNumber(tStringNumber));
        await untilCalled(mockGetQuote(1));

        //assert
        verify(mockGetQuote(tNumber));
      });

      test("should emit the [loaded and loading] whenever data is returned",
          () async* {
        //arrange
        when(mockInputConvertor.getunsignedIntfromString(tStringNumber))
            .thenReturn(Right(tNumber));

        when(mockGetQuote(tNumber)).thenAnswer((_) async => Right(quote));

        //assert
        final expected = [Empty(), IsLoading(), Loaded(quote: quote)];
        expect(bloc.state, emitsInOrder(expected));

        //act

        bloc.add(GetQuoteFromNumber(tStringNumber));
      });

      test("should emit the [loaded , Error] whenever there are data failure",
          () async* {
        //arrange
        when(mockInputConvertor.getunsignedIntfromString(tStringNumber))
            .thenReturn(Right(tNumber));
        when(mockGetQuote(tNumber))
            .thenAnswer((_) async => Left(ServerFailure()));
        //assert later
        final expected = [
          Empty(),
          IsLoading(),
          Error(error: SERVER_FAILURE_MESSAGE)
        ];

        expect(bloc.state, emitsInOrder(expected));
        //act
        bloc.add(GetQuoteFromNumber(tStringNumber));
      });

      test(
        'should emit [Loading, Error] with a proper message for the error when getting data fails',
        () async* {
          // arrange
          when(mockInputConvertor.getunsignedIntfromString(tStringNumber))
              .thenReturn(Right(tNumber));
          when(mockGetQuote(tNumber))
              .thenAnswer((_) async => Left(CacheFailure()));
          // assert later
          final expected = [
            Empty(),
            IsLoading(),
            Error(error: CACHE_FAILURE_MESSAGE),
          ];
          expectLater(bloc.state, emitsInOrder(expected));
          // act
          bloc.add(GetQuoteFromNumber(tStringNumber));
        },
      );
    });

//for GetRandomFromNumer Event
    group('GetQuoteForRandomNumber', () {
      final tStringNumber = "1";
      final tNumber = 1;

      final quote = Quote(quote: "test", id: 2, author: "rajesh j saharan");

      test("should call  the GetRandomQuote usecase with parsed int", () async* {
        //arrange

        when(mockGetRandomQuote.call(NoParams())).thenAnswer((_) async => Right(quote));

        //assert later



        //act
        bloc.add(GetQuoteFromRandomNumber());
        await untilCalled(mockGetRandomQuote.call(NoParams()));

        //assert

        verify(mockGetRandomQuote.call(NoParams()));

      });

        test(
          'should emit [Loading, Loaded] when data is gotten successfully',
          () async* {
            // arrange
            when(mockGetRandomQuote(NoParams()))
                .thenAnswer((_) async => Right(quote));
            // assert later
            final expected = [
              Empty(),
              IsLoading(),
              Loaded(quote: quote),
            ];
            expectLater(bloc.state, emitsInOrder(expected));
            // act
            bloc.add(GetQuoteFromRandomNumber());
          },
        );

        test(
          'should  emit [Loading, Error] when getting data fails',
          () async* {
            // arrange
            when(mockGetRandomQuote(NoParams()))
                .thenAnswer((_) async => Left(ServerFailure()));
            // assert later
            final expected = [
              Empty(),
              IsLoading(),
              Error(error: SERVER_FAILURE_MESSAGE),
            ];
            expectLater(bloc.state, emitsInOrder(expected));
            // act
            bloc.add(GetQuoteFromRandomNumber());
          },
        );

        test(
          'should emit  [Loading, Error] with a proper message for the error when getting data fails',
          () async* {
            // arrange
            when(mockGetRandomQuote(NoParams()))
                .thenAnswer((_) async => Left(CacheFailure()));
            // assert later
            final expected = [
              Empty(),
              IsLoading(),
              Error(error: CACHE_FAILURE_MESSAGE),
            ];
            expectLater(bloc.state, emitsInOrder(expected));
            // act
            bloc.add(GetQuoteFromRandomNumber());
          },
        );
    });
  });
}
