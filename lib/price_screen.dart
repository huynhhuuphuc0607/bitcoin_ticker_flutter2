import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'coin_data.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  CoinData coinData = CoinData();
  String bitcoinValue;
  String ethValue;
  String ltcValue;
  DropdownButton<String> getAndroidPicker() {
    List<DropdownMenuItem<String>> dropDownItems = [];
    for (String currency in currenciesList) {
      var newItem = DropdownMenuItem(
        child: Text(currency),
        value: currency,
      );
      dropDownItems.add(newItem);
    }
    return DropdownButton<String>(
        value: selectedCurrency,
        items: dropDownItems,
        onChanged: (value) {
          setState(() {});
          selectedCurrency = value;
          getData();
        });
  }

  CupertinoPicker getIOSPicker() {
    List<Widget> cupertinoPickerItems = [];
    for (String currency in currenciesList) {
      cupertinoPickerItems.add(Text(currency));
    }
    return CupertinoPicker(
        backgroundColor: Colors.lightBlue,
        itemExtent: 32.0,
        onSelectedItemChanged: (selectedIndex) {
          setState(() {
            selectedCurrency = currenciesList[selectedIndex];
            getData();
          });
        },
        children: cupertinoPickerItems);
  }

  Widget getPicker() {
    if (Platform.isAndroid)
      return getAndroidPicker();
    else if (Platform.isIOS) return getIOSPicker();
    return null;
  }

  void getData() async {
    for (int i = 0; i < cryptoList.length; i++) {
      try {
        double lastPrice =
            await coinData.getCoinData(cryptoList[i], selectedCurrency);

        setState(() {
          if (i == 0)
            bitcoinValue = lastPrice.toStringAsFixed(2);
          else if (i == 1)
            ethValue = lastPrice.toStringAsFixed(2);
          else
            ltcValue = lastPrice.toStringAsFixed(2);
        });
      } catch (e) {
        print(e);
      }
    }
  }

  Column getCryptoCards() {
    List<Widget> cryptoCards = [];
    for (int i = 0; i < cryptoList.length; i++) {
      cryptoCards.add(Padding(
        padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
        child: ExchangeCard(
            crypto: cryptoList[i],
            bitcoinValue:
                i == 0 ? bitcoinValue : (i == 1) ? ethValue : ltcValue,
            selectedCurrency: selectedCurrency),
      ));
    }
    return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch, children: cryptoCards);
  }

  String selectedCurrency = 'USD';
  @override
  void initState() {
    // TODO: implement initState
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
          getCryptoCards(),
          Container(
              height: 150.0,
              alignment: Alignment.center,
              padding: EdgeInsets.only(bottom: 30.0),
              color: Colors.lightBlue,
              child: getPicker())
        ],
      ),
    );
  }
}

class ExchangeCard extends StatelessWidget {
  ExchangeCard({this.crypto, this.selectedCurrency, this.bitcoinValue});
  final String bitcoinValue;
  final String selectedCurrency;
  final String crypto;
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.lightBlueAccent,
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
        child: Text(
          '1 $crypto = $bitcoinValue $selectedCurrency',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20.0,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
