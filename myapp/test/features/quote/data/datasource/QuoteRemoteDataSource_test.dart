import 'dart:convert';
import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:myapp/core/error/exception.dart';
import 'package:myapp/feauters/quotes/data/datasources/QuoteRemoteDataSource.dart';
import 'package:myapp/feauters/quotes/data/model/QuoteModel.dart';

import '../../../../fixtures/fixture_quote.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  late MockHttpClient client;
  late QuoteRemoteDataSourceImpl quoteRemoteDataSourceImpl;

  setUp(() {
    client = MockHttpClient();
    quoteRemoteDataSourceImpl = QuoteRemoteDataSourceImpl(client: client);
  });

  group("getQuote", () {
    final number = 1;
    final QuoteModel quoteModel =
        QuoteModel.fromjson(jsonDecode(Fixture("fixture.json")));
    test("should call http client method when method  called", () {
      //arrange
      when(client.get(any, headers: anyNamed("headers")))
          .thenAnswer((_) async => http.Response(Fixture("fixture.json"), 200));

      //act
      quoteRemoteDataSourceImpl.getQuote(number);

      //assert
      verify(
        client.get(
          'https://dummyjson.com/quotes/$number',
          headers: {'Content-Type': 'application/json'},
        ),
      );
    });

    test("should return QuoteModel Model from client.get", () async {
      //arrange
      when(client.get(any, headers: anyNamed("headers")))
          .thenAnswer((_) async => http.Response(Fixture("fixture.json"), 200));

      //act
      final result = await quoteRemoteDataSourceImpl.getQuote(number);

      //assert
      expect(result, quoteModel);
    });

    test("should throw an ServerException when response code is 404", () {
      //arrange
      when(client.get(any, headers: anyNamed("headers")))
          .thenAnswer((_) async => http.Response("something went wrong", 404));
      //act
      final call = quoteRemoteDataSourceImpl.getQuote;
      //assert

      expect(() => call(number), throwsA(TypeMatcher<ServerException>()));
    });
  });

  //for getRandom Quote

  group("getRandomQuote", () {
    final random = Random(10);
    final QuoteModel quoteModel =
        QuoteModel.fromjson(jsonDecode(Fixture("fixture.json")));
    test("should call http client method when method  called", () {
      //arrange
      when(client.get(any, headers: anyNamed("headers")))
          .thenAnswer((_) async => http.Response(Fixture("fixture.json"), 200));

      //act
      quoteRemoteDataSourceImpl.getRandomQuote();

      //assert
      verify(
        client.get(
          'https://dummyjson.com/quotes/$random',
          headers: {'Content-Type': 'application/json'},
        ),
      );
    });

    test("should return QuoteModel Model from client.get", () async {
      //arrange
      when(client.get(any, headers: anyNamed("headers")))
          .thenAnswer((_) async => http.Response(Fixture("fixture.json"), 200));

      //act
      final result = await quoteRemoteDataSourceImpl.getRandomQuote();

      //assert
      expect(result, quoteModel);
    });

    test("should throw an ServerException when response code is 404", () {
      //arrange
      when(client.get(any, headers: anyNamed("headers")))
          .thenAnswer((_) async => http.Response("something went wrong", 404));
      //act
      final call = quoteRemoteDataSourceImpl.getRandomQuote;
      //assert

      expect(() => call(), throwsA(TypeMatcher<ServerException>()));
    });
  });
}
