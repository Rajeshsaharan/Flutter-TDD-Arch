import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:myapp/core/utils/InputConvertor.dart';

void main() {
  late InputConvertor inputConvertor;

  setUp(() {
    inputConvertor = InputConvertor();
  });

  group("getunsignedInt", () {
    test("shoukd call Input.parse on given number and return it", () {
      //arrange
      final str = "123";
      //act
      final result = inputConvertor.getunsignedIntfromString(str);

      //assert

      expect(result, Right(123));
    });

    test("should return an failure if the string is not int format", () {
      //arrange
      final str = "abc";

      //act
      final result = inputConvertor.getunsignedIntfromString(str);
      //asssert
      expect(result, Left(InvalidInputFailue()));
    });

    test("should return an Failure if the string is negative", () {
      //arrange
      final str = "-123";

      //act
      final result = inputConvertor.getunsignedIntfromString(str);

      //assert
      expect(result, Left(InvalidInputFailue()));
    });
  });
}
