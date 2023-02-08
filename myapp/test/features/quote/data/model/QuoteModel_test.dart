import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:myapp/feauters/quotes/data/model/QuoteModel.dart';
import 'package:myapp/feauters/quotes/domain/entities/quote.dart';

import '../../../../fixtures/fixture_quote.dart';

void main() {
  final QuoteModel quoteModel =
      QuoteModel(quote: "text", id: 2, author: "rajesh j saharan");

  test(
    'should be a subclass of Quote entity',
    () async {
      // assert
      expect(quoteModel, isA<Quote>());
    },
  );

  test('should  get return a valid model when pascsed to from json ', () async {
    final Map<String, dynamic> jsonmap = jsonDecode(Fixture("fixture.json"));
    final result = QuoteModel.fromjson(jsonmap);
    expect(result, quoteModel);
  });


  test("should get return a valid map when passed to json ", () async {
    final result = quoteModel.tojson();
    final jsonmap = {"quote": "text", "id": 2, "author": "rajesh j saharan"};
    expect(result, jsonmap);
  });
}
