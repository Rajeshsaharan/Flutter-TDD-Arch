import 'package:dartz/dartz.dart';
import "package:flutter_test/flutter_test.dart";
import 'package:mockito/mockito.dart';
import 'package:myapp/feauters/quotes/domain/entities/quote.dart';
import 'package:myapp/feauters/quotes/domain/repo/quoterepo.dart';
import 'package:myapp/feauters/quotes/domain/usecase/getQuote.dart';

class MockQuoterepo extends Mock implements QuoteRepo {}

void main() {
  late GetQuote usecase;
  late MockQuoterepo mockQuoterepo;

  setUp(() {
    mockQuoterepo = MockQuoterepo();
    usecase = GetQuote(mockQuoterepo);
  });

  final int number = 1;
  final Quote quote = Quote(quote: "text", id: 23, author: "rajesh saharan");


  test("should get quotes from repo using number", () async{

    when(mockQuoterepo.getQuote(1)).thenAnswer((_) async => Right(quote));

     final result = await usecase(number);
      // UseCase should simply return whatever was returned from the Repository
      expect(result, Right(quote));
      // Verify that the method has been called on the Repository
      verify(mockQuoterepo.getQuote(number));
      // Only the above method should be called and nothing more.

    },
    );

  }




