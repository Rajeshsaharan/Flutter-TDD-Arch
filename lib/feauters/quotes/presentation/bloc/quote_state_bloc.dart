
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../domain/entities/quote.dart';

@immutable
abstract class QuoteState extends Equatable {
  QuoteState([List props = const <dynamic>[]]) : super(props);
}

class Empty extends QuoteState {}

class IsLoading extends QuoteState {}

class Loaded extends QuoteState {
  final Quote quote;

  Loaded({required this.quote}):super([quote]);
}

class Error extends QuoteState {
  final String error;

  Error({required this.error}):super([error]);
}
