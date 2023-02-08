import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:myapp/core/platform/NetworkInfo.dart';

class MockDataChecker extends Mock implements DataConnectionChecker {}

void main() {
  late MockDataChecker mockDataChecker;
  late NetworkInfoImpl networkInfoImpl;

  setUp(() {
    mockDataChecker = MockDataChecker();
    networkInfoImpl = NetworkInfoImpl(mockDataChecker);
  });

  test("should forward the call to DataConnectionChecker.hasConnection", () {
    //arrange
    final tFutureBool = Future.value(true);
    when(mockDataChecker.hasConnection).thenAnswer((_) => tFutureBool);
    //act
    final result = networkInfoImpl.isConnected;
    //assert
    verify(mockDataChecker.hasConnection);
    expect(result, tFutureBool);
  });
}
