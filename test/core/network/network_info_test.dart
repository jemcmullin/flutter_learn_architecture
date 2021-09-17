import 'package:flutter_learn_architecture/core/network/network_info.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import './network_info_test.mocks.dart';

@GenerateMocks([InternetConnectionChecker])
void main() {
  final mockDataConnectionChecker = MockInternetConnectionChecker();
  final networkInfoImplementation = NetworkInfoImplementation(
    mockDataConnectionChecker,
  );

  group('is connected', () {
    test('should forward the call to InternetConnectionChecker.hasConnection',
        () async {
      //arrange
      final tHasConnectionFuture = Future.value(true);
      when(mockDataConnectionChecker.hasConnection)
          .thenAnswer((_) => tHasConnectionFuture);
      //act
      final result = networkInfoImplementation.isConnected;
      //assert
      verify(mockDataConnectionChecker.hasConnection);
      expect(result, tHasConnectionFuture);
    });
  });
}
