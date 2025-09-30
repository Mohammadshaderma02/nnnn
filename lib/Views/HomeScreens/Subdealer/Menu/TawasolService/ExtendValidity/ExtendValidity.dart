import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/TawasolService/ExtendValidity/EVD_Wallet.dart';
import 'package:sales_app/Views/ReusableComponents/requiredText.dart';

import 'package:sales_app/blocs/TawasolServiceBlock/ExtendValidity/ExtendValidity_bloc.dart';
import 'package:sales_app/blocs/TawasolServiceBlock/ExtendValidity/ExtendValidity_state.dart';
import 'package:sales_app/blocs/TawasolServiceBlock/ExtendValidity/ExtendValidity_events.dart';

import 'package:sales_app/blocs/TawasolServiceBlock/ExtendValidityPrice/ExtendValidityPrice_bloc.dart';
import 'package:sales_app/blocs/TawasolServiceBlock/ExtendValidityPrice/ExtendValidityPrice_state.dart';
import 'package:sales_app/blocs/TawasolServiceBlock/ExtendValidityPrice/ExtendValidityPrice_events.dart';

import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../../Shared/BaseUrl.dart';
import 'package:http/http.dart' as http;
import '../TawasolServices.dart';

class ExtendValidity extends StatefulWidget {
  bool enableMsisdn;
  String  preMSISDN;
  final List<dynamic> Permessions;

  var role;
  var outDoorUserName;
  ExtendValidity({this.Permessions,this.role,this.outDoorUserName});
  @override
  _ExtendValidityState createState() => _ExtendValidityState(this.Permessions,this.role,this.outDoorUserName);
}
APP_URLS urls = new APP_URLS();
class _ExtendValidityState extends State<ExtendValidity> {
  bool enableMsisdn;
  String  preMSISDN;

  final List<dynamic> Permessions;

  var role;
  var outDoorUserName;
  _ExtendValidityState(this.Permessions,this.role,this.outDoorUserName);

  bool emptymsisdn = false;
  bool emptykitcode = false;
  bool errormsisdn = false;
  bool errorkitcode=false;
  bool isLoading=false;

  bool tawasolBalance = false;
  bool evdBalance = false;
  bool deductedWay =false;

  String paymentMethod;


  ExtendValidityBloc extendvalidityBloc;
  GetExtendValidityPriceBloc getExtendValidityPriceBloc;
  TextEditingController msisdn = TextEditingController();
  TextEditingController kitCode = TextEditingController();

  @override
  void initState() {
    super.initState();
    /* ---> Step 1 : get information for MSISDN using /Lines/extend-validity/${kitCode} it will return Price & expiryDate */
    extendvalidityBloc = BlocProvider.of<ExtendValidityBloc>(context);
    getExtendValidityPriceBloc = BlocProvider.of<GetExtendValidityPriceBloc>(context);

    if(enableMsisdn==false){
      setState(() {
        msisdn.text=preMSISDN;
      });

    }

  }

  final msg = BlocBuilder<ExtendValidityBloc,
      ExtendValidityState>(builder: (context, state) {
    if (state is ExtendValidityLoadingState) {
      return Center(child: Container(
        padding: EdgeInsets.only(bottom: 10),
        child: CircularProgressIndicator(
          valueColor:AlwaysStoppedAnimation<Color>(Color(0xFF4F2565)),
        ),
      ));
    } else {
      return Container();
    }
  });


  final msgPrice = BlocBuilder<GetExtendValidityPriceBloc,
      GetExtendValidityPriceState>(builder: (context, state) {
    if (state is GetExtendValidityPriceLoadingState) {
      return Center(child: Container(
        padding: EdgeInsets.only(bottom: 10),
        child: CircularProgressIndicator(
          valueColor:AlwaysStoppedAnimation<Color>(Color(0xFF4F2565)),
        ),
      ));
    } else {
      return Container();
    }
  });

  @override
  void dispose() {
    super.dispose();

  }


  Widget MSISDN() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: "Menu_Form.msisdn".tr().toString(),
            style: TextStyle(
              color: Color(0xff11120e),
              fontSize: 14,
              fontWeight: FontWeight.normal,
            ),
            children: <TextSpan>[
              TextSpan(
                text: ' * ',
                style: TextStyle(
                  color: Color(0xFFB10000),
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 10),
        Container(
          alignment: Alignment.centerLeft,
          height: 58,
          child: TextField(
            controller: msisdn,
            maxLength: 10,
            buildCounter: (BuildContext context, { int currentLength, int maxLength, bool isFocused }) => null,
            keyboardType: TextInputType.phone,
            style: TextStyle(color: Color(0xff11120e)),
            decoration: InputDecoration(
              enabledBorder: emptymsisdn== true || errormsisdn==true
                  ? const OutlineInputBorder(
                // width: 0.0 produces a thin "hairline" border
                borderSide: const BorderSide(
                    color: Color(0xFFB10000), width: 1.0),
              )
                  : const OutlineInputBorder(
                // width: 0.0 produces a thin "hairline" border
                borderSide: const BorderSide(
                    color: Color(0xFFD1D7E0), width: 1.0),
              ),
              border: const OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide:
                const BorderSide(color: Color(0xFF4F2565), width: 1.0),
              ),
              contentPadding: EdgeInsets.all(16),
              hintText: "Menu_Form.(079) 0000 000".tr().toString(),
              hintStyle: TextStyle(color: Color(0xFFA4B0C1), fontSize: 14),
            ),

          ),
        )
      ],
    );
  }

  Widget kitCodeFunction() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: "Menu_Form.kit_code".tr().toString(),
            style: TextStyle(
              color: Color(0xff11120e),
              fontSize: 14,
              fontWeight: FontWeight.normal,
            ),
            children: <TextSpan>[
              TextSpan(
                text: ' * ',
                style: TextStyle(
                  color: Color(0xFFB10000),
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 10),
        Container(
          alignment: Alignment.centerLeft,
          height: 58,
          child: TextField(
            controller: kitCode,
            keyboardType: TextInputType.phone,
            style: TextStyle(color: Color(0xff11120e)),
            decoration: InputDecoration(
              enabledBorder: emptykitcode== true || errorkitcode==true
                  ? const OutlineInputBorder(
                // width: 0.0 produces a thin "hairline" border
                borderSide: const BorderSide(
                    color: Color(0xFFB10000), width: 1.0),
              )
                  : const OutlineInputBorder(
                // width: 0.0 produces a thin "hairline" border
                borderSide: const BorderSide(
                    color: Color(0xFFD1D7E0), width: 1.0),
              ),
              border: const OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide:
                const BorderSide(color: Color(0xFF4F2565), width: 1.0),
              ),
              contentPadding: EdgeInsets.all(16),
              hintText: "Menu_Form.enter_kit_code".tr().toString(),
              hintStyle: TextStyle(color: Color(0xFFA4B0C1), fontSize: 14),
            ),

          ),
        )
      ],
    );
  }

  showAlertDialog(BuildContext context, arabicMessage, englishMessage) {
    Widget tryAgainButton = TextButton(
      child: Text(
        "alert.close".tr().toString(),
        style: TextStyle(
          color: Color(0xFF4f2565),
          fontSize: 16,
        ),
      ),
      onPressed: () {
        Navigator.of(context).pop();
        msisdn.clear();
        kitCode.clear();
      },
    );
    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      content: Text(
        EasyLocalization.of(context).locale == Locale("en", "US")
            ? englishMessage
            : arabicMessage,
        style: TextStyle(
          color: Colors.black,
          fontSize: 16,
        ),
      ),
      actions: [
        tryAgainButton,

      ],
    );

    // show the dialog
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
  showAlertDialogPriceError(BuildContext context, arabicMessage, englishMessage) {
    Widget tryAgainButton = TextButton(
      child: Text(
        "alert.close".tr().toString(),
        style: TextStyle(
          color: Color(0xFF4f2565),
          fontSize: 16,
        ),
      ),
      onPressed: () {
        Navigator.of(context).pop();
        msisdn.clear();
        kitCode.clear();
      },
    );
    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      content: Text(
        EasyLocalization.of(context).locale == Locale("en", "US")
            ? englishMessage
            : arabicMessage,
        style: TextStyle(
          color: Colors.black,
          fontSize: 16,
        ),
      ),
      actions: [
        tryAgainButton,

      ],
    );

    // show the dialog
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }


  Extend_Validity ()async{

    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map test = {
      "msisdn": msisdn.text, "kitCode": kitCode.text

    };

    String body = json.encode(test);
    var apiArea = urls.BASE_URL + '/Lines/extend-validity';
    final Uri url = Uri.parse(apiArea);
    prefs.getString("accessToken");
    final access = prefs.getString("accessToken");

    final response = await http.post(url, headers: {
      "content-type": "application/json",
      "Authorization": prefs.getString("accessToken")
    }, body: body,);
    int statusCode = response.statusCode;
    var data = response.request;
    print(statusCode);
    print(data);
    print(response);
    print('body: [${response.body}]');

    if(statusCode==401 ){
      print('401  error ');

      setState(() {
       // isLoading =false;
      });

    }
    if (statusCode == 200) {
      setState(() {
        isLoading=false;
      });
      print("yes");
      var result = json.decode(response.body);
      print(result);
      print('-------------------------------');
      print(result["data"]);

      if( result["status"]==0){


        showToast(
            EasyLocalization.of(context).locale == Locale("en", "US")
                ? result['message']
                : result['messageAr'],
            context: context,
            animation: StyledToastAnimation.scale,
            fullWidth: true);
        Navigator.pop(
          context,
        );
      }else{
        setState(() {
          isLoading=false;
        });
        showAlertDialogError(context,result["messageAr"], result["message"]);
      /*
        setState(() {
          isLoading =false;
        });*/

      }


      print('-------------------------------');
      print('Sucses API');
      print(urls.BASE_URL +'/Lines/extend-validity');

      return result;
    }else{
     showAlertDialogOtherERROR(context,statusCode, statusCode);

    }
  }

  showAlertDialogError(BuildContext context, arabicMessage, englishMessage) {
    AlertDialog alert = AlertDialog(
      title: Text(
        EasyLocalization.of(context).locale == Locale("en", "US")
            ? "Warning"
            : "تحذير",
      ),
      content: Text(
        EasyLocalization.of(context).locale == Locale("en", "US")
            ? englishMessage
            : arabicMessage,
        style: TextStyle(
          color: Colors.black,
          fontSize: 16,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context, true);
          },
          child: Text(
            "alert.close".tr().toString(),
            style: TextStyle(
              color: Color(0xFF4f2565),
              fontSize: 16,
            ),
          ),
        )
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showAlertDialogOtherERROR(BuildContext context, arabicMessage, englishMessage) {
    AlertDialog alert = AlertDialog(
      title: Text(
        EasyLocalization.of(context).locale == Locale("en", "US")
            ? "Warning"
            : "تحذير",
      ),
      content: Text(
        EasyLocalization.of(context).locale == Locale("en", "US")
            ? englishMessage
            : arabicMessage,
        style: TextStyle(
          color: Colors.black,
          fontSize: 16,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context, true);
          },
          child: Text(
            "alert.close".tr().toString(),
            style: TextStyle(
              color: Color(0xFF4f2565),
              fontSize: 16,
            ),
          ),
        )
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showAlertDialogPrice(BuildContext context, arabicName, englishName,price, expiryDate) {
    Widget ConfirmButton = TextButton(
      child: Text(
        EasyLocalization.of(context).locale == Locale("en", "US")
            ? 'CONFIRM'
            : 'تأكيد',
        style: TextStyle(
          color: Color(0xFF4f2565),
          fontSize: 16,
        ),
      ),

      onPressed: () {
        Navigator.of(context).pop();

 /* ---> Step 2 : call new Dialog to select deducted way if "Tawasol balance or EVD Wallet" */
        showAlertDialogDeductedWay(context);
 /* ---> Disable on 14 Nov 2024 , this is old cycle*/
        /*.............................................*/
        /*.              Extend_Validity ();          .*/
        /*.............................................*/

      },
    );
    Widget CancelButton = TextButton(
      child: Text(
        EasyLocalization.of(context).locale == Locale("en", "US")
            ? 'CANCEL'
            : 'إلغاء',
        style: TextStyle(
          color: Color(0xFF4f2565),
          fontSize: 16,
        ),
      ),

      onPressed: () {
        setState(() {
          isLoading=false;
        });
        Navigator.of(context).pop();
        msisdn.clear();
        kitCode.clear();
      },
    );

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(
        EasyLocalization.of(context).locale == Locale("en", "US")
            ? 'Confirm Deducted '
            : 'تأكيد الخصم',
        style: TextStyle(
          color: Colors.black,
          fontSize: 18,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(children: [
            Text(
              EasyLocalization.of(context).locale == Locale("en", "US")
                  ? 'Will be deducting '
                  :" سيتم خصم" ,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
            )
          ],),
          SizedBox(height: 5),
          Row(children: [
            Text(
              EasyLocalization.of(context).locale == Locale("en", "US")
                  ? price+' JD'
                  : price+' دينار' ,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            )
          ],),
          SizedBox(height: 10,),
          Row(children: [
            Text(
              EasyLocalization.of(context).locale == Locale("en", "US")
                  ? 'Kit Code Expiry Date '
                  :"تاريخ الانتهاء العبوة" ,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
            )
          ],),
          SizedBox(height: 4,),
          Row(children: [
            Text(
              EasyLocalization.of(context).locale == Locale("en", "US")
                  ? expiryDate
                  :  expiryDate ,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            )
          ],),

        ],
      ),
      actions: [
        CancelButton,
        ConfirmButton,

      ],
    );

    // show the dialog
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showAlertDialogDeductedWay(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            Widget SelectButton = TextButton(
              child: Text(
                EasyLocalization.of(context).locale == Locale("en", "US")
                    ? 'SELECT'
                    : 'تحديد',
                style: TextStyle(
                  color: Color(0xFF4f2565),
                  fontSize: 16,
                ),
              ),
              onPressed: () async{
                if (!tawasolBalance && !evdBalance) {
                  setState(() {
                    deductedWay = true;
                    isLoading=false;
                  });
                }
                if (tawasolBalance) {
                  /* ---> Step 3 : call API /Lines/extend-validity*/
                   Extend_Validity ();
                  setState(() {
                    isLoading = true;
                    deductedWay = false;
                  });
                  Navigator.of(context).pop();
                }
                if (evdBalance) {
                  print("yes evdBalance");
                  /* ---> Step 4 : Rout to EVD Wallet screen  */
                  setState(() {
                    isLoading = false;
                    deductedWay = false;
                    paymentMethod="evdBalance";
                  });
                  Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          EVD_Wallet(Permessions: Permessions,msisdn:msisdn.text,kitCode:kitCode.text,paymentMethod:paymentMethod),
                    ),
                  );

                }
              },
            );
            Widget cancelButton = TextButton(
              child: Text(
                EasyLocalization.of(context).locale == Locale("en", "US")
                    ? 'CANCEL'
                    : 'إلغاء',
                style: TextStyle(
                  color: Color(0xFF4f2565),
                  fontSize: 16,
                ),
              ),
              onPressed: () async{
                setState(() {
                  tawasolBalance = false;
                  evdBalance = false;
                  isLoading=false;
                });
                Navigator.of(context).pop();
                msisdn.clear();
                kitCode.clear();
              },
            );

            return AlertDialog(
              title: Text(
                EasyLocalization.of(context).locale == Locale("en", "US")
                    ? 'Deducted Way'
                    : 'طريقة الخصم',
                style: TextStyle(color: Colors.black, fontSize: 18),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            tawasolBalance = true;
                            evdBalance = false;
                          });
                        },
                        child: Icon(
                          tawasolBalance
                              ? Icons.check_circle_rounded
                              : Icons.circle_outlined,
                          color: tawasolBalance
                              ? Color(0xFF4f2565)
                              : Color(0xFFEBECF1),
                            size:18

                        ),
                      ),
                      SizedBox(width: 10),
                      Text(
                        EasyLocalization.of(context).locale == Locale("en", "US")
                            ? 'Tawasol Balance'
                            : "رصيد التواصل",
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            tawasolBalance = false;
                            evdBalance = true;
                          });
                        },
                        child: Icon(
                          evdBalance
                              ? Icons.check_circle_rounded
                              : Icons.circle_outlined,
                          color: evdBalance
                              ? Color(0xFF4f2565)
                              : Color(0xFFEBECF1),
                          size:18
                        ),
                      ),
                      SizedBox(width:10),
                      Text(
                        EasyLocalization.of(context).locale == Locale("en", "US")
                            ? 'EVD Wallet'
                            : "EVD محفظة",
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [

                      SizedBox(height:10),

                    ],
                  ),
                  if (deductedWay)
                    Row(
                      children: [
                        SizedBox(height: 5),
                        Text(
                          EasyLocalization.of(context).locale == Locale("en", "US")
                              ? 'Please select deducted way'
                              : "الرجاء تحديد طريقة الخصم",
                          style: TextStyle(color: Colors.red, fontSize: 14),
                        ),
                      ],
                    ),

                ],
              ),
              actions: [cancelButton, SelectButton],
            );
          },
        );
      },
    );
  }




  @override
  Widget build(BuildContext context) {

    return  BlocListener<ExtendValidityBloc,
        ExtendValidityState>(
        listener: (context, state) {
          if (state is ExtendValidityErrorState) {
            showAlertDialog(
                context, state.arabicMessage, state.englishMessage);
          }

          if (state is ExtendValiditySuccessState) {
            showToast(
                EasyLocalization.of(context).locale == Locale("en", "US")
                    ? state.englishMessage
                    : state.arabicMessage,
                context: context,
                animation: StyledToastAnimation.scale,
                fullWidth: true);

            //Navigator.pop(context);


          }
        },
    child: GestureDetector(
      onTap: ()=>FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            //tooltip: 'Menu Icon',
            onPressed: () {
              Navigator.pop(
                context,
              );
            },
          ),
          centerTitle:false,
          title: Text(
            "Menu_Form.extend_validity".tr().toString(),
          ),
          backgroundColor: Color(0xFF4f2565),
        ),
        backgroundColor: Color(0xFFEBECF1),

        body: ListView(padding: EdgeInsets.only(top: 10), children: <Widget>[
          Container(
            color: Colors.white,
            padding: EdgeInsets.only(left: 15, right: 15),
            child: Column(
              children: <Widget>[
                Container(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 20),
                      MSISDN(),
                      emptymsisdn == true
                          ? ReusableRequiredText(
                          text: "Menu_Form.msisdn_required".tr().toString())
                          : Container(),
                      errormsisdn == true
                          ? ReusableRequiredText(
                          text: EasyLocalization.of(context).locale ==
                              Locale("en", "US")
                              ? "Your MSISID shoud be 10 digits and start with 079"
                              : "رقم الهاتف يجب أن يتكون من 10 أرقام ويبدأ ب 079"): Container(),
                      SizedBox(height: 20),
                      kitCodeFunction(),
                      emptykitcode == true
                          ? ReusableRequiredText(
                          text: "Menu_Form.recharge_number_required"
                              .tr()
                              .toString())
                          : Container(),

                      SizedBox(height: 20),
                      SizedBox(height: 25),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
         isLoading==true? Column(
            children: [
              CircularProgressIndicator(
                valueColor:AlwaysStoppedAnimation<Color>(Color(0xFF4F2565)),
              ),
            ],
          ):Container(),
          SizedBox(height: 20),
          msg,
          msgPrice,
          Container(
              height: 48,
              width: 420,
              margin: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Color(0xFF4f2565),
              ),
              child: BlocListener<GetExtendValidityPriceBloc,GetExtendValidityPriceState>(
      listener: (context,state){

      if(state is GetExtendValidityPriceSuccessState){
          setState(() {
            isLoading=false;
          });
      showAlertDialogPrice(
      context, state.arabicName, state.englishName, state.price, state.expiryDate);
      }

      if(state is GetExtendValidityPriceErrorState){
        setState(() {
          isLoading=false;
        });
      showAlertDialogPriceError(context, state.arabicMessage, state.englishMessage);
      }


      },
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor:Color(0xFF4f2565),
                    shape: const BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(24))),
                  ),


                  onPressed: isLoading==false? () {

                    FocusScope.of(context).unfocus();
                    print(msisdn.text.length);
                    if (msisdn.text == '') {
                      setState(() {
                        errormsisdn = false;
                        emptymsisdn = true;
                      });
                    }
                    if (msisdn.text != '') {
                      if(msisdn.text.length == 10 ){
                        if( msisdn.text.substring(0, 3) == '079'){
                          setState(() {
                            errormsisdn = false;
                            emptymsisdn=false;
                          });}
                        else {
                          setState(() {
                            errormsisdn = true;
                            emptymsisdn=false;
                          });
                        }
                      }else{
                        setState(() {
                          errormsisdn = true;
                          emptymsisdn=false;
                        });
                      }
                    }
                    if (kitCode.text == '') {
                      setState(() {
                        emptykitcode = true;
                      });
                    }
                    else{
                      setState(() {
                        emptykitcode = false;
                      });
                    }


                    if (msisdn.text != '' && kitCode.text != '' && msisdn.text.length == 10 && msisdn.text.substring(0, 3) == '079' ) {
                      return showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(

                          content: Text("TawasolService.ExtendValidity_Daialog".tr().toString()),

                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(ctx).pop();
                                msisdn.clear();
                                kitCode.clear();
                              },
                              child: Text("TawasolService.Cancel".tr().toString(),

                                style: TextStyle(
                                  color: Color(0xFF4f2565),
                                  fontSize: 16,
                                ),
                              ),
                            ),

                            TextButton(
                              onPressed:isLoading==false? () {
                                Navigator.of(ctx).pop();

                             getExtendValidityPriceBloc.add(GetExtendValidityPriceButtonPressed(kitCode.text));


                              }:null,
                              child: Text("TawasolService.OK".tr().toString(),

                                style: TextStyle(
                                  color: Color(0xFF4f2565),
                                  fontSize: 16,
                                ),
                              ),
                            ),

                          ],

                        ),
                      );

                    }
                  }:null,

                  child: Text(
                    "Menu_Form.process".tr().toString(),
                    style: TextStyle(
                        color: Colors.white,
                        letterSpacing: 0,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              )),

          SizedBox(height: 20),


        ]),
      ),
    ));
  }
}


/*BlocListener<GetExtendValidityPriceBloc,GetExtendValidityPriceState>(
listener: (context,state){

if(state is GetExtendValidityPriceSuccessState){

showAlertDialogPrice(
context, state.arabicName, state.englishName, state.price);
}

if(state is GetExtendValidityPriceErrorState){

showAlertDialogPriceError(
context, state.arabicMessage, state.englishMessage);
}


},
),*/