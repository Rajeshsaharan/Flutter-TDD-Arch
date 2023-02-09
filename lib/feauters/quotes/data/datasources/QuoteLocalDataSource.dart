import 'dart:convert';

import 'package:myapp/core/error/exception.dart';
import 'package:myapp/feauters/quotes/data/model/QuoteModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/quote.dart';

abstract class QuoteLocalDataSource {
  Future<QuoteModel> getlastQuote();
  Future<void> cacheQuote(QuoteModel quoteModel);
}

class QuoteLocalDataStorageImpl implements QuoteLocalDataSource {
  final SharedPreferences sharedPreferences;

  QuoteLocalDataStorageImpl({required this.sharedPreferences});

  @override
  Future<QuoteModel> getlastQuote() {
    final jsonString = sharedPreferences.getString("MY_KEY");
    if (jsonString != " ") {
      return Future.value(QuoteModel.fromjson(jsonDecode(jsonString)));
    } else {
      throw CacheException();
    }
  }

  @override
  Future<bool> cacheQuote(QuoteModel quoteModel) {
    return sharedPreferences.setString(
        "MY_KEY", jsonEncode(quoteModel.tojson()));
  }
}
