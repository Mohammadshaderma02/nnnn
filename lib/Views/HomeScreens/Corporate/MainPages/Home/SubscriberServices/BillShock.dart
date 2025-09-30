import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/Multi_Use_Components/AppBarSectionCorporate.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/Multi_Use_Components/CorpNavigationBar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_app/Views/LoginScreens/SignInScreen.dart';
import 'package:sales_app/Shared/BaseUrl.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../Multi_Use_Components/RequiredField.dart';

class SubscriberServicesBillShock extends StatefulWidget {
  List<dynamic> PermessionCorporate;

  String role;
  String customerNumber;
  String msisdn;
  int searchID;
  String searchValue;
  String searchCraretia;
  List data = [];

  SubscriberServicesBillShock(
      this.PermessionCorporate,
      this.role,
      this.searchID,
      this.searchValue,
      this.customerNumber,
      this.msisdn,
      this.data,
      this.searchCraretia);
  @override
  _SubscriberServicesBillShockState createState() =>
      _SubscriberServicesBillShockState(
          this.PermessionCorporate,
          this.role,
          this.searchID,
          this.searchValue,
          this.customerNumber,
          this.msisdn,
          this.data,
          this.searchCraretia);
}

class ListContentFirst {
  String name;
  ListContentFirst({this.name});
}

APP_URLS urls = new APP_URLS();

class _SubscriberServicesBillShockState
    extends State<SubscriberServicesBillShock> {
  var iosSecureScreenShotChannel = const MethodChannel('secureScreenshotChannel');

  DateTime backButtonPressedTime;
  //String PermessionCorporate;
  final List<dynamic> PermessionCorporate;
  String role;
  String customerNumber;
  String msisdn;
  int searchID;
  String searchValue;
  String searchCraretia;
  List data = [];
  bool isLoading = false;
  bool isLoadingReconnect = false;
  bool checkData = false;

  _SubscriberServicesBillShockState(
      this.PermessionCorporate,
      this.role,
      this.searchID,
      this.searchValue,
      this.customerNumber,
      this.msisdn,
      this.data,
      this.searchCraretia);

  var BillShockData = {};
  bool emptyEligibleProfile = false;
  var selectedEligibleProfile;

  var ELIGIBLE_PROFILE = [];
  bool isBlackListed =false;

  bool isLoadingRemove = false;
  bool isLoadingAdd = false;
  bool isLoadingAddBtn = false;
  bool isLoadingHistory = false;

  var BillShockHistory = [];

  TextEditingController fromDate = TextEditingController();
  TextEditingController toDate = TextEditingController();

  DateTime from = DateTime.now();
  DateTime to = DateTime.now();
  bool emptyfromDate = false;
  bool emptytoDate = false;

  List litemsFirst = [
    ListContentFirst(name: "SubscriberView.VPNDetails".tr().toString()),
    ListContentFirst(name: "billingDetailsView.BillingDetails".tr().toString()),
    ListContentFirst(name: "adjustmentLogsViews.AdjustmentLOG".tr().toString()),
    ListContentFirst(
        name: "OnlineChargingValuesViews.OnlineChargingvalues".tr().toString()),
    ListContentFirst(name: "SubscriberView.PresetRisk".tr().toString()),
    ListContentFirst(name: "PromotionsView.PromotionsDetails".tr().toString()),
    ListContentFirst(name: "Bline Ledger"),
    ListContentFirst(name: "UnbilledView.Unbilled".tr().toString()),
    ListContentFirst(name: "corpMenu.Customer_360_View".tr().toString()),
    ListContentFirst(name: "corpMenu.Subscriber_360_View".tr().toString()),
    ListContentFirst(name: "corpMenu.Subscriber_List".tr().toString()),
    ListContentFirst(name: "corpMenu.Subscriber_Services".tr().toString()),
    ListContentFirst(name: "corpMenu.Promotions".tr().toString()),
    ListContentFirst(name: "corpMenu.Kurmalek".tr().toString()),
    ListContentFirst(name: "corpMenu.Balance".tr().toString()),
  ];

  showAlertDialogERROR(BuildContext context, arabicMessage, englishMessage) {
    Widget tryAgainButton = TextButton(
      child: Text(
        "alert.tryAgain".tr().toString(),
        style: TextStyle(
          color: Color(0xFF392156),
          fontSize: 16,
        ),
      ),
      onPressed: () {
        Navigator.of(context).pop();
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
        TextButton(
          onPressed: () {
            Navigator.pop(context, 'OK');
          },
          child: Text(
            "alert.cancel".tr().toString(),
            style: TextStyle(
              color: Color(0xFF392156),
              fontSize: 16,
            ),
          ),
        )
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

  showAlertDialogUnotherizedERROR(
      BuildContext context, arabicMessage, englishMessage) {
    Widget tryAgainButton = TextButton(
      child: Text(
        "alert.tryAgain".tr().toString(),
        style: TextStyle(
          color: Color(0xFF392156),
          fontSize: 16,
        ),
      ),
      onPressed: () {
        Navigator.of(context).pop();
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
        TextButton(
          onPressed: () {
            UnotherizedError();
          },
          child: Text(
            "corpAlert.close".tr().toString(),
            style: TextStyle(
              color: Color(0xFF392156),
              fontSize: 16,
            ),
          ),
        )
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

  showAlertDialogOtherERROR(
      BuildContext context, arabicMessage, englishMessage) {
    Widget tryAgainButton = TextButton(
      child: Text(
        "alert.tryAgain".tr().toString(),
        style: TextStyle(
          color: Color(0xFF392156),
          fontSize: 16,
        ),
      ),
      onPressed: () {
        Navigator.of(context).pop();
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
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            "corpAlert.close".tr().toString(),
            style: TextStyle(
              color: Color(0xFF392156),
              fontSize: 16,
            ),
          ),
        )
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

  showAlertDialogNoData(BuildContext context, arabicMessage, englishMessage) {
    Widget tryAgainButton = TextButton(
      child: Text(
        "alert.tryAgain".tr().toString(),
        style: TextStyle(
          color: Color(0xFF392156),
          fontSize: 16,
        ),
      ),
      onPressed: () {
        Navigator.of(context).pop();
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
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            "corpAlert.close".tr().toString(),
            style: TextStyle(
              color: Color(0xFF392156),
              fontSize: 16,
            ),
          ),
        )
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

  showAlertDialog(BuildContext context, arabicMessage, englishMessage) {
    Widget tryAgainButton = TextButton(
      child: Text(
        "alert.tryAgain".tr().toString(),
        style: TextStyle(
          color: Color(0xFF392156),
          fontSize: 16,
        ),
      ),
      onPressed: () {
        Navigator.of(context).pop();
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
        TextButton(
          onPressed: () {
            //   logoutBloc.add(LogoutButtonPressed(
            //   ));
            //  exit(0);
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
        TextButton(
          onPressed: () {
            Navigator.pop(context, 'OK');
          },
          child: Text(
            "alert.cancel".tr().toString(),
            style: TextStyle(
              color: Color(0xFF392156),
              fontSize: 16,
            ),
          ),
        )
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

  UnotherizedError() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('is_logged_in', false);
    prefs.setBool('biomitric_is_logged_in', false);
    prefs.setBool('TokenError', true);
    prefs.remove("accessToken");
    //prefs.remove("userName");
    prefs.remove('counter');

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => SignInScreen(),
      ),
    );
  }

  @override
  void initState() {
    print("UnotherizedError");
    print("role role role role role");
    print(role);
    if (PermessionCorporate == null) {
      UnotherizedError();
    } else {
      billShock_API();
      getBillShockEligibleProfiles_API();
      SearchCrateria_API();
    }


    //iosSecureScreenShotChannel.invokeMethod("secureiOS");

    //disableCapture();
    super.initState();
  }
  @override
  void dispose() {

    // this method to the user can take screenshots of your application
  //  iosSecureScreenShotChannel.invokeMethod("secureiOS");

    // TODO: implement dispose
    super.dispose();
  }
  disableCapture() async{
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
    print("____________________________________________");
  }

  billShock_API() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var apiArea = urls.BASE_URL + '/Customer360/BillShock/profile/' + msisdn;
    final Uri url = Uri.parse(apiArea);
    prefs.getString("accessToken");
    final access = prefs.getString("accessToken");
    print(url);
    setState(() {
      isLoading = true;
    });

    Map body = {
      "msisdn": msisdn,
    };

    final response = await http.get(url, headers: {
      "content-type": "application/json",
      "Authorization": prefs.getString("accessToken")
    });
    int statusCode = response.statusCode;
    var data = response.request;
    print('bill shock' );
    print(statusCode);
    print(response.body);

    if (statusCode == 500) {
      print('500  error ');
    }
    if (statusCode == 401) {
      print('401  error ');
      UnotherizedError();
    }
    if (statusCode == 200) {
      var result = json.decode(response.body);
      print(result);
      setState(() {
        isLoading = false;
      });
      if (result["status"] == 0) {
        if (result["data"] == null || result["data"].length == 0) {
          showAlertDialogNoData(
              context, "لا توجد بيانات متاحة الآن.", "No data available now .");
        } else {
          setState(() {
            BillShockData = result["data"];
           // selectedEligibleProfile=result["data"]['profileID'];
          });
        }
      } else {
        showAlertDialogERROR(context, result["messageAr"], result["message"]);
      }
    } else {
      showAlertDialogOtherERROR(context, statusCode, statusCode);
    }
  }

  reconnectButton_API() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    Map body = {
      "msisdn": msisdn,
    };
    //String body = json.encode(test);
    var apiArea = urls.BASE_URL + '/Customer360/ReconnectBillShock';
    final Uri url = Uri.parse(apiArea);
    prefs.getString("accessToken");
    final access = prefs.getString("accessToken");

    final response = await http.post(
      url,
      headers: {
        "content-type": "application/json",
        "Authorization": prefs.getString("accessToken")
      },
      body: json.encode(body),
    );
    int statusCode = response.statusCode;
    var data = response.request;
    print(statusCode);
    print(data);
    print(response);
    print('body: [${response.body}]');
    if (statusCode == 500) {
      print('500  error ');
    }
    if (statusCode == 401) {
      print('401  error ');
      UnotherizedError();
    }
    if (statusCode == 200) {
      print("yes");
      var result = json.decode(response.body);
      print(result);
      print(result["data"]);
      print('-------------------------------');

      if (result["status"] == 0) {
        setState(() {
          isLoadingReconnect = false;
        });
        showToast(
            EasyLocalization.of(context).locale == Locale("en", "US")
                ? result["message"]
                : result["messageAr"],
            context: context,
            animation: StyledToastAnimation.scale,
            fullWidth: true);
      } else {
        showAlertDialogERROR(context, result["messageAr"], result["message"]);
        setState(() {
          isLoadingReconnect = false;
        });
      }

      print('Sucses API');
      print("POST" +
          urls.BASE_URL +
          '/Customer360/BillShock/profile/' +
          this.msisdn);

      return result;
    } else {
      // showAlertDialogOtherERROR(context,statusCode, statusCode);

    }
  }

  updateBillShockProfile_API() async {
    if(selectedEligibleProfile==null){
      setState(() {
        emptyEligibleProfile=true;
      });
    }else {
      setState(() {
        isLoadingAddBtn = true;
      });
      setState(() {
        emptyEligibleProfile = false;
      });

      DateTime now = DateTime.now();
      SharedPreferences prefs = await SharedPreferences.getInstance();

      Map body = {
        "msisdn": msisdn,

        "profileID": selectedEligibleProfile,

        "effectiveDate": now.toIso8601String(),

      };

      //String body = json.encode(test);
      var apiArea = urls.BASE_URL + '/Customer360/updateBillShockProfile';
      final Uri url = Uri.parse(apiArea);
      prefs.getString("accessToken");
      final access = prefs.getString("accessToken");

      final response = await http.post(
        url,
        headers: {
          "content-type": "application/json",
          "Authorization": prefs.getString("accessToken")
        },
        body: json.encode(body),
      );
      print(json.encode(body));
      int statusCode = response.statusCode;
      var data = response.request;
      print(statusCode);
      print(data);
      print(response.body);

      if (statusCode == 500) {
        print('500  error ');
      }
      if (statusCode == 401) {
        print('401  error ');
        UnotherizedError();
      }
      if (statusCode == 200) {
        var result = json.decode(response.body);


        if (result["status"] == 0) {
          setState(() {
            isLoadingAddBtn = false;
          });
          showToast(
              EasyLocalization
                  .of(context)
                  .locale == Locale("en", "US")
                  ? result["message"]
                  : result["messageAr"],
              context: context,
              animation: StyledToastAnimation.scale,
              fullWidth: true);
          Navigator.pop(context);
        } else {
          showAlertDialogERROR(context, result["messageAr"], result["message"]);
          setState(() {
            isLoadingAddBtn = false;
          });
        }


        return result;
      } else {
        // showAlertDialogOtherERROR(context,statusCode, statusCode);

      }
    }
  }

  getBillShockEligibleProfiles_API() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    Map body = {
      "msisdn": msisdn,
    };
    //String body = json.encode(test);
    var apiArea = urls.BASE_URL + '/Customer360/getBillShockEligibleProfiles';
    final Uri url = Uri.parse(apiArea);
    prefs.getString("accessToken");
    final access = prefs.getString("accessToken");

    final response = await http.post(
      url,
      headers: {
        "content-type": "application/json",
        "Authorization": prefs.getString("accessToken")
      },
      body: json.encode(body),
    );
    int statusCode = response.statusCode;
    var data = response.request;

    print(json.encode(body));
    print(response.body);;
    if (statusCode == 500) {
      print('500  error ');
    }
    if (statusCode == 401) {
      print('401  error ');
      UnotherizedError();
    }
    if (statusCode == 200) {
      print("yes");
      var result = json.decode(response.body);


      if (result["status"] == 0) {
        setState(() {
          ELIGIBLE_PROFILE = result["data"];
        });
      } else {
        showAlertDialogERROR(context, result["messageAr"], result["message"]);
        setState(() {
          //isLoadingReconnect = false;
        });
      }



      return result;
    } else {
      // showAlertDialogOtherERROR(context,statusCode, statusCode);

    }
  }

  addRemoveBillShockBlackList(isAdd) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    Map body = {"customerID": customerNumber, "msisdn": msisdn, "isAdd": isAdd};

    if (isAdd == false) {
      setState(() {
        isLoadingRemove = true;
        isLoadingAdd = false;
      });
    } else {
      setState(() {
        isLoadingRemove = false;
        isLoadingAdd = true;
      });
    }

    //String body = json.encode(test);
    var apiArea = urls.BASE_URL + '/Customer360/addRemoveBillShockBlackList';
    final Uri url = Uri.parse(apiArea);
    prefs.getString("accessToken");
    final access = prefs.getString("accessToken");
    print(url);
    final response = await http.post(
      url,
      headers: {
        "content-type": "application/json",
        "Authorization": prefs.getString("accessToken")
      },
      body: json.encode(body),
    );
    int statusCode = response.statusCode;
    var data = response.request;
    print(statusCode);

    print('body: [${response.body}]');
    if (statusCode == 500) {
      print('500  error ');
    }
    if (statusCode == 401) {
      print('401  error ');
      UnotherizedError();
    }
    if (statusCode == 200) {
      print("yes");
      var result = json.decode(response.body);
      print(result);
      print(result["data"]);
      print('-------------------------------');

      if (result["status"] == 0) {
        setState(() {
          isLoadingRemove = false;
          isLoadingAdd = false;
        });


        showToast(
            EasyLocalization.of(context).locale == Locale("en", "US")
                ? result["message"]
                : result["messageAr"],
            context: context,
            animation: StyledToastAnimation.scale,
            fullWidth: true);
        Navigator.pop(context);

       // SearchCrateria_API();

      } else {
        showAlertDialogERROR(context, result["messageAr"], result["message"]);

        setState(() {
          isLoadingRemove = false;
          isLoadingAdd = false;
        });
      }
    } else {
      // showAlertDialogOtherERROR(context,statusCode, statusCode);

    }
  }

  SearchCrateria_API() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map test = {"searchID": searchID, "searchValue": searchValue};

    String body = json.encode(test);
    var apiArea = urls.BASE_URL + '/Customer360/search';
    final Uri url = Uri.parse(apiArea);
    prefs.getString("accessToken");
    final access = prefs.getString("accessToken");

    final response = await http.post(
      url,
      headers: {
        "content-type": "application/json",
        "Authorization": prefs.getString("accessToken")
      },
      body: body,
    );
    int statusCode = response.statusCode;
    print('muy status coed');
    print(statusCode);

    if (statusCode == 500) {
      print('500  error ');
    }
    if (statusCode == 401) {
      print('401  error ');
      UnotherizedError();
    }

    if (statusCode == 200) {
      var result = json.decode(response.body);

      if (result["status"] == 0) {
        print('look up');
        print(result['data']);

        print('saffiiiiiiii');

         print(result["data"][0]['isBillShockBlackListed']);
        setState(() {
          isBlackListed = result["data"][0]['isBillShockBlackListed'];
        });
      } else {
        print('hello');
        showAlertDialogERROR(context, result["messageAr"], result["message"]);
      }

      return result;
    } else {
      showAlertDialogOtherERROR(context, statusCode, statusCode);
    }
  }

  GetBillShockReconnectHistoryByDate_API() async {
    if (fromDate.text != '' && toDate.text != '') {
      if (fromDate.text != '') {
        setState(() {
          emptyfromDate = false;
        });
      }

      if (toDate.text != '') {
        setState(() {
          emptytoDate = false;
        });
      }

      setState(() {
        isLoadingHistory = true;
      });
      print('called');
      if (fromDate.text != '' && toDate.text != '') {
        SharedPreferences prefs = await SharedPreferences.getInstance();

        var apiArea =
            urls.BASE_URL + '/Customer360/GetBillShockReconnectHistoryByDate';
        final Uri url = Uri.parse(apiArea);
        prefs.getString("accessToken");
        final access = prefs.getString("accessToken");
        print(url);
        Map body = {
          "msisdn": msisdn,
          "fromDate": from.toIso8601String(),
          "toDate": to.toIso8601String()
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
        var data = response.request;
        print(statusCode);
        print(data);
        print(response);
        print('body: [${response.body}]');
        if (statusCode == 500) {
          print('500  error ');
        }
        if (statusCode == 401) {
          print('401  error ');
          UnotherizedError();
        }

        if (statusCode == 200) {
          var result = json.decode(response.body);
          print('heelo');
          print(result);
          print('heelo');

          setState(() {
            isLoadingHistory = false;
          });
          if (result["status"] == 0) {
            if (result["data"] == null || result["data"].length == 0) {
              showAlertDialogNoData(context, "لا توجد بيانات متاحة الآن.",
                  "No data available now .");
            } else {
              setState(() {
                BillShockHistory = result["data"];
                isLoadingHistory = false;
              });
            }
          } else {
            showAlertDialogERROR(
                context, result["messageAr"], result["message"]);
          }

          return result;
        } else {
          showAlertDialogOtherERROR(context, statusCode, statusCode);
        }
      }
    } else {
      if (fromDate.text == '') {
        setState(() {
          emptyfromDate = true;
        });
      } else if (fromDate.text != '') {
        setState(() {
          emptyfromDate = false;
        });
      }
      if (toDate.text == '') {
        setState(() {
          emptytoDate = true;
        });
      } else if (toDate.text != '') {
        setState(() {
          emptytoDate = false;
        });
      }
    }
  }

  Widget buildeligibleprofile() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: "SubscriberServices.eligible_profile".tr().toString(),
            style: TextStyle(
              color: Color(0xFF11120E),
              fontSize: 14,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        SizedBox(height: 10),
        Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                //color: Color(0xFFB10000), red color
                color: emptyEligibleProfile == true
                    ? Color(0xFFB10000)
                    : Color(0xFFD1D7E0),
              ),
            ),
            child: DropdownButtonHideUnderline(
              child: ButtonTheme(
                alignedDropdown: true,
                child: DropdownButton<String>(
                  hint: Text(
                    "Personal_Info_Edit.select_an_option".tr().toString(),
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
                  items:  ELIGIBLE_PROFILE.map((valueItem) {
                    return DropdownMenuItem<String>(
                      value: valueItem["profileID"],
                      child: Text(valueItem["profileName"]),
                    );
                  }).toList(),
                  value: selectedEligibleProfile,
                  onChanged: (String newValue) {
                    //Navigator.pop(context);

                    setState(() {
                      selectedEligibleProfile = newValue;
                    });
                  },
                ),
              ),
            )),
        emptyEligibleProfile == true
            ? RequiredFeild(text: "Menu_Form.msisdn_required".tr().toString())
            : Container(),
      ],
    );
  }

  Widget buildIsBlacklListed() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: "SubscriberServices.is_black_listed".tr().toString(),
            style: TextStyle(
              color: Color(0xFF11120E),
              fontSize: 14,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        SizedBox(height: 10),
        Container(
          child: Container(
              padding: EdgeInsets.only(right: 10),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      /*setState(() {
                        isBlackListed= true;
                      });*/
                    },
                    child: Container(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: isBlackListed==true
                                      ? Color(0xFF0E7074)
                                      : Colors.grey,
                                  width: 1,
                                ),
                                shape: BoxShape.circle,
                                color: isBlackListed == false
                                    ? Colors.white
                                    : Color(0xFF0E7074)),
                            padding: EdgeInsets.all(1),
                            child: isBlackListed==true
                                ? Icon(
                                    Icons.check,
                                    size: 15.0,
                                    color: Colors.white,
                                  )
                                : Icon(
                                    Icons.check,
                                    size: 15.0,
                                    color: Colors.white,
                                  ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "SubscriberServices.yes".tr().toString(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  GestureDetector(
                    onTap: () {
                      /* setState(() {
                        isBlackListed = false;
                      });*/
                    },
                    child: Container(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: isBlackListed==false
                                      ? Color(0xFF0E7074)
                                      : Colors.grey,
                                  width: 1,
                                ),
                                shape: BoxShape.circle,
                                color: isBlackListed == true
                                    ? Colors.white
                                    : Color(0xFF0E7074)),
                            padding: EdgeInsets.all(1),
                            child: isBlackListed==false
                                ? Icon(
                                    Icons.check,
                                    size: 15.0,
                                    color: Colors.white,
                                  )
                                : Icon(
                                    Icons.check,
                                    size: 15.0,
                                    color: Colors.white,
                                  ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "SubscriberServices.no".tr().toString(),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              )),
        ),
        SizedBox(height: 20),
        Container(
            height: 48,
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF0E7074).withOpacity(0.8),
                padding: EdgeInsets.all(15.0),
                disabledBackgroundColor: Color(0xFF0E7074).withOpacity(0.3),
                shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(30.0),
                ),
                textStyle: TextStyle(
                    color: Colors.white,
                    letterSpacing: 0,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
                // minimumSize: Size.fromHeight(50),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  isLoadingAdd == true
                      ? SizedBox(
                          child: CircularProgressIndicator(color: Colors.white),
                          height: 20.0,
                          width: 20.0,
                        )
                      : Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "SubscriberServices.add_toblacklist".tr().toString(),
                    style: TextStyle(
                        color: Colors.white,
                        letterSpacing: 0,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              onPressed: isLoadingAdd == true
                  ? null
                  : isBlackListed == true
                      ? null
                      : () async {
                          addRemoveBillShockBlackList(true);
                        },
            )),
        SizedBox(
          height: 10,
        ),
        Container(
            height: 48,
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF9D1C1C),
                padding: EdgeInsets.all(15.0),
                shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(30.0),
                ),
                disabledBackgroundColor: Color(0xFF9D1C1C).withOpacity(0.3),
                textStyle: TextStyle(
                    color: Colors.white,
                    letterSpacing: 0,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
                // minimumSize: Size.fromHeight(50),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  isLoadingRemove == true
                      ? SizedBox(
                          child: CircularProgressIndicator(color: Colors.white),
                          height: 20.0,
                          width: 20.0,
                        )
                      : Icon(
                          Icons.close,
                          color: Colors.white,
                        ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "SubscriberServices.remove_fromblacklist".tr().toString(),
                    style: TextStyle(
                        color: Colors.white,
                        letterSpacing: 0,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              onPressed: isLoadingRemove == true
                  ? null
                  : isBlackListed == false
                      ? null
                      : () async {
                          addRemoveBillShockBlackList(false);
                        },
            )),
        SizedBox(
          height: 20,
        ),
      ],
    );
  }

  Widget buildFromDate() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: "adjustmentLogsViews.from".tr().toString(),
            style: TextStyle(
              color: Color(0xff11120e),
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 5),
        Container(
          color: Colors.white,
          alignment: Alignment.centerLeft,
          width: MediaQuery.of(context).size.width / 2,
          child: TextField(
            controller: fromDate,
            readOnly: true,
            keyboardType: TextInputType.name,
            style: TextStyle(
              color: Color(0xFF656565),
            ),
            decoration: new InputDecoration(
              enabledBorder: emptyfromDate == true
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
                    const BorderSide(color: Color(0xFF392156), width: 1.0),
              ),
              suffixIcon: Container(
                child: IconButton(
                    icon: new Image.asset("assets/images/calendar_month.png"),
                    onPressed: () async {
                      showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(
                          DateTime.now().year - 25,
                        ),
                        lastDate: DateTime(
                          DateTime.now().year + 25,
                        ),
                        builder: (BuildContext context, Widget child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: ColorScheme.light(
                                primary: Color(
                                    0xFF392156), // header background color
                                onPrimary: Colors.white, // header text color
                                onSurface: Color(0xFF656565), // body text color
                              ),
                              textButtonTheme: TextButtonThemeData(
                                style: TextButton.styleFrom(
                                  primary:
                                      Color(0xFF392156), // button text color
                                ),
                              ),
                            ),
                            child: child,
                          );
                        },
                      ).then((fromData) => {
                            setState(() {
                              from = fromData;
                              fromDate.text =
                                  "${fromData.day.toString().padLeft(2, '0')}/${fromData.month.toString().padLeft(2, '0')}/${fromData.year.toString()}";
                            }),
                          });
                    }),
              ),
              hintText: "Reports.dd/mm/yyyy".tr().toString(),
              hintStyle: TextStyle(color: Color(0xffa4b0c1), fontSize: 14),
            ),
          ),
        ),
        SizedBox(height: 5),
        emptytoDate
            ? RequiredFeild(
                text: "Reports.this_feild_is_required".tr().toString())
            : Container(),
      ],
    );
  }

  Widget buildToDate() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: "adjustmentLogsViews.to".tr().toString(),
            style: TextStyle(
              color: Color(0xff11120e),
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 5),
        Container(
          color: Colors.white,
          alignment: Alignment.centerLeft,
          width: MediaQuery.of(context).size.width / 2,
          child: TextField(
            controller: toDate,
            readOnly: true,
            keyboardType: TextInputType.name,
            style: TextStyle(
              color: Color(0xFF656565),
            ),
            decoration: new InputDecoration(
              enabledBorder: emptytoDate == true
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
                    const BorderSide(color: Color(0xFF392156), width: 1.0),
              ),
              suffixIcon: Container(
                child: IconButton(
                    icon: new Image.asset("assets/images/calendar_month.png"),
                    onPressed: fromDate == ''
                        ? null
                        : () async {
                            showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(
                                DateTime.now().year - 25,
                              ),
                              lastDate: DateTime(
                                DateTime.now().year + 25,
                              ),
                              builder: (BuildContext context, Widget child) {
                                return Theme(
                                  data: Theme.of(context).copyWith(
                                    colorScheme: ColorScheme.light(
                                      primary: Color(
                                          0xFF392156), // header background color
                                      onPrimary:
                                          Colors.white, // header text color
                                      onSurface:
                                          Color(0xFF656565), // body text color
                                    ),
                                    textButtonTheme: TextButtonThemeData(
                                      style: TextButton.styleFrom(
                                        primary: Color(
                                            0xFF392156), // button text color
                                      ),
                                    ),
                                  ),
                                  child: child,
                                );
                              },
                            ).then((toData) => {
                                  setState(() {
                                    to = toData;
                                    toDate.text =
                                        "${toData.day.toString().padLeft(2, '0')}/${toData.month.toString().padLeft(2, '0')}/${toData.year.toString()}";
                                  }),
                                });
                          }),
              ),
              hintText: "Reports.dd/mm/yyyy".tr().toString(),
              hintStyle: TextStyle(color: Color(0xffa4b0c1), fontSize: 14),
            ),
          ),
        ),
        SizedBox(height: 5),
        emptyfromDate
            ? RequiredFeild(
                text: "Reports.this_feild_is_required".tr().toString())
            : Container(),
      ],
    );
  }

  Widget buildGetBtn() {
    return Container(
      height: 48,
      //margin: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: Color(0xFF0E7074),
      ),
      child: TextButton(
          style: TextButton.styleFrom(
            backgroundColor: Color(0xFF0E7074),
            shape: const BeveledRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(24))),
          ),
          onPressed: () {
            GetBillShockReconnectHistoryByDate_API();
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.search,
                color: Colors.white,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                "SubscriberServices.get".tr().toString(),
                style: TextStyle(
                    color: Colors.white,
                    letterSpacing: 0,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
            ],
          )),
    );
  }

  Widget buildReconnectBtn() {
    return Container(
        width: 170,
        height: 48,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF0E7074),
            padding: EdgeInsets.all(15.0),
            shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(30.0),
            ),
            disabledBackgroundColor: Color(0xFF0E7074).withOpacity(0.3),
            textStyle: TextStyle(
                color: Colors.white,
                letterSpacing: 0,
                fontSize: 16,
                fontWeight: FontWeight.bold),
            // minimumSize: Size.fromHeight(50),
          ),
          child: isLoadingReconnect
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      child: CircularProgressIndicator(color: Colors.white),
                      height: 20.0,
                      width: 20.0,
                    ),
                    SizedBox(width: 24),
                    Text("corporetUser.PleaseWait".tr().toString())
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.autorenew,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "billShockView.reConnect".tr().toString(),
                      style: TextStyle(
                          color: Colors.white,
                          letterSpacing: 0,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
          onPressed: BillShockData['status'] != "Connected" &&
                  BillShockData['status'] != null
              ? () async {
                  if (isLoadingReconnect) return;
                  setState(() {
                    isLoadingReconnect = true;
                  });

                  reconnectButton_API();
                }
              : null,
        ));
  }

  Widget buildAddBtn() {
    return Container(
        width: 170,
        height: 48,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF0E7074),
            padding: EdgeInsets.all(15.0),
            shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(30.0),
            ),
            textStyle: TextStyle(
                color: Colors.white,
                letterSpacing: 0,
                fontSize: 16,
                fontWeight: FontWeight.bold),
            // minimumSize: Size.fromHeight(50),
          ),
          child: isLoadingAddBtn
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      child: CircularProgressIndicator(color: Colors.white),
                      height: 20.0,
                      width: 20.0,
                    ),
                    SizedBox(width: 24),
                    Text("corporetUser.PleaseWait".tr().toString())
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "SubscriberServices.add".tr().toString(),
                      style: TextStyle(
                          color: Colors.white,
                          letterSpacing: 0,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
          onPressed: () async {
            if (isLoadingAddBtn) return;
            else {
            updateBillShockProfile_API();};
          },
        ));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=>FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF392156),
          title: Text("SubscriberServices.bill_shock".tr().toString()),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () async {
              Navigator.pop(context);
            },
          ),

          /* actions: <Widget>[
                IconButton(
                  icon:  Icon(Icons.more_vert,color: Colors.white,),
                  onPressed: ( _showMoreOptionDialog) ,
                ), //IconButton//IconButton
              ],*/

          ///<Widget>[]
        ),
        backgroundColor: Color(0xFFEBECF1),
        body: role == "Corporate"
            ? ListView(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                padding: EdgeInsets.only(top: 8, left: 0, right: 0),
                children: [
                  isLoading == true
                      ? Container(
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height / 3 * 1.9,
                          padding: EdgeInsets.only(left: 26, right: 26, top: 30),
                          // margin: EdgeInsets.all(12),
                          margin: EdgeInsets.only(top: 60),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                child: CircularProgressIndicator(
                                    color: Color(0xFF392156)),
                                height: 20.0,
                                width: 20.0,
                              ),
                              SizedBox(width: 24),
                              Text(
                                "corporetUser.PleaseWait".tr().toString(),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF392156),
                                    fontSize: 16),
                              )
                            ],
                          ))
                      : Container(
                          width: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.only(left: 26, right: 26),
                                color: Colors.white,
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 10,
                                    ),
                                    BillShockData.length != 0
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                child: Container(
                                                  margin: EdgeInsets.only(
                                                      left: 5, right: 5),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.center,
                                                    children: [
                                                      SizedBox(
                                                        height: 20,
                                                      ),
                                                      Text(
                                                        "SubscriberServices.serviceType"
                                                            .tr()
                                                            .toString(),
                                                      ),
                                                      SizedBox(height: 1),
                                                      Text(
                                                        BillShockData[
                                                                    'serviceType'] ==
                                                                null
                                                            ? "--"
                                                            : BillShockData['serviceType']
                                                                        .length ==
                                                                    0
                                                                ? "--"
                                                                : BillShockData[
                                                                    'serviceType'],
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 14.0,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),

                                              SizedBox(width: 8),
                                              //Spacer(),

                                              Expanded(
                                                child: Container(
                                                  margin: EdgeInsets.only(
                                                      left: 5, right: 5),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.center,
                                                    children: [
                                                      SizedBox(
                                                        height: 20,
                                                      ),
                                                      Text(
                                                        "SubscriberServices.limitType"
                                                            .tr()
                                                            .toString(),
                                                      ),
                                                      SizedBox(height: 1),
                                                      Text(
                                                        BillShockData[
                                                                    'limitType'] ==
                                                                null
                                                            ? "--"
                                                            : BillShockData['limitType']
                                                                        .length ==
                                                                    0
                                                                ? "--"
                                                                : BillShockData[
                                                                    'limitType'],
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 14.0,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                        : Container(),
                                    BillShockData.length != 0
                                        ? SizedBox(
                                            height: 20,
                                          )
                                        : Container(),
                                    BillShockData.length != 0
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                child: Container(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.center,
                                                    children: [
                                                      SizedBox(
                                                        height: 20,
                                                      ),
                                                      Text(
                                                        "SubscriberServices.remainingAmount"
                                                            .tr()
                                                            .toString(),
                                                      ),
                                                      SizedBox(height: 1),
                                                      Text(
                                                        BillShockData[
                                                                    'remainingAmount'] ==
                                                                null
                                                            ? "--"
                                                            : BillShockData['remainingAmount']
                                                                        .length ==
                                                                    0
                                                                ? "--"
                                                                : BillShockData[
                                                                    'remainingAmount'],
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 14.0,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),

                                              SizedBox(width: 8),
                                              //Spacer(),

                                              Expanded(
                                                child: Container(
                                                  margin: EdgeInsets.only(
                                                      left: 5, right: 5),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.center,
                                                    children: [
                                                      SizedBox(
                                                        height: 20,
                                                      ),
                                                      Text(
                                                        "SubscriberServices.limitValue"
                                                            .tr()
                                                            .toString(),
                                                      ),
                                                      SizedBox(height: 1),
                                                      Text(
                                                        BillShockData[
                                                                    'limitValue'] ==
                                                                null
                                                            ? "--"
                                                            : BillShockData['limitValue']
                                                                        .length ==
                                                                    0
                                                                ? '--'
                                                                : BillShockData[
                                                                    'limitValue'],
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 14.0,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                        : Container(),
                                         BillShockData.length != 0
                                        ? SizedBox(
                                            height: 20,
                                          )
                                        : Container(),
                                         BillShockData.length != 0
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                child: Container(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.center,
                                                    children: [
                                                      SizedBox(
                                                        height: 20,
                                                      ),
                                                      Text(
                                                        "SubscriberServices.usedAmount"
                                                            .tr()
                                                            .toString(),
                                                      ),
                                                      SizedBox(height: 1),
                                                      Text(
                                                        BillShockData[
                                                                    'usedAmount'] ==
                                                                null
                                                            ? "--"
                                                           : BillShockData[
                                                                    'usedAmount']
                                                               ,
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 14.0,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 8),
                                              Expanded(
                                                child: Container(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.center,
                                                    children: [
                                                      SizedBox(
                                                        height: 20,
                                                      ),
                                                      Text(
                                                        "SubscriberServices.subscriptionDate"
                                                            .tr()
                                                            .toString(),
                                                      ),
                                                      SizedBox(height: 1),
                                                      Text(
                                                        BillShockData['subscriptionDate'] !=
                                                                    null &&
                                                                BillShockData[
                                                                        'subscriptionDate'] !=
                                                                    ''
                                                            ? BillShockData[
                                                                    'subscriptionDate']
                                                                .toString()
                                                                .substring(0, 10)
                                                            : '-',
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 14.0,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),

                                              //Spacer(),
                                            ],
                                          )
                                        : Container(),
                                    BillShockData.length != 0
                                        ? SizedBox(
                                            height: 20,
                                          )
                                        : Container(),
                                    BillShockData.length != 0
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                child: Container(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.center,
                                                    children: [
                                                      SizedBox(
                                                        height: 20,
                                                      ),
                                                      Text(
                                                        "SubscriberServices.status"
                                                            .tr()
                                                            .toString(),
                                                      ),
                                                      SizedBox(height: 1),
                                                      Text(
                                                        BillShockData['status'] !=
                                                                null
                                                            ? BillShockData[
                                                                'status']
                                                            : '-',
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 14.0,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),

                                              SizedBox(width: 8),
                                              //Spacer(),

                                              Expanded(
                                                child: Container(
                                                  margin: EdgeInsets.only(
                                                      left: 5, right: 5),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.center,
                                                    children: [
                                                      SizedBox(
                                                        height: 20,
                                                      ),
                                                      Text(
                                                        "SubscriberServices.language"
                                                            .tr()
                                                            .toString(),
                                                      ),
                                                      SizedBox(height: 1),
                                                      Text(
                                                        BillShockData[
                                                                    'language'] !=
                                                                null
                                                            ? BillShockData[
                                                                'language']
                                                            : '-',
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 14.0,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                        : Container(),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    buildeligibleprofile(),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      children: [
                                        buildReconnectBtn(),
                                        Spacer(),
                                        buildAddBtn()
                                      ],
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Container(
                                  padding: EdgeInsets.only(
                                      left: 26, right: 26, top: 20),
                                  color: Colors.white,
                                  child: buildIsBlacklListed()),
                              SizedBox(
                                height: 20,
                              ),
                              Container(
                                padding: EdgeInsets.only(
                                    left: 26, right: 26, bottom: 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      child: Text(
                                        "SubscriberServices.reconnection_request"
                                            .tr()
                                            .toString(),
                                        style: TextStyle(
                                          color: Color(0xFF11120E),
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 15),
                                    Row(
                                      children: [
                                        SizedBox(
                                            width: 165, child: buildFromDate()),
                                        Spacer(),
                                        SizedBox(
                                            width: 165, child: buildToDate()),
                                      ],
                                    ),
                                    SizedBox(height: 15),
                                    buildGetBtn(),

                                  ],
                                ),
                              ),

                              isLoadingHistory == true
                                  ? Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.only(
                                      left: 26, right: 26, top: 30),
                                  // margin: EdgeInsets.all(12),
                                  margin: EdgeInsets.only(top: 20),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        child:
                                        CircularProgressIndicator(
                                            color:
                                            Color(0xFF392156)),
                                        height: 20.0,
                                        width: 20.0,
                                      ),
                                      SizedBox(width: 24),
                                      Text(
                                        "corporetUser.PleaseWait"
                                            .tr()
                                            .toString(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF392156),
                                            fontSize: 16),
                                      )
                                    ],
                                  ))
                                  : Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.only(
                                      top: 10,
                                      left: 26,
                                      right: 26,
                                      bottom: 20),
                                    color: isLoadingHistory == true
                                      ? Colors.transparent
                                      : Colors.transparent,
                                    child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: BillShockHistory.length,
                                    itemBuilder: (BuildContext context,
                                        int index) {
                                      return Container(
                                        width: double.infinity,
                                        margin: EdgeInsets.only(bottom: 10),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius.circular(
                                                10),
                                            border: Border.all(
                                                color:
                                                Color(0xffE9E9E9)),
                                            color: Colors.white),
                                        padding: EdgeInsets.only(

                                            left: 16,
                                            right: 16,
                                            bottom: 20),
                                        // margin: EdgeInsets.all(12),

                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Text(
                                              "SubscriberServices.user"
                                                  .tr()
                                                  .toString(),
                                            ),
                                            SizedBox(height: 1),
                                            Text(
                                              BillShockHistory[index]['msisdn']!=null?BillShockHistory[index]['msisdn']:'--'
                                              ,
                                              style: TextStyle(
                                                fontWeight:
                                                FontWeight.bold,
                                                fontSize: 14.0,
                                              ),
                                            ),

                                            Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .start,
                                              crossAxisAlignment:
                                              CrossAxisAlignment
                                                  .center,
                                              children: [
                                                Expanded(
                                                  child: Container(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .start,
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .center,
                                                      children: [
                                                        SizedBox(
                                                          height: 20,
                                                        ),
                                                        Text(
                                                          "SubscriberServices.entry_date"
                                                              .tr()
                                                              .toString(),
                                                        ),
                                                        SizedBox(
                                                            height: 1),
                                                        Text(
                                                          BillShockHistory[index]['entryDate']!=null?
                                                          BillShockHistory[index]['entryDate'].toString().substring(0, 9):'--',

                                                          style:
                                                          TextStyle(
                                                            fontWeight:
                                                            FontWeight
                                                                .bold,
                                                            fontSize:
                                                            14.0,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 8),
                                                Expanded(
                                                  child: Container(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .start,
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .center,
                                                      children: [
                                                        SizedBox(
                                                          height: 20,
                                                        ),
                                                        Text(
                                                          "SubscriberServices.request_status"
                                                              .tr()
                                                              .toString(),
                                                        ),
                                                        SizedBox(
                                                            height: 1),
                                                        Text(
                                                          BillShockHistory[
                                                          index]
                                                          [
                                                          'status'],
                                                          style:
                                                          TextStyle(
                                                            fontWeight:
                                                            FontWeight
                                                                .bold,
                                                            fontSize:
                                                            14.0,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  )),
                            ],
                          ),
                        ),

                  ///////////////////////////////////End Second Content//////////////////////////////////////////////////////////
                ],
              )
            : Center(
                child: Text(role),
              ),
      ),
    );
  }
}
