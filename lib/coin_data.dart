import 'dart:convert';

import 'package:http/http.dart' as http;

String apiKey = '?apikey=3CE46BE1-9DA2-4D6E-BC5A-1BE9A73EC957';
String coinUrl = 'https://rest.coinapi.io/v1/exchangerate';

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

class CoinData {
  Future<Map> getData(String currency) async {
    Map cryptoPrices = {};

    for (String coin in cryptoList) {
      http.Response response =
          await http.get(Uri.parse('$coinUrl/$coin/$currency$apiKey'));
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        double rate = result["rate"];
        cryptoPrices[coin] = rate.toStringAsFixed(0);
        //print(result);
      } else {
        print(response.statusCode);
        throw 'could not fetch the requested data';
      }
    }
    // print(cryptoPrices);
    return cryptoPrices;
  }
}
