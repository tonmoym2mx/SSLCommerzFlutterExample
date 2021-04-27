import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:sslcommerz_flutter/model/SSLCAdditionalInitializer.dart';
import 'package:sslcommerz_flutter/model/SSLCCustomerInfoInitializer.dart';
import 'package:sslcommerz_flutter/model/SSLCEMITransactionInitializer.dart';
import 'package:sslcommerz_flutter/model/SSLCSdkType.dart';
import 'package:sslcommerz_flutter/model/SSLCShipmentInfoInitializer.dart';
import 'package:sslcommerz_flutter/model/SSLCTransactionInfoModel.dart';
import 'package:sslcommerz_flutter/model/SSLCommerzInitialization.dart';
import 'package:sslcommerz_flutter/model/SSLCurrencyType.dart';
import 'package:sslcommerz_flutter/model/sslproductinitilizer/General.dart';
import 'package:sslcommerz_flutter/model/sslproductinitilizer/SSLCProductInitializer.dart';
import 'package:sslcommerz_flutter/sslcommerz.dart';
import 'package:sslcommerz/payment/config.dart';




class EasySSLCommerz{
  double amount;
  String customerEmail;
  String customerPhone;
  String customerCountry;
  String customerPostCode;
  String customerCity;
  String customerAddress1;

  Sslcommerz _sslcommerz = null;


  EasySSLCommerz({@required this.amount, this.customerEmail, this.customerPhone,
      this.customerCountry, this.customerPostCode, this.customerAddress1,this.customerCity}){
    config();
  }
  void config(){
    _sslcommerz = Sslcommerz(
        initializer: SSLCommerzInitialization(
            currency: SSLCurrencyType.BDT,
            product_category: "Any",
            sdkType: SSLCommerzConfig.TYPE,
            store_id: SSLCommerzConfig.STORE_ID,
            store_passwd: SSLCommerzConfig.STORE_PASSWORD,
            total_amount: amount,
            tran_id: getRandomString(16)));

    _sslcommerz.customerInfoInitializer = SSLCCustomerInfoInitializer(customerName: null,
        customerEmail: customerEmail,
        customerAddress1: customerAddress1,
        customerCity: customerCity,
        customerPostCode: customerPostCode,
        customerCountry: customerCountry,
        customerPhone: customerPhone);

  }

  Future<dynamic>  payNow() async{
    return await _sslcommerz.payNow();
  }



  String getRandomString(int length){
    Random _rnd = Random();
    String _chars = '0123456789';
    return String.fromCharCodes(Iterable.generate(
        length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
  }


}
