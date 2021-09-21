import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:flutter_learn_architecture/core/error/exceptions.dart';
import 'package:flutter_learn_architecture/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_learn_architecture/features/number_trivia/data/sources/number_trivia_remote_source.dart';
import './number_trivia_remote_source_test.mocks.dart';
import '../../../../fixtures/fixture_reader.dart';

@GenerateMocks([http.Client])
void main() {
  final mockHttpClient = MockHttpClient();
  final dataSource =
      NumberTriviaRemoteSourceImplementation(client: mockHttpClient);
}
