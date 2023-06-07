import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:pay/pay.dart';

class Ads extends StatefulWidget {
  const Ads({Key? key}) : super(key: key);

  @override
  State<Ads> createState() => _AdsState();
}

class _AdsState extends State<Ads> {
  List<PaymentItem> _paymentItems = [PaymentItem(amount: "1euro")];

  void onGooglePayResult(paymentResult) {
    // Send the resulting Google Pay token to your server / PSP
  }

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
                    child: GooglePayButton(
                        paymentConfiguration:
                            PaymentConfiguration.fromJsonString("""
{
   "provider":"google_pay",
   "data":{
      "environment":"TEST",
      "apiVersion":2,
      "apiVersionMinor":0,
      "allowedPaymentMethods":[
         {
            "type":"CARD",
            "tokenizationSpecification":{
               "type":"PAYMENT_GATEWAY",
               "parameters":{
                  "gateway":"example",
                  "gatewayMerchantId":"gatewayMerchantId"
               }
            },
            "parameters":{
               "allowedCardNetworks":[
                  "VISA",
                  "MASTERCARD"
               ],
               "allowedAuthMethods":[
                  "PAN_ONLY",
                  "CRYPTOGRAM_3DS"
               ],
               "billingAddressRequired":true,
               "billingAddressParameters":{
                  "format":"FULL",
                  "phoneNumberRequired":true
               }
            }
         }
      ],
      "merchantInfo":{
         "merchantId":"01234567890123456789",
         "merchantName":"Example Merchant Name"
      },
      "transactionInfo":{
         "countryCode":"US",
         "currencyCode":"USD"
      }
   }
}

"""),
                        paymentItems: _paymentItems,
                        type: GooglePayButtonType.pay,
                        margin: const EdgeInsets.only(top: 15.0),
                        onPaymentResult: onGooglePayResult,
                        loadingIndicator: const Center(
                          child: CircularProgressIndicator(),
                        ))),
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
