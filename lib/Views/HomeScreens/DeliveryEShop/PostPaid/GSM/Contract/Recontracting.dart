import 'dart:async';
import 'dart:convert';
//import 'dart:html';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sales_app/Views/HomeScreens/DeliveryEShop/Eshope_Menu.dart';
import 'package:sales_app/Views/HomeScreens/DeliveryEShop/OrdersScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:signature/signature.dart';
import '../../../../../../Shared/BaseUrl.dart';
import '../../../../../ReusableComponents/requiredText.dart';
import 'dart:typed_data';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:mime/mime.dart';
import 'package:path_provider/path_provider.dart';

import 'package:http/http.dart' as http;
import 'package:dotted_border/dotted_border.dart';
import 'package:photo_view/photo_view.dart';

import 'dart:io';
import 'dart:io' as Io;
import 'dart:ui' as ui;

import '../../../../Corporate/Multi_Use_Components/RequiredField.dart';


APP_URLS urls = new APP_URLS();
class Recontracting extends StatefulWidget {
  List<dynamic> Permessions;
  var role;
  var orderID;
  var msisdn;
  var packageCode;
  var packageName;
  var isJordainian;
  var frontImg;
  var backImg;
  var passprotImg;
  var commitment;
  Recontracting(
      this.Permessions,
      this.role,
      this.orderID,
      this.msisdn,
      this.packageCode,
      this.packageName,
      this.isJordainian,
      this.frontImg,
      this.backImg,
      this.passprotImg,
      this.commitment);

  @override
  State<Recontracting> createState() => _RecontractingState(
      this.Permessions,
      this.role,
      this.orderID,
      this.msisdn,
      this.packageCode,
      this.packageName,
      this.isJordainian,
      this.frontImg,
      this.backImg,
      this.passprotImg,
      this.commitment);
}

class _RecontractingState extends State<Recontracting> {
  _RecontractingState(
      this.Permessions,
      this.role,
      this.orderID,
      this.msisdn,
      this.packageCode,
      this.packageName,
      this.isJordainian,
      this.frontImg,
      this.backImg,
      this.passprotImg,
      this.commitment);

  List<dynamic> Permessions;
  var role;
  var orderID;
  var msisdn;
  var packageCode;
  var packageName;
  var isJordainian;
  var frontImg;
  var backImg;
 var passprotImg;
 var commitment;



  var imgBytes;
  String signatureImageBase64;
  final _picker = ImagePicker();
  bool _loadImageBack = false;
  bool _loadImageFront = false;
  bool imageRequiredBack = false;
  bool imageRequiredFront = false;

  File imageFileBack;
  var pickedFileBack;
  File imageFileFront;
  var pickedFileFront;

  int imageWidth = 200;
  int imageHeight = 200;

  String img64Back;
  String img64Front;

  bool add_signature = false;
  bool save_signature=false;
  bool Reontracting_Submit= false;

  bool checkResponce=false;



  /*...........................................New Variable..................................*/
  TextEditingController _msisdn = TextEditingController();
  TextEditingController _orderID = TextEditingController();
  TextEditingController _commitment = TextEditingController();
  bool emptyMAISDN = false;
  bool errorMAISDN = false;

  bool checkOptions =false;
  var options_RECONTRACTING = [];

  List<String> Value_en = [];
  List<String> Value_ar = [];
  bool  emptySelectedOptions =false;
  String recontractingKey;

  List EligiblePackages = [];

  var commitmentList = [];
  var selectedCommitment;

  bool emptyCommitmentList = false;

  String optionName;
  String commitmentKey;

  bool changerRecontractingKey = false;
  /*.........................................................................................*/
  var number_status;
  var status_Contanten;

  final SignatureController _controller = SignatureController(
    penStrokeWidth: 3,
    penColor: Color(0xFF392156),
    exportBackgroundColor: Colors.white,
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    RecontractingTypeLookup_API();

    setState(() {
      _orderID.text = this.orderID;
      _msisdn.text = this.msisdn;
      _commitment.text= this.commitment;
    });
  }



  Widget signature(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          color: Color(0xFFEBECF1),
          margin:EdgeInsets.only(left: 15,right: 15,bottom: 10) ,
          child:   RichText(
            text: TextSpan(
              text: "reContract.signature".tr().toString(),
              style: TextStyle(
                color: Color(0xff11120e),
                fontSize: 16,
                fontWeight: FontWeight.bold,
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
        ),
        SizedBox(height: 10),
        Container(
            color: Colors.white,
            padding: EdgeInsets.only(left: 40,right: 40,top: 30,bottom: 10),
            child: buildDashedBorder(
                child:AbsorbPointer(
                  absorbing: save_signature, // Set to true to disable user input, false to enable
                  child: Signature(
                    controller: _controller,
                    height: MediaQuery.of(context).size.height / 2 * 1.00,
                    backgroundColor: Colors.transparent,
                  ),
                )
            )
        ),
        Container(
          decoration: const BoxDecoration(color: Colors.white),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  //SHOW EXPORTED IMAGE IN NEW ROUTE
                  IgnorePointer(
                    ignoring: save_signature, // Replace 'condition' with your actual condition
                    child: IconButton(
                      icon: Icon(Icons.check),
                      color: save_signature ==true?Colors.black12:Color(0xFF392156),
                      onPressed: () async {
                        if (_controller.isNotEmpty) {
                          var data = await _controller.toPngBytes();
                          final imageEncoded = base64.encode(data);
                          setState(() {
                            save_signature=true;
                            imgBytes = data;
                            signatureImageBase64 = imageEncoded;
                            add_signature=false;
                          });
                          print(signatureImageBase64);
                        }
                      },
                    ),
                  ),
                  //CLEAR CANVAS
                  IconButton(
                    icon: const Icon(Icons.clear),
                    color: Color(0xFF392156),
                    onPressed: () {
                      setState(() =>
                          _controller.clear(),

                      );
                      setState(() {
                        signatureImageBase64 =null;
                        save_signature=false;
                        add_signature=false;
                      });
                    },
                  ),

                ],
              ),
              add_signature == true
                  ? ReusableRequiredText(
                  text: "Postpaid.this_feild_is_required".tr().toString())
                  : Container(),
              add_signature == true? SizedBox(height: 10):Container(),

            ],
          ),
        ),


      ],
    );
  }

  /*.............................................................................................................................................*/
  Widget buildDashedBorder({Widget child}) => DottedBorder(
      color: Color(0xffd5d8dc),
      borderType: BorderType.RRect,
      radius: Radius.circular(4),
      dashPattern: [8, 4],
      strokeWidth: 1,
      child: (child));

  ReontractingSubmit_API() async {
    setState(() {
      Reontracting_Submit=true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var apiArea = urls.BASE_URL + '/Postpaid/recontracting/submit';
    final Uri url = Uri.parse(apiArea);
    prefs.getString("accessToken");
    final access = prefs.getString("accessToken");
    print(url);

    Map body={
      "msisdn": msisdn,
      "recontractingType":recontractingKey,
      "optionId": commitmentKey,//key of  selectedCommitment
      "optionName": selectedCommitment,//value of selectedCommitment
      "isJordanian": this.isJordainian,
      "frontIdImageBase64": this.isJordainian==true?this.frontImg:"",
      "backIdImageBase64": this.isJordainian==true?this.backImg:"",
      "passportImageBase64": this.isJordainian==false?this.passprotImg:"",
      "backPassportImageBase64": this.isJordainian==false?"":"",
      "signatureImageBase64": signatureImageBase64,
      "eshopOrderID": this.orderID

    };
    final response = await http.post(
      url,
      headers: {
        "content-type": "application/json",
        "Authorization": prefs.getString("accessToken")
      },
      body: json.encode(body),

    );
    print(body);

    int statusCode = response.statusCode;
    var data = response.request;
    print("*******************************************************************");
    print(statusCode);
    print(response);
    print('body: [${response.body}]');
    print("*******************************************************************");


    if (statusCode == 401) {
      setState(() {
        Reontracting_Submit=false;
      });
      print('401  error ');
      // UnotherizedError();
    }

    if (statusCode == 200) {
      var result = json.decode(response.body);
      print("................................................................");
      print(result);
      print("................................................................");

      if(result["status"]== 0 ){

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                EasyLocalization.of(context).locale == Locale("en", "US")
                    ? result["message"]
                    : result["messageAr"])));

        setState(() {
          Reontracting_Submit=false;
        });
        showAlertDialogSuccess(
            context, " اكتملت العملية بنجاح ، سيتم إرسال نسخة من العقد إلى الرقم المرجعي الخاص بك",
            "The operation has been successfully completed, a copy of the contract will sent to your reference number");

      }else{
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                EasyLocalization.of(context).locale == Locale("en", "US")
                    ? result["message"]
                    : result["messageAr"])));
        setState(() {
          Reontracting_Submit=false;
        });
      }

      print('Sucses API');
      return result;
    } else {
      setState(() {
        Reontracting_Submit=false;
      });


      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(EasyLocalization.of(context).locale ==
              Locale("en", "US")
              ? statusCode.toString()
              : statusCode.toString())));
    }
  }

  showAlertDialogSuccess(BuildContext context, arabicMessage, englishMessage) {
    Widget close = TextButton(
      child: Text(
        "alert.close".tr().toString(),
        style: TextStyle(
          color: Color(0xFF392156),
          fontSize: 16,
        ),
      ),
      onPressed: () async {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder:(context)=> Eshope_Menu()
          ),
        );
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
        close,

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

  /*...............................................New Functions..................................*/
  RecontractingTypeLookup_API() async {
    setState(() {

    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var apiArea = urls.BASE_URL + '/Lookup/RECONTRACTING';
    final Uri url = Uri.parse(apiArea);
    prefs.getString("accessToken");
    final access = prefs.getString("accessToken");
    print(url);

    final response = await http.get(
      url,
      headers: {
        "content-type": "application/json",
        "Authorization": prefs.getString("accessToken")
      },

    );

    int statusCode = response.statusCode;
    var data = response.request;
    print(statusCode);

    print(response);
    print('body: [${response.body}]');

    if (statusCode == 401) {
      setState(() {
        checkOptions=false;
        emptyMAISDN=false;
      });
      print('401  error ');
      // UnotherizedError();
    }

    if (statusCode == 200) {
      var result = json.decode(response.body);
      print(result);

      if(result["status"]== 0 ){

        if (result["data"] == null || result["data"].length == 0) {
          setState(() {
            checkOptions=false;
            emptyMAISDN=false;
          });
          print(apiArea);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                  EasyLocalization.of(context).locale == Locale("en", "US")
                      ? "There is no data available"
                      : "لا توجد بيانات متاحة")));
        }

        if (result["data"] != null ) {
          setState(() {
            options_RECONTRACTING=result['data'];
            emptyMAISDN=false;
            checkOptions=false;
          });
          for (var i = 0; i < result['data'].length; i++) {
            Value_en.add(result['data'][i]['value'].toString());
            Value_ar.add(result['data'][i]['valueAr'].toString());

          }
          print("******start****");
          print(options_RECONTRACTING);
          print(Value_en);
          print(Value_ar);

        }

      }else{
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                EasyLocalization.of(context).locale == Locale("en", "US")
                    ? result["message"]
                    : result["messageAr"])));
        setState(() {
          checkOptions=false;
          emptyMAISDN=false;
        });
      }

      print('Sucses API');
      return result;
    } else {
      setState(() {
        checkOptions=false;
        emptyMAISDN=false;
      });


      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(EasyLocalization.of(context).locale ==
              Locale("en", "US")
              ? statusCode.toString()
              : statusCode.toString())));
    }
  }

  void getNameSelected(val) {
    for (var i = 0; i < options_RECONTRACTING.length; i++) {
      if (options_RECONTRACTING[i]['key'].contains(val)) {
        setState(() {
           optionName = options_RECONTRACTING[i]['value'];
        });

        print(".........recontractingKey..........");
        print(optionName);
        print("...................");

      } else {
        continue;
      }
    }

  }


  void getCommitmentId(val) {

    for (var i = 0; i < commitmentList.length; i++) {

      if (commitmentList[i]['value'].contains(val)) {
        print("getCommitmentId....");
        setState(() {
          commitmentKey = commitmentList[i]['key'];
        });


      } else {
        continue;
      }
    }

  }

  Widget buildRECONTRACTING() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: "reContract.Recontracting_Type".tr().toString(),
            style: TextStyle(
              color: Color(0xFF11120E),
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
        SizedBox(height: 15),
        Container(
            padding: EdgeInsets.only(left: 5, right: 5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                //color: Color(0xFFB10000), red color
                color: emptySelectedOptions == true
                    ? Color(0xFFB10000)
                    : Color(0xFFD1D7E0),
              ),
            ),
            child:DropdownButtonHideUnderline(
              child: ButtonTheme(
                alignedDropdown: true,
                child: DropdownButton<String>(
                  disabledHint:Text(
                    "Test.select_an_option".tr().toString(),
                    style: TextStyle(
                      color: Color(0xFFA4B0C1),
                      fontSize: 14,
                    ),
                  ),
                  hint: Text(
                    "Test.select_an_option".tr().toString(),
                    style: TextStyle(
                      color: Color(0xFFA4B0C1),
                      fontSize: 14,
                    ),
                  ),
                  dropdownColor: Colors.white,
                  icon: Icon(Icons.keyboard_arrow_down_rounded),
                  iconSize: 30,
                  iconEnabledColor: Colors.grey,
                  underline: SizedBox(),
                  isExpanded: true,
                  style: TextStyle(
                    color: Color(0xFF11120e),
                    fontSize: 14,
                  ),
                  value: recontractingKey,
                  onChanged: (  String newValue) {
                    setState(() {
                      recontractingKey = newValue;
                      print(".........recontractingKey..........");
                      print(recontractingKey);
                      print("...................");
                      commitmentKey ="";
                      selectedCommitment =null;
                      getNameSelected(newValue);
                      commitmentlist_API(recontractingKey);
                      changerRecontractingKey=true;
                    });

                  },
                  items: options_RECONTRACTING.map((valueItem) {
                    return DropdownMenuItem<String>(
                      value:valueItem['key'].toString(),
                      child: Text(EasyLocalization.of(context).locale ==
                          Locale("en", "US")
                          ? valueItem['value']
                          : valueItem['valueAr']),
                    );
                  }).toList(),
                ),
              ),
            )),
        emptySelectedOptions == true
            ? ReusableRequiredText(
            text: "Postpaid.this_feild_is_required".tr().toString())
            : Container(),
      ],
    );
  }

  commitmentlist_API(recontractingKey) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var apiArea = urls.BASE_URL + '/Postpaid/recontracting/eligible';
    final Uri url = Uri.parse(apiArea);
    print(url);
    Map body={
      "msisdn": msisdn,
      "recontractingType":int.parse(recontractingKey),
    };
    final response = await http.post(
      url,
      headers: {
        "content-type": "application/json",
        "Authorization": prefs.getString("accessToken")
      },
      body: json.encode(body),

    );
    int statusCode = response.statusCode;
    print("statusCode");
    print(statusCode);
    print('body: [${response.body}]');

    if (statusCode == 500) {
      print('500  error ');
    }
    if (statusCode == 401) {
      print('401  error ');
    }
    if (statusCode == 200) {
      var result = json.decode(response.body);
      if (result["status"] == 0) {
        if (result["data"] == null || result["data"].length == 0) {
          //   showAlertDialogNoData(context,"لا توجد بيانات متاحة الآن.", "No data available now .");
        } else {
          print("commitmentList");
          print(result["data"]);
          setState(() {
            number_status=result["status"];
            status_Contanten=result["message"];
            commitmentList = result["data"];
          });
        }
      } else {

         showAlertDialogError(context,result["messageAr"], result["message"]);
         setState(() {
           number_status=result["status"];
           status_Contanten=result["message"];
           changerRecontractingKey=false;
           commitmentKey="";
           selectedCommitment="";
         });
      }
      return result;
    } else {

      showAlertDialogError(context,statusCode,statusCode);

    }
  }

  showAlertDialogError(BuildContext context, arabicMessage, englishMessage) {

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
        TextButton(
          onPressed: () {

            Navigator.pop(context);
          },
          child: Text(
            "alert.close".tr().toString(),
            style: TextStyle(
              color: Color(0xFF392156),
              fontSize: 16,
            ),
          ),
        ),
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

  Widget buildCommitmentlist() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: "Postpaid.CommitmentList".tr().toString(),
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
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                //color: Color(0xFFB10000), red color
                color: emptyCommitmentList == true
                    ? Color(0xFFB10000)
                    : Color(0xFFD1D7E0),
              ),
            ),
            child: DropdownButtonHideUnderline(
              child: ButtonTheme(
                alignedDropdown: true,
                child: DropdownButton<String>(
                  hint: Text(
                    "Postpaid.select_CommitmentList".tr().toString(),
                    style: TextStyle(
                      color: Color(0xFFA4B0C1),
                      fontSize: 14,
                    ),
                  ),
                  dropdownColor: Colors.white,
                  icon: Icon(Icons.keyboard_arrow_down_rounded),
                  iconSize: 30,
                  iconEnabledColor: Colors.grey,
                  underline: SizedBox(),
                  isExpanded: true,
                  style: TextStyle(
                    color: Color(0xff11120e),
                    fontSize: 14,
                  ),
                  items: commitmentList.map((valueItem) {
                    return DropdownMenuItem<String>(
                      value: valueItem["value"],
                      child: EasyLocalization.of(context).locale ==
                          Locale("en", "US")
                          ? Text(valueItem["value"])
                          : Text(valueItem["valueAr"]),
                    );
                  }).toList(),
                  value: selectedCommitment,
                  onChanged: (String newValue) {
                    setState(() {
                      selectedCommitment = newValue;
                    });

                    getCommitmentId(newValue);
                  },
                ),
              ),
            )),
        emptyCommitmentList == true
            ? RequiredFeild(text: "Menu_Form.msisdn_required".tr().toString())
            : Container(),
      ],
    );
  }


  Widget buildOrderID() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: EasyLocalization
                .of(context)
                .locale == Locale("en", "US")
                ? 'Order ID'
                : "رقم الطلب",
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
            controller: _orderID,
            enabled: false,
            keyboardType: TextInputType.text,
            style: TextStyle(color: Color(0xFF5A6F84)),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                  borderSide: BorderSide(width: 1, color: Color(0xFFD1D7E0))),
              disabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 1, color: Color(0xFFD1D7E0))),
              focusedBorder: OutlineInputBorder(
                borderSide:
                const BorderSide(color: Color(0xFF392156), width: 1.0),
              ),
              fillColor: Color(0xFFEBECF1),
              filled: true,
              contentPadding: EdgeInsets.all(16),
            ),
          ),
        ),
      ],
    );
  }


  Widget buildMSISDN() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: EasyLocalization
                .of(context)
                .locale == Locale("en", "US")
                ? 'MSISDN'
                : "الرقم",
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
            controller: _msisdn,
            enabled: false,
            keyboardType: TextInputType.text,
            style: TextStyle(color: Color(0xFF5A6F84)),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                  borderSide: BorderSide(width: 1, color: Color(0xFFD1D7E0))),
              disabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 1, color: Color(0xFFD1D7E0))),
              focusedBorder: OutlineInputBorder(
                borderSide:
                const BorderSide(color: Color(0xFF392156), width: 1.0),
              ),
              fillColor: Color(0xFFEBECF1),
              filled: true,
              contentPadding: EdgeInsets.all(16),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildCommitment() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: EasyLocalization
                .of(context)
                .locale == Locale("en", "US")
                ? 'Commitment Period '
                : "فترة الإلتزام",
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
            controller: _commitment,
            enabled: false,
            keyboardType: TextInputType.text,
            style: TextStyle(color: Color(0xFF5A6F84)),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                  borderSide: BorderSide(width: 1, color: Color(0xFFD1D7E0))),
              disabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 1, color: Color(0xFFD1D7E0))),
              focusedBorder: OutlineInputBorder(
                borderSide:
                const BorderSide(color: Color(0xFF392156), width: 1.0),
              ),
              fillColor: Color(0xFFEBECF1),
              filled: true,
              contentPadding: EdgeInsets.all(16),
            ),
          ),
        ),
      ],
    );
  }
  /*..............................................................................................*/

  Future<bool> _onWillPop() async {

    Navigator.push(
      context,
      MaterialPageRoute(
          builder:(context)=> Eshope_Menu()
      ),
    );
    // Show a toast message when back button is pressed
    Fluttertoast.showToast(
      msg: "Back button pressed",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
    );
    return false; // Prevent the app from closing
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: ()=>FocusScope.of(context).unfocus(),
        child: Scaffold(
            appBar: AppBar(
             // automaticallyImplyLeading: false,  // This will prevent the back button from appearing automatically
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                //tooltip: 'Menu Icon',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder:(context)=> Eshope_Menu()
                    ),
                  );
                },
              ),
              centerTitle: false,
              title: Text(
                "reContract.Recontracting".tr().toString(),
              ),
              backgroundColor: Color(0xFF392156),
            ),
            backgroundColor: Color(0xFFEBECF1),
            body:WillPopScope(
              onWillPop: _onWillPop,
              child: Stack(
                children: [

                  SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Container(
                            color: Colors.white,
                            child: Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(left: 20,right: 20,top: 20),
                                  child:  buildOrderID(),
                                ),

                                Container(
                                  margin: EdgeInsets.only(left: 20,right: 20,top: 20),
                                  child:  buildMSISDN(),
                                ),

                                Container(
                                  margin: EdgeInsets.only(left: 20,right: 20,top: 20),
                                  child:  buildCommitment(),
                                ),

                                Container(
                                  margin: EdgeInsets.only(left: 20,right: 20,top: 20),
                                  child:  buildRECONTRACTING(),
                                ),
                                changerRecontractingKey==true?
                                SizedBox(height: 20):Container(),
                                changerRecontractingKey==true?
                                Container(
                                  margin: EdgeInsets.only(left: 20,right: 20,bottom: 20),
                                  child:   buildCommitmentlist(),
                                ):Container(),
                                SizedBox(height: 25),
                              ],
                            ),
                          ),
                          Container(
                            child: Column(
                              children: [
                                SizedBox(height: 20),
                                signature(),
                                SizedBox(height: 20),
                                SizedBox(height: 5),
                              ],
                            ),
                          ),
                          Container(
                              height: 48,
                              width: 300,
                              margin: EdgeInsets.symmetric(horizontal: 20),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color:number_status==-7 &&  status_Contanten=="Subscriber is Not Active"?Color(0xFFA4B0C1): Color(0xFF392156),
                              ),
                              child: TextButton(
                                onPressed:   number_status==-7 &&  status_Contanten=="Subscriber is Not Active"?null:
                                 () async {
                                  /*........................................Check Signature.......................................*/
                                  if(signatureImageBase64==null){
                                    setState(() {
                                      add_signature=true;
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                        content: Text(
                                            EasyLocalization.of(context).locale == Locale("en", "US")
                                                ?"Please save your signature"
                                                : "الرجاء حفظ التوقيع")));
                                  }
                                  if(signatureImageBase64!=null){
                                    setState(() {
                                      add_signature=false;
                                    });
                                  }
                                  /*........................................Check Recontracting Key.................................*/
                                  if(recontractingKey == null){
                                    setState(() {
                                      emptySelectedOptions=true;
                                    });
                                  }
                                  if(recontractingKey != null){
                                    setState(() {
                                      emptySelectedOptions=false;
                                    });
                                  }

                                  /*........................................Check Photo Back.......................................*/
                                  if(selectedCommitment == null){
                                    setState(() {
                                      emptyCommitmentList=true;
                                    });
                                  }
                                  if(selectedCommitment != null){
                                    setState(() {
                                      emptyCommitmentList=false;
                                    });
                                  }

                                  /*........................................Check To Submit.......................................*/

                                  if(signatureImageBase64 != null && recontractingKey != null && selectedCommitment !=null){
                                    setState(() {
                                      add_signature=false;
                                      emptySelectedOptions=false;
                                      emptyCommitmentList=false;
                                      Reontracting_Submit= true;
                                    });
                                    ReontractingSubmit_API();

                                  }


                                },
                                style: TextButton.styleFrom(
                                  backgroundColor:number_status==-7 &&  status_Contanten=="Subscriber is Not Active"?Color(0xFFA4B0C1): Color(0xFF392156),
                                  shape: const BeveledRectangleBorder(
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(24))),
                                ),
                                child: Text(
                                  "reContract.Save".tr().toString(),
                                  style: TextStyle(
                                      color: Colors.white,
                                      letterSpacing: 0,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              )),

                          SizedBox(height: 20)

                        ],
                      )
                  ),




                  // Transparent overlay
                  Visibility(
                    visible: Reontracting_Submit, // Adjust the condition based on when you want to show the overlay
                    child: Container(
                      color: Colors.black.withOpacity(0.5), // Adjust the opacity as needed
                      width: double.infinity,
                      height: double.infinity,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF392156),
                        ),
                      ),
                    ),
                  ),

                ],
              ),

            )


        ));
  }
}
