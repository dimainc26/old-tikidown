import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:pay/pay.dart';
import 'package:tikidown/api/payment_config.dart';

class Ads extends StatefulWidget {
  const Ads({Key? key}) : super(key: key);

  @override
  State<Ads> createState() => _AdsState();
}

class _AdsState extends State<Ads> {
  String os = Platform.operatingSystem;

  var appleButton = ApplePayButton(
    paymentConfiguration: PaymentConfiguration.fromJsonString(defaultApplePay),
    onPaymentResult: (result) => debugPrint("payment result: $result"),
    paymentItems: const [
      PaymentItem(
          amount: "0.01",
          label: "Item 1",
          status: PaymentItemStatus.final_price),
      PaymentItem(
          amount: "0.02",
          label: "Item 2",
          status: PaymentItemStatus.final_price),
    ],
    style: ApplePayButtonStyle.black,
    type: ApplePayButtonType.buy,
    width: double.infinity,
    height: 60,
    loadingIndicator: const Center(
      child: CircularProgressIndicator(),
    ),
  );

  // Google Pay

  var googleButton = GooglePayButton(
    paymentConfiguration: PaymentConfiguration.fromJsonString(defaultGooglePay),
    onPaymentResult: (result) => debugPrint("payment result: $result"),
    paymentItems: const [
      PaymentItem(
          amount: "0.03",
          label: "Total",
          status: PaymentItemStatus.final_price),
    ],
    type: GooglePayButtonType.pay,
    width: double.infinity,
    height: 60,
    loadingIndicator: const Center(
      child: CircularProgressIndicator(),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Container(
          width: Get.width,
          height: Get.height,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xff7577CC), Color(0xff4E4E74)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 90, left: 0),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(25),
                bottomRight: Radius.circular(25),
              ),
            ),
            child: Container(
                width: 40,
                height: 40,
                margin: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey, width: 2)),
                child: IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: const Icon(
                      Icons.menu,
                      size: 22,
                      color: Colors.grey,
                    ))),
          ),
        ),
        Container(
          width: Get.width,
          height: Get.height,
          margin: const EdgeInsets.only(top: 220),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 180,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(120)),
                child: const Center(
                    child: Icon(
                  Icons.monetization_on,
                  size: 150,
                  color: Colors.grey,
                )),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 60, bottom: 10),
                child: Text(
                  "FULL ACCESS",
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  "Special Offer -- 80% off!! ",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30, bottom: 10),
                child: Container(
                  width: Get.width - 160,
                  decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(50)),
                  child: Platform.isAndroid ? googleButton : appleButton,
                ),
              ),
              MaterialButton(
                onPressed: () {},
                child: const Text(
                  "Privacy Policy & Terms of Use",
                  style: TextStyle(
                      fontSize: 14,
                      decoration: TextDecoration.underline,
                      color: Colors.black),
                ),
              )
            ],
          ),
        )
      ]),
    );
  }
}
