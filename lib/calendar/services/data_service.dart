import 'dart:async' show Future;
import 'dart:convert';
import 'dart:core';
import 'package:flutter/services.dart' show rootBundle;
import 'package:women_diary/calendar/model/event_VO.dart';
import 'package:women_diary/calendar/model/quote_VO.dart';

Future<String> loadAssets(name) async {
  return await rootBundle.loadString(name);
}

Future<List<EventVO>> loadEventData() async {
  var jsonString = await loadAssets('assets/events.json');
  List<EventVO> results = [];
  List jsonData = jsonDecode(jsonString);
  jsonData.forEach((element) {
    String dateString = element['date'];
    String name = element['name'];
    var dateArr = dateString.split("/");
    var date = new DateTime(1993, int.parse(dateArr[1]), int.parse(dateArr[0]));
    EventVO event = EventVO(date, name);
    results.add(event);
  });
  return results;
}


Future<List<QuoteVO>> loadQuoteData() async {
  var jsonString = await loadAssets('assets/quotes.json');
  List<QuoteVO> results = [];
  List jsonData = jsonDecode(jsonString);
  jsonData.forEach((element) {
    String content = element['content'];
    String author = element['author'];
    QuoteVO quote = QuoteVO(content, author);
    results.add(quote);
  });
  return results;
}