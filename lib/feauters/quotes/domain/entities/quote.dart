import 'package:equatable/equatable.dart'; //only for equal object
import 'package:meta/meta.dart';


class Quote extends Equatable{
  final String quote;
  final int id;
  final String author;
  Quote({required this.quote, required this.id, required this.author}):super([quote,id,author]);

}
