import 'package:flutter/material.dart';
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
import 'payment/ssl_commerz.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var _key = GlobalKey<FormState>();
  double _amount = 123;
  dynamic formData = {};

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text('SSL Commerz'),
          ),
          body: Form(
            key: _key,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextFormField(

                   keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius:
                          BorderRadius.all(Radius.circular(8.0))),
                      hintText: "Amount"
                    ),
                    validator: (value){
                     if(value.isEmpty){
                       return "Please Enter Amount";
                     }
                     return null;
                    },
                    onSaved: (value){
                     _amount = double.parse(value);
                    },
                  ),
                ),

                FlatButton(
                    onPressed: (){
                      if(_key.currentState.validate()){
                        _key.currentState.save();
                        print("Amount: $_amount");
                        var result = EasySSLCommerz(amount: _amount).payNow();
                        if (result is PlatformException) {
                          print("the response is: " + (result as PlatformException).message + " code: " + (result as PlatformException).code);
                        } else {
                          SSLCTransactionInfoModel model = result as SSLCTransactionInfoModel;
                          print("SSLCTransactionInfoModel: $model");
                        }

                      }
                    },
                    color: Colors.blue,
                    textColor: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Pay Now', style: TextStyle(fontSize: 20.0)),
                    )
                )
              ],
            ),
          )),
    );
  }


  Widget demoBody(){
    return Form(
      key: _key,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  initialValue: "tonmo6087b7560f8b5",
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius:
                        BorderRadius.all(Radius.circular(8.0))),
                    hintText: "Store ID",
                  ),
                  validator: (value) {
                    if (value.isEmpty)
                      return "Please input store id";
                    else
                      return null;
                  },
                  onSaved: (value) {
                    formData['store_id'] = value;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  initialValue: "tonmo6087b7560f8b5@ssl",
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius:
                        BorderRadius.all(Radius.circular(8.0))),
                    hintText: "Store password",
                  ),
                  validator: (value) {
                    if (value.isEmpty)
                      return "Please input store password";
                    else
                      return null;
                  },
                  onSaved: (value) {
                    formData['store_password'] = value;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  keyboardType: TextInputType.phone,
                  initialValue: "+8801776402271",
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius:
                        BorderRadius.all(Radius.circular(8.0))),
                    hintText: "Phone number",
                  ),
                  onSaved: (value) {
                    formData['phone'] = value;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  initialValue: "100",
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius:
                        BorderRadius.all(Radius.circular(8.0))),
                    hintText: "Payment amount",
                  ),
                  validator: (value) {
                    if (value.isEmpty)
                      return "Please input amount";
                    else
                      return null;
                  },
                  onSaved: (value) {
                    formData['amount'] = double.parse(value);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius:
                        BorderRadius.all(Radius.circular(8.0))),
                    hintText: "Enter multi card",
                  ),
                  onSaved: (value) {
                    formData['multicard'] = value;
                  },
                ),
              ),
              RaisedButton(
                child: Text("Pay now"),
                onPressed: () {
                  if (_key.currentState.validate()) {
                    _key.currentState.save();
                    // sslCommerzGeneralCall();
                    sslCommerzCustomizedCall();
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> sslCommerzGeneralCall() async {
    Sslcommerz sslcommerz = Sslcommerz(
        initializer: SSLCommerzInitialization(
          //Use the ipn if you have valid one, or it will fail the transaction.
          //   ipn_url: "www.ipnurl.com",
            multi_card_name: formData['multicard'],
            currency: SSLCurrencyType.BDT,
            product_category: "Food",
            sdkType: SSLCSdkType.TESTBOX,
            store_id: formData['store_id'],
            store_passwd: formData['store_password'],
            total_amount: formData['amount'],
            tran_id: "1231321321321312"));
    sslcommerz.payNow();
  }
  Future<void> sslCommerzGeneralCallx() async {
    Sslcommerz sslcommerz = Sslcommerz(
        initializer: SSLCommerzInitialization(
          //Use the ipn if you have valid one, or it will fail the transaction.
          //   ipn_url: "www.ipnurl.com",
            multi_card_name: "",
            currency: SSLCurrencyType.BDT,
            product_category: "Food",
            sdkType: SSLCSdkType.TESTBOX,
            store_id: "tonmo6087b7560f8b5",
            store_passwd: "tonmo6087b7560f8b5@ssl",
            total_amount: 123.12,
            tran_id: "1231321321321312"));
    sslcommerz.payNow();
  }

  Future<void> sslCommerzCustomizedCall() async {
    Sslcommerz sslcommerz = Sslcommerz(
        initializer: SSLCommerzInitialization(
          //Use the ipn if you have valid one, or it will fail the transaction.
          // ipn_url: "www.ipnurl.com",
            multi_card_name: formData['multicard'],
            currency: SSLCurrencyType.BDT,
            product_category: "Food",
            sdkType: SSLCSdkType.TESTBOX,
            store_id: formData['store_id'],
            store_passwd: formData['store_password'],
            total_amount: formData['amount'],
            tran_id: "1231321321321312"));
    sslcommerz
        .addEMITransactionInitializer(
        sslcemiTransactionInitializer: SSLCEMITransactionInitializer(
            emi_options: 1, emi_max_list_options: 3, emi_selected_inst: 2))
        .addShipmentInfoInitializer(
        sslcShipmentInfoInitializer: SSLCShipmentInfoInitializer(
            shipmentMethod: "yes",
            numOfItems: 5,
            shipmentDetails: ShipmentDetails(
                shipAddress1: "Ship address 1",
                shipCity: "Faridpur",
                shipCountry: "Bangladesh",
                shipName: "Ship name 1",
                shipPostCode: "7860")))
        .addCustomerInfoInitializer(
        customerInfoInitializer: SSLCCustomerInfoInitializer(
            customerName: null,
            customerEmail: null,
            customerAddress1: null,
            customerCity: null,
            customerPostCode: null,
            customerCountry: null,
            customerPhone: formData['phone']))
        .addProductInitializer(
        sslcProductInitializer:
        // ***** ssl product initializer for general product STARTS*****
        SSLCProductInitializer(
            productName: "Water Filter",
            productCategory: "Widgets",
            general: General(
                general: "General Purpose",
                productProfile: "Product Profile"))
      // ***** ssl product initializer for general product ENDS*****

      // ***** ssl product initializer for non physical goods STARTS *****
      // SSLCProductInitializer.WithNonPhysicalGoodsProfile(
      //     productName:
      //   "productName",
      //   productCategory:
      //   "productCategory",
      //   nonPhysicalGoods:
      //   NonPhysicalGoods(
      //      productProfile:
      //       "Product profile",
      //     nonPhysicalGoods:
      //     "non physical good"
      //       ))
      // ***** ssl product initializer for non physical goods ENDS *****

      // ***** ssl product initialization for travel vertices STARTS *****
      //       SSLCProductInitializer.WithTravelVerticalProfile(
      //          productName:
      //         "productName",
      //         productCategory:
      //         "productCategory",
      //         travelVertical:
      //         TravelVertical(
      //               productProfile: "productProfile",
      //               hotelName: "hotelName",
      //               lengthOfStay: "lengthOfStay",
      //               checkInTime: "checkInTime",
      //               hotelCity: "hotelCity"
      //             )
      //       )
      // ***** ssl product initialization for travel vertices ENDS *****

      // ***** ssl product initialization for physical goods STARTS *****

      // SSLCProductInitializer.WithPhysicalGoodsProfile(
      //     productName: "productName",
      //     productCategory: "productCategory",
      //     physicalGoods: PhysicalGoods(
      //         productProfile: "Product profile",
      //         physicalGoods: "non physical good"))

      // ***** ssl product initialization for physical goods ENDS *****

      // ***** ssl product initialization for telecom vertice STARTS *****
      // SSLCProductInitializer.WithTelecomVerticalProfile(
      //     productName: "productName",
      //     productCategory: "productCategory",
      //     telecomVertical: TelecomVertical(
      //         productProfile: "productProfile",
      //         productType: "productType",
      //         topUpNumber: "topUpNumber",
      //         countryTopUp: "countryTopUp"))
      // ***** ssl product initialization for telecom vertice ENDS *****
    )
        .addAdditionalInitializer(
        sslcAdditionalInitializer: SSLCAdditionalInitializer(
            valueA: "value a ",
            valueB: "value b",
            valueC: "value c",
            valueD: "value d"));
    var result = await sslcommerz.payNow();
    if (result is PlatformException) {
      print("the response is: " + result.message + " code: " + result.code);
    } else {
      SSLCTransactionInfoModel model = result;
    }
  }
}