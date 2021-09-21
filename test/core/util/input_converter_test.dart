import 'package:dartz/dartz.dart';
import 'package:flutter_learn_architecture/core/util/input_converter.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  final inputConverter = InputConverter();

  group('stringToUnsignedInt', () {
    test('should return an integer when string represents an unsigned integer',
        () async {
      //arrange
      const str = '123';
      //act
      final result = inputConverter.stringToUnsignedInteger(str);
      //assert
      expect(result, const Right(123));
    });
    test('should return Failure when string not an integer', () async {
      //arrange
      const str = 'abc';
      //act
      final result = inputConverter.stringToUnsignedInteger(str);
      //assert
      expect(result, Left(InvalidInputFailure()));
    });
    test('should return Failure when string a negative integer', () async {
      //arrange
      const str = '-123';
      //act
      final result = inputConverter.stringToUnsignedInteger(str);
      //assert
      expect(result, Left(InvalidInputFailure()));
    });
  });
}
