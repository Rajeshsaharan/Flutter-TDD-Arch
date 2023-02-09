import 'dart:ffi';

import 'package:dartz/dartz.dart';
import 'package:myapp/core/error/failure.dart';

class InputConvertor {
  Either<Failure, int> getunsignedIntfromString(String str) {
    try {
      final result = int.parse(str);
      if (result < 0) throw FormatException();
      return Right(result);
    } on FormatException {
      return Left(InvalidInputFailue());
    }
  }
}

class InvalidInputFailue extends Failure {}
