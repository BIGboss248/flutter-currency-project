import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

Future<Currency> fetchData(String uri) async {
  final response = await http.get(Uri.parse(uri));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then retrun response body
    return Currency.fromAPI(jsonDecode(response.body)['data']);
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load Data');
  }
}

class Currency {
  // Class parameters
  double eur;
  double gbp;

  // Default constructor
  Currency({required this.eur, required this.gbp});

  // Factory constructor to return a built instance of the class
  factory Currency.fromAPI(Map<String, dynamic> data) {
    return switch (data) {
      {'EUR': double eur, 'GBP': double gbp} => Currency(eur: eur, gbp: gbp),
      _ => throw const FormatException('Failed to load Data.'),
    };
  }
}
