import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;
import 'amount.dart';
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';
import 'dart:math';

class PriceScreen extends StatefulWidget {
  PriceScreen({this.amount});
  final amount;
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  FToast fToast;
  // String amount;
  ExchangeRate exchangeRate;
  var bTCExchangeRate = '?';
  var eTHExchangeRate = '?';
  var lTCExchangeRate = '?';
  String selectedCurrency = 'USD';
  var _items;
  @override
  void initState() {
    updateUI();
    super.initState();
  }

  Future<void> updateUI() async {
    exchangeRate = ExchangeRate(context);
    var btcRate = await exchangeRate.getExchangeRate('BTC', selectedCurrency);
    var ethRate = await exchangeRate.getExchangeRate('ETH', selectedCurrency);
    var ltcRate = await exchangeRate.getExchangeRate('LTC', selectedCurrency);
    print(btcRate);
    setState(() {
      if (btcRate != null) {
        var btcRawRate = btcRate;
        bTCExchangeRate = btcRawRate['rate'].toStringAsFixed(3);
        print(bTCExchangeRate);
      } else {
        print('error');
      }
      if (ltcRate != null) {
        var ltcRawRate = ltcRate;
        lTCExchangeRate = ltcRawRate['rate'].toStringAsFixed(3);
        print(lTCExchangeRate);
      } else {
        print('error');
      }
      if (ethRate != null) {
        var ethRawRate = ethRate;
        eTHExchangeRate = ethRawRate['rate'].toStringAsFixed(3);
        print(eTHExchangeRate);
      } else {
        print('error');
      }
    });
  }

  DropdownButton<String> androidDropdown() {
    List<DropdownMenuItem<String>> dropdownItems = [];
    for (String currency in currenciesList) {
      var newItem = DropdownMenuItem(
        child: Text(
          currency,
          style: TextStyle(color: Colors.white),
        ),
        value: currency,
      );
      dropdownItems.add(newItem);
    }
    return DropdownButton<String>(
      value: selectedCurrency,
      items: dropdownItems,
      onChanged: (value) {
        setState(() {
          selectedCurrency = value;
          updateUI();
        });
      },
    );
  }

  CupertinoPicker iOSPicker() {
    List<Widget> items = [];
    for (String currency in currenciesList) {
      var newItem = Text(currency);
      items.add(newItem);
    }
    return CupertinoPicker(
      magnification: 1.0,
      backgroundColor: Colors.lightBlueAccent,
      itemExtent: 32.0,
      children: items,
      onSelectedItemChanged: (selectedIndex) {
        setState(() {
          selectedCurrency = currenciesList[selectedIndex];
          updateUI();
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                ExchangeCard(
                  exchangeText: '1 BTC = $bTCExchangeRate $selectedCurrency',
                ),
                ExchangeCard(
                  exchangeText: '1 ETH = $eTHExchangeRate $selectedCurrency',
                ),
                ExchangeCard(
                  exchangeText: '1 LTC = $lTCExchangeRate $selectedCurrency',
                ),
              ]),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? iOSPicker() : androidDropdown(),
          ),
        ],
      ),
    );
  }
}

class ExchangeCard extends StatelessWidget {
  const ExchangeCard({Key key, this.exchangeText}) : super(key: key);
  final String exchangeText;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
      child: Card(
        color: Colors.lightBlueAccent,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Text(
            exchangeText,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
