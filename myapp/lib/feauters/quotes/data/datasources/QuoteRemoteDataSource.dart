import 'dart:convert';
import 'dart:math';
import 'package:flutter/painting.dart';
import 'package:myapp/core/error/exception.dart';
import 'package:myapp/feauters/quotes/data/model/QuoteModel.dart';
import '../../domain/entities/quote.dart';
import 'package:http/http.dart' as http;

abstract class QuoteRemoteDataSource {
  Future<QuoteModel> getQuote(int number);
  Future<QuoteModel> getRandomQuote();
}

class QuoteRemoteDataSourceImpl implements QuoteRemoteDataSource {
  final http.Client client;

  QuoteRemoteDataSourceImpl({required this.client});
  @override
  Future<QuoteModel> getQuote(int number) async {
    final response = await client.get('https://dummyjson.com/quotes/$number',
        headers: {'Content-Type': 'application/json'});

    if (response.statusCode == 200) {
      return QuoteModel.fromjson(jsonDecode(response.body));
    } else {
      throw ServerException();
    }
  }

  @override
  Future<QuoteModel> getRandomQuote() async{
    final random = Random(10);
      final response = await client.get('https://dummyjson.com/quotes/$random',
        headers: {'Content-Type': 'application/json'});

    if (response.statusCode == 200) {
      return QuoteModel.fromjson(jsonDecode(response.body));
    } else {
      throw ServerException();
    }
  }
  
  }

