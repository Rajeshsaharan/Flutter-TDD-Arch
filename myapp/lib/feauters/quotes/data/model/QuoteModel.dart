import 'package:myapp/feauters/quotes/domain/entities/quote.dart';

class QuoteModel extends Quote {
  final String quote;
  final int id;
  final String author;
  QuoteModel({required this.quote, required this.id, required this.author})
      : super(author: author, quote: quote, id: id);

  factory QuoteModel.fromjson(Map<String, dynamic> jsonmap) {
    return QuoteModel(
        quote: jsonmap["quote"], id: jsonmap["id"], author: jsonmap["author"]);
  }

  Map<String, dynamic> tojson() {
    return {"quote": quote, "id": id, "author": author};
  }
}
