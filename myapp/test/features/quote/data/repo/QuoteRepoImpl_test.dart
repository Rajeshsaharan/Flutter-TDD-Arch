import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:myapp/core/error/exception.dart';
import 'package:myapp/core/error/failure.dart';
import 'package:myapp/core/platform/NetworkInfo.dart';
import 'package:myapp/feauters/quotes/data/datasources/QuoteLocalDataSource.dart';
import 'package:myapp/feauters/quotes/data/datasources/QuoteRemoteDataSource.dart';
import 'package:myapp/feauters/quotes/data/model/QuoteModel.dart';
import 'package:myapp/feauters/quotes/data/repo/QuoteRepoImpl.dart';
import 'package:myapp/feauters/quotes/domain/entities/quote.dart';

class MockQuoteRemoteDataSource extends Mock implements QuoteRemoteDataSource {}

class MockQuoteLocalDataSource extends Mock implements QuoteLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late QuoteRepoImpl repo;
  late MockNetworkInfo mockNetworkInfo;
  late MockQuoteLocalDataSource mockQuoteLocalDataSource;
  late MockQuoteRemoteDataSource mockQuoteRemoteDataSource;

  setUp(() {
    mockNetworkInfo = MockNetworkInfo();
    mockQuoteLocalDataSource = MockQuoteLocalDataSource();
    mockQuoteRemoteDataSource = MockQuoteRemoteDataSource();
    repo = QuoteRepoImpl(
      quoteRemoteDataSource: mockQuoteRemoteDataSource,
      networkInfo: mockNetworkInfo,
      quoteLocalDataSource: mockQuoteLocalDataSource,
    );
  });

  group("getQuote method testing ", () {

    test("should check the device is offline or online", () {
    //arrange
    when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);

    //act
    repo.getQuote(1);

    //assert
    verify(mockNetworkInfo.isConnected);
  });

  group("device is online", () {
    setUp(() {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
    });

    final int number = 2;
    final QuoteModel quoteModel =
        QuoteModel(quote: "text", id: number, author: "rajesh j saharan");
    final Quote = quoteModel;

    test("should return data  when the call to remote server", () async {
      //act
      when(mockQuoteRemoteDataSource.getQuote(number))
          .thenAnswer((_) async => quoteModel);
      //arrange
      final result = await repo.getQuote(number);
      //assert

      verify(mockQuoteRemoteDataSource.getQuote(number));
      expect(result, Right(Quote));
    });

    test("should cache the data locally when remote call is successful",
        () async {
      //arrange
      when(mockQuoteRemoteDataSource.getQuote(number))
          .thenAnswer((_) async => quoteModel);

      //act
      await repo.getQuote(number);

      //assert
      verify(mockQuoteRemoteDataSource.getQuote(number));
      verify(mockQuoteLocalDataSource.cacheQuote(quoteModel));
    });

    test("should return Server Failure when remote call is unsuccessful",
        () async {
      //arrange
      when(mockQuoteRemoteDataSource.getQuote(number))
          .thenThrow(ServerException());

      //act
      final result = await repo.getQuote(number);

      //assert
      verify(mockQuoteRemoteDataSource.getQuote(number));
      verifyNoMoreInteractions(mockQuoteLocalDataSource);
      expect(result, left(ServerFailure()));
    });
  });

  group("device is offline", () {
    final int number = 2;
    final QuoteModel quoteModel =
        QuoteModel(quote: "text", id: number, author: "rajesh j saharan");
    final Quote = quoteModel;

    setUp(() {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
    });

    test("should return the last cache if  the internet connection error",
        () async {
      //arrage
      when(mockQuoteLocalDataSource.getlastQuote())
          .thenAnswer((_) async => quoteModel);
      //act
      final result = await repo.getQuote(number);
      //assert
      verifyNoMoreInteractions(mockQuoteRemoteDataSource);
      verify(mockQuoteLocalDataSource.getlastQuote());
      expect(result, Right(Quote));
    });

    test(
        "should return the CacheFailure if the local source throw cacheException",
        () async {
      //arrage
      when(mockQuoteLocalDataSource.getlastQuote()).thenThrow(CacheException());
      //act
      final result = await repo.getQuote(number);
      //assert
      verifyNoMoreInteractions(mockQuoteRemoteDataSource);
      verify(mockQuoteLocalDataSource.getlastQuote());
      expect(result, Left(CacheFailure()));
    });
  });

  });






//for get random trivia


  group("getRandomQuote method testing ", () {

    test("should check  the device is offline or online", () {
    //arrange
    when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);

    //act
    repo.getRandomQuote();

    //assert
    verify(mockNetworkInfo.isConnected);
  });

  group("device is online", () {
    setUp(() {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
    });


    final QuoteModel quoteModel =
        QuoteModel(quote: "text", id: 23, author: "rajesh j saharan");
    final Quote = quoteModel;

    test("should return data  when the call to remote server", () async {
      //act
      when(mockQuoteRemoteDataSource.getRandomQuote())
          .thenAnswer((_) async => quoteModel);
      //arrange
      final result = await repo.getRandomQuote();
      //assert

      verify(mockQuoteRemoteDataSource.getRandomQuote());
      expect(result, Right(Quote));
    });

    test("should cache the data locally when remote call is successful",
        () async {
      //arrange
      when(mockQuoteRemoteDataSource.getRandomQuote())
          .thenAnswer((_) async => quoteModel);

      //act
      await repo.getRandomQuote();

      //assert
      verify(mockQuoteRemoteDataSource.getRandomQuote());
      verify(mockQuoteLocalDataSource.cacheQuote(quoteModel));
    });

    test("should return Server Failure when remote call is unsuccessful",
        () async {
      //arrange
      when(mockQuoteRemoteDataSource.getRandomQuote())
          .thenThrow(ServerException());

      //act
      final result = await repo.getRandomQuote();

      //assert
      verify(mockQuoteRemoteDataSource.getRandomQuote());
      verifyNoMoreInteractions(mockQuoteLocalDataSource);
      expect(result, left(ServerFailure()));
    });
  });

  group("device is offline", () {
    final QuoteModel quoteModel =
        QuoteModel(quote: "text", id: 23, author: "rajesh j saharan");
    final Quote = quoteModel;

    setUp(() {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
    });

    test("should return the last cache if  the internet connection error",
        () async {
      //arrage
      when(mockQuoteLocalDataSource.getlastQuote())
          .thenAnswer((_) async => quoteModel);
      //act
      final result = await repo.getRandomQuote();
      //assert
      verifyNoMoreInteractions(mockQuoteRemoteDataSource);
      verify(mockQuoteLocalDataSource.getlastQuote());
      expect(result, Right(Quote));
    });

    test(
        "should return the CacheFailure if the local source throw cacheException",
        () async {
      //arrage
      when(mockQuoteLocalDataSource.getlastQuote()).thenThrow(CacheException());
      //act
      final result = await repo.getRandomQuote();
      //assert
      verifyNoMoreInteractions(mockQuoteRemoteDataSource);
      verify(mockQuoteLocalDataSource.getlastQuote());
      expect(result, Left(CacheFailure()));
    });
  });

  });



}
