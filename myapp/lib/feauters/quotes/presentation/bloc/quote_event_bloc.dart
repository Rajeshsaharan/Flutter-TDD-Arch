import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class QuoteEvent extends Equatable {
  QuoteEvent([List props = const <dynamic>[]]) : super([props]);
}

class GetQuoteFromNumber extends QuoteEvent{
  final String stringnumber;

  GetQuoteFromNumber(this.stringnumber):super([stringnumber]);

}

class GetQuoteFromRandomNumber extends QuoteEvent {}
