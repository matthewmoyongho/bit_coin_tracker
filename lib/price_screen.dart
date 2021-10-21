import 'dart:convert';
import 'dart:ffi';

import 'package:bit_coin_tracker/widgets/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:bit_coin_tracker/coin_data.dart';
import 'dart:io' show Platform;
import 'package:http/http.dart' as http;

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String coin;
  String currency = "USD";

  String selectedValue = "USD";
  Map coinVal = {};
  bool isWaiting = false;

  DropdownButton dropDwown() {
    List<DropdownMenuItem> currencyDropDown = [];
    for (int i = 0; i < currenciesList.length; i++) {
      var currency = DropdownMenuItem(
        child: Text(currenciesList[i]),
        value: currenciesList[i],
      );
      currencyDropDown.add(currency);
    }

    return DropdownButton(
      value: selectedValue,
      items: currencyDropDown,
      onChanged: (val) {
        setState(() {
          selectedValue = val;
          currency = selectedValue;
        });
        getData();
      },
    );
  }

  CupertinoPicker cupertinoPicker() {
    List<Widget> cupertinoItems = [];
    for (String currency in currenciesList) {
      cupertinoItems.add(Text(currency));
    }

    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32,
      onSelectedItemChanged: (index) {
        setState(() {
          selectedValue = currenciesList[index - 1];
        });
      },
      children: cupertinoItems,
    );
  }

  void getData() async {
    setState(() {
      isWaiting = true;
    });

    try {
      var data = await CoinData().getData(selectedValue);
      setState(() {
        coinVal = data;
        isWaiting = false;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
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
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CoinCard(
                currency: currency,
                coin: 'BTC',
                rate: isWaiting ? "?" : coinVal['BTC'],
              ),
              CoinCard(
                currency: currency,
                coin: 'ETC',
                rate: isWaiting ? "?" : coinVal["ETH"],
              ),
              CoinCard(
                currency: currency,
                coin: 'LTC',
                rate: isWaiting ? "?" : coinVal["LTC"],
              ),
            ],
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? cupertinoPicker() : dropDwown(),
          ),
        ],
      ),
    );
  }
}
