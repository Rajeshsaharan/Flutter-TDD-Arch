import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:myapp/core/error/exception.dart';
import 'package:myapp/feauters/quotes/data/datasources/QuoteLocalDataSource.dart';
import 'package:myapp/feauters/quotes/data/model/QuoteModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../fixtures/fixture_quote.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late MockSharedPreferences mockSharedPreferences;
  late QuoteLocalDataStorageImpl quoteLocalDataStorageImpl;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    quoteLocalDataStorageImpl =
        QuoteLocalDataStorageImpl(sharedPreferences: mockSharedPreferences);
  });

  group("getlastquote Method", () {
    final tQuote = QuoteModel.fromjson(jsonDecode(Fixture("fixture.json")));
    test("should return last cache stored Quote from shared prefrence",
        () async {
      //arrange
      when(mockSharedPreferences.getString(any))
          .thenReturn(Fixture('fixture.json'));

      //act
      final result = await quoteLocalDataStorageImpl.getlastQuote();

      //assert
      verify(mockSharedPreferences.getString("MY_KEY"));
      expect(result, tQuote);
    });

    test("shoudld return a CacheException when mocksharedprefrence return null",
        () {
      //arrange
      when(mockSharedPreferences.getString(any)).thenReturn(" ");

      //act
      final call = quoteLocalDataStorageImpl.getlastQuote;
      //assert

      expect(() {
        call();
      }, throwsA(TypeMatcher<CacheException>()));
    });
  });

  group("cacheQuote", () {
    final QuoteModel quoteModel =
        QuoteModel(quote: "test", id: 2, author: "rajesh j saharan");
    test("should call sharedoprefrence to store cache ", () {
      //arrange
      //nothing

      //act
      quoteLocalDataStorageImpl.cacheQuote(quoteModel);

      //assert

      verify(mockSharedPreferences.setString("MY_KEY", jsonEncode(quoteModel.tojson())));
    });
  });
}
