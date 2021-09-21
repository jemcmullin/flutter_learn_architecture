import 'package:dartz/dartz.dart';

import '../error/failures.dart';

class InputConverter {
  Either<Failure, int> stringToUnsignedInteger(String str) {
    final convertedInteger = int.tryParse(str);
    if (convertedInteger != null && convertedInteger >= 0) {
      return Right(convertedInteger);
    } else {
      return Left(InvalidInputFailure());
    }
  }
}

class InvalidInputFailure extends Failure {}
