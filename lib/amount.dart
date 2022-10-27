import 'network.dart';
import 'package:flutter/material.dart';

const apiKey = '9D20D305-1293-48BE-8F42-453273B2A23D';
const String hostURL = 'https://rest.coinapi.io/v1/exchangerate/';

class ExchangeRate {
  BuildContext context;

  ExchangeRate(
    this.context,
  );

  Future<dynamic> getExchangeRate(String coinName, String currency) async {
    NetworkHelper networkHelper = NetworkHelper(
        '$hostURL$coinName/$currency?apikey=$apiKey&invert=false', context);
    var exchangeData = await networkHelper.getData();
    print('$hostURL$coinName?apikey=$apiKey&invert=false');
    return exchangeData;
  }
}
