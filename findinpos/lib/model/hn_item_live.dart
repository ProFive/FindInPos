import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:findinpos/model/fetch_exception.dart';
import 'package:findinpos/model/hn_item.dart';

class LiveHnItemRepository extends HnItemRepository {
  static const _baseUrl = 'https://hacker-news.firebaseio.com/v0';
  static const _itemUrl = '$_baseUrl/item';

  final _jsonCodec = const JsonCodec();

  @override
  Future<HnItem> fetch(int itemId) async {
    final response = await http.get('$_itemUrl/$itemId.json');
    final statusCode = response.statusCode;

    if (statusCode < 200 || statusCode >= 300 || response.body == null) {
      throw new FetchDataException(
          "Error while getting item [StatusCode:$statusCode]");
    }

    final Map<String, dynamic> item  = _jsonCodec.decode(response.body);

    return new HnItem.fromMap(item);
  }

}