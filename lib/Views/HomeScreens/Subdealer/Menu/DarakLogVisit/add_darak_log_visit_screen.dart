import 'package:dropdown_search/dropdown_search.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/Multi_Use_Components/app_text_field.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/Multi_Use_Components/app_button.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../../../../../../Helpers/location_helper.dart';
import '../../../../../Shared/BaseUrl.dart';
import '../../../../../main.dart';
import '../../../../ReusableComponents/UnotherizedError.dart';
import '../../../Corporate/MainPages/Home/AccountManager/ClientMessages.dart';
import '../../../Corporate/Multi_Use_Components/RequiredField.dart';
import '../../../ZainOutdoorHeads/AgentsDetails.dart';
import 'darak_log_visit_screen.dart';


class AddDarakLogVisitScreen extends StatefulWidget {
  @override
  _AddDarakLogVisitScreenState createState() => _AddDarakLogVisitScreenState();
}

class _AddDarakLogVisitScreenState extends State<AddDarakLogVisitScreen> {
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();
  final TextEditingController msisdnController = TextEditingController();
  final TextEditingController selectedActionController = TextEditingController();
  final TextEditingController accountRegardingController = TextEditingController();


  String selectedSubject;
  bool emptySubject = false;
  String selectedAction;
  var subjects = [];
  List<Map<String, String>> actions = [];
  List<String> selectedActions = [];
  String userLocation = "";
  final baseUrl = APP_URLS();

  bool isLoading=false;
  bool isLoadingSubmit =false;
  bool emtyResult=false;
  bool emtyResultAgent=false;
  String statusReult;




  var Action_options = [];
  List<Map<String, dynamic>> filteredActions = [];
  bool emptySelectedAction=false;
  List<String> selectAction = [];


  bool showDescriptionError = false;
  bool showStartDateError = false;
  bool showEndDateError = false;
  bool showMsisdnError = false;
  bool showSubjectError = false;
  bool showActionError = false;
  bool showAccountRegardingError = false;

  @override
  void initState() {
    super.initState();
    getSubjects_API();
    getActionAPI();
    fetchUserLocation();
  }

    Future<void> fetchUserLocation() async {
    try {
      Position position = await LocationHelper.getCurrentLocation(context);
      setState(() {
        userLocation = "${position.latitude},${position.longitude}";
      });
    } catch (e) {
      debugPrint("Failed to get location: $e");
    }
  }


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
            Navigator.pop(context);
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

  showAlertDialogOtherERROR(
      BuildContext context, arabicMessage, englishMessage) {

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



  Future<void> pickDate(TextEditingController controller) async {
    DateTime pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      String userFriendlyDate = DateFormat("dd/MM/yyyy").format(pickedDate);
      String apiFormattedDate = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(pickedDate);
      controller.text = userFriendlyDate;
    }
  }
  void getSubjects_API() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var apiArea = urls.BASE_URL + '/Lookup/GET_LOGVISIT_LIST';
    final Uri url = Uri.parse(apiArea);

    final response = await http.get(
      url,
      headers: {
        "content-type": "application/json",
        "Authorization": prefs.getString("accessToken")
      },
    );
    int statusCode = response.statusCode;
    if (statusCode == 500) {
      print('500  error ');
    }
    if (statusCode == 401) {
      print('401  error ');
      UnotherizedError();
      //  showAlertDialogUnotherizedERROR(context,"تحتاج إلى إعادة تسجيل الدخول", "Need to re-registration");
    }
    if (statusCode == 200) {
      var result = json.decode(response.body);

      if (result["status"] == 0) {
        if (result["data"] == null || result["data"].length == 0) {
          showAlertDialogNoData(
              context, "لا توجد بيانات متاحة الآن.", "No data available now .");
        } else {
          setState(() {
            subjects = result["data"];
          });
        }
      } else {
        showAlertDialogERROR(context, result["messageAr"], result["message"]);
      }
      return result;
    } else {
      showAlertDialogOtherERROR(context, statusCode, statusCode);
    }
  }
  void getActionAPI() async {
    setState(() {

      isLoading = true;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var apiArea = FirstPart.BASE_URL + "/Lookup/DARAK_APOINTMENT_ACTION";
    final Uri url = Uri.parse(apiArea);
    print(url);

    final response = await http.get(url, headers: {
      "content-type": "application/json",
      "Authorization": prefs.getString("accessToken")
    });
    int statusCode = response.statusCode;
    print(statusCode);

    if (statusCode == 401) {
      setState(() {
        isLoading = false;
      });
      UnotherizedError();
    }

    if (statusCode == 200) {
      setState(() {
        isLoading = false;
      });
      var result = json.decode(response.body);
      print(result);

      if (result["status"] == 0) {
        if (result["data"] != null) {
          print('safii');
          print('result');
          final data = json.decode(response.body)['data'] as List;
          setState(() {
            actions = data
                .map((item) => {
              'key': item['key'].toString(),
              'value':
              EasyLocalization.of(context).locale == Locale("en", "US")
                  ? item['value'].toString()
                  : item['valueAr'].toString()
            })
                .toList();
          });
          setState(() {
            // Cast the data to List<Map<String, dynamic>>
            Action_options = List<Map<String, dynamic>>.from(result["data"]);
            filteredActions=List<Map<String, dynamic>>.from(result["data"]);
          });

          print(Action_options);

        }
      } else {
        setState(() {
          statusReult = EasyLocalization.of(context).locale == Locale("en", "US")
              ? "No data found to view agent"
              : "لم يتم العثور على بيانات لعرض الوكلاء";
          isLoading = false;
          emtyResult = true;
        });
      }
    } else {
      setState(() {
        statusReult = EasyLocalization.of(context).locale == Locale("en", "US")
            ? statusCode.toString()
            : statusCode.toString();

        emtyResult = true;
        isLoading = false;
      });
    }
  }

  Future<void> submitForm() async {

    print('submitted');
    print(selectedActions);
    setState(() {
      isLoadingSubmit=true;
      showDescriptionError = descriptionController.text.trim().isEmpty;
      showStartDateError = startDateController.text.trim().isEmpty;
      showEndDateError = endDateController.text.trim().isEmpty;
      showMsisdnError = msisdnController.text.trim().isEmpty;
      showSubjectError = selectedSubject == null || selectedSubject.isEmpty;
      showActionError = selectedActions == null || selectedActions.isEmpty;
      //showAccountRegardingError = accountRegardingController.text.trim().isEmpty;
    });
    // If any field is invalid, return
    if (showDescriptionError ||
        showStartDateError ||
        showEndDateError ||
        showMsisdnError ||
        showSubjectError ||
        showActionError
        //|| showAccountRegardingError
        ) {
      setState(() {
        isLoadingSubmit=false;
      });
      return;
    }

    try {
      await fetchUserLocation();
      // Assuming this sets userLocation
      SharedPreferences prefs = await SharedPreferences.getInstance();

      DateTime startDate = DateFormat("dd/MM/yyyy").parse(startDateController.text);
      DateTime endDate = DateFormat("dd/MM/yyyy").parse(endDateController.text);

      String apiStartDate = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(startDate);
      String apiEndDate = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(endDate);


      final body = {
        "sSubject": selectedSubject,
        "sDescription": descriptionController.text,
        "sLocation": userLocation,
        "dtStartDate": apiStartDate,
        "dtEndDate": apiEndDate,
        "contactMSISDN": msisdnController.text,
        "accountRegarding": accountRegardingController.text,
        "action": selectedActions.join(','),
        "message": "",
      };

      print(body);

      final response = await http.post(
        Uri.parse('${baseUrl.BASE_URL}/Customer360/CreateAppointmentActionDynamicsCRM'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": prefs.getString("accessToken") ?? "",
        },
        body: json.encode(body),
      );

      print(response.statusCode);
      final result = jsonDecode(response.body);

      if (response.statusCode == 200 && result['status'] == 0 ) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'success',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.green ,
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: 3),
          ),
        );
        setState(() {
          isLoadingSubmit=false;
        });
        Navigator.pop(context);
      }  else if(response.statusCode == 401) {
        setState(() {
          isLoadingSubmit = false;
        });
        UnotherizedError();
      }else if(result['status'] == -2){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              EasyLocalization.of(context).locale == Locale("en", "US") ?
              result['message'] : result['messageAr'],
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red ,
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: 3),
          ),
        );
        setState(() {
          isLoadingSubmit=false;
        });

      }
    } catch (e) {
      debugPrint('Exception: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e,
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.grey ,
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 3),
        ),
      );    }
  }




  Widget buildSubject() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: "LogVisit.subject".tr().toString(),
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
                color: showSubjectError == true
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
                  items: subjects.map((valueItem) {
                    return DropdownMenuItem<String>(
                      value: valueItem["code"],
                      child: EasyLocalization.of(context).locale ==
                          Locale("en", "US")
                          ? Text(valueItem["value"])
                          : Text(valueItem["valueAr"]),
                    );
                  }).toList(),
                  value: selectedSubject,
                  onChanged: (String newValue) {
                    setState(() {
                      selectedSubject = newValue;
                    });

                    print(selectedSubject);
                  },
                ),
              ),
            )),
        emptySubject == true
            ? RequiredFeild(text: "Menu_Form.msisdn_required".tr().toString())
            : Container(),
      ],
    );
  }

  Widget buildMSISDN() {
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
            maxLength: 10,
            buildCounter: (BuildContext context, { int currentLength, int maxLength, bool isFocused }) => null,
            controller: msisdnController,
            keyboardType: TextInputType.phone,
            style: TextStyle(color: Color(0xFF5A6F84)),
            decoration: InputDecoration(
              enabledBorder: showMsisdnError
                  ? OutlineInputBorder(borderSide: BorderSide(color: Color(0xFFB10000)))
                  : OutlineInputBorder(borderSide: BorderSide(color: Color(0xFFD1D7E0))),
              border: const OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide:
                const BorderSide(color: Color(0xFF4f2565), width: 1.0),
              ),
              contentPadding: EdgeInsets.all(16),
              hintText: "Jordan_Nationality.enter_id_number".tr().toString(),
              hintStyle: TextStyle(color: Color(0xFFA4B0C1), fontSize: 14),

            ),
          ),
        ),
      ],
    );
  }
  Widget buildAccountRegarding() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: EasyLocalization.of(context).locale == Locale("en", "US")
                ? "Customer Number (Optional)"
                : " رقم العميل (اختياري)",
            style: TextStyle(
              color: Color(0xff11120e),
              fontSize: 14,
              fontWeight: FontWeight.normal,
            ),
          ),

        ),
        SizedBox(height: 10),
        Container(
          alignment: Alignment.centerLeft,
          height: 58,
          child: TextField(
            maxLength: 10,
            buildCounter: (BuildContext context, { int currentLength, int maxLength, bool isFocused }) => null,
            controller: accountRegardingController,
            keyboardType: TextInputType.phone,
            style: TextStyle(color: Color(0xFF5A6F84)),
            decoration: InputDecoration(
              enabledBorder: showAccountRegardingError
                  ? OutlineInputBorder(borderSide: BorderSide(color: Color(0xFFB10000)))
                  : OutlineInputBorder(borderSide: BorderSide(color: Color(0xFFD1D7E0))),
              border: const OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide:
                const BorderSide(color: Color(0xFF4f2565), width: 1.0),
              ),
              contentPadding: EdgeInsets.all(16),
              hintText:  EasyLocalization.of(context).locale == Locale("en", "US")
                  ? "Enter Customer Number"
                  : "أدخل رقم العميل  ",

              hintStyle: TextStyle(color: Color(0xFFA4B0C1), fontSize: 14),

            ),
          ),
        ),
      ],
    );
  }

  Widget buildDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: "LogVisit.description".tr().toString(),
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
          height: 120,
          alignment: Alignment.topLeft,
          child: TextFormField(
            controller: descriptionController,
            keyboardType: TextInputType.multiline,
            maxLines: null,
            expands: true,
            style: TextStyle(color: Color(0xFF5A6F84)),
            decoration: InputDecoration(
              labelText: "LogVisit.enter_description".tr().toString(), // 👈 floating label
              labelStyle: TextStyle(
                color: Color(0xFFA4B0C1),
                fontSize: 14,
              ),
              alignLabelWithHint: true, // 👈 ensures label stays at the top for multiline
              contentPadding: EdgeInsets.all(16),
              enabledBorder: showDescriptionError
                  ? OutlineInputBorder(borderSide: BorderSide(color: Color(0xFFB10000)))
                  : OutlineInputBorder(borderSide: BorderSide(color: Color(0xFFD1D7E0))),
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF4f2565), width: 1.0),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildSearchActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: EasyLocalization.of(context).locale == Locale("en", "US")
                ? "Actions"
                : "الإجراءات ",
            style: TextStyle(
              color: Color(0xff11120e),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            children: <TextSpan>[
              TextSpan(
                text: ' * ',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 10),
        Container(
          padding: EdgeInsets.only(left: 10, right: 5),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: showActionError ? Color(0xFFB10000) : Color(0xFFD1D7E0),
            ),
          ),
          child: DropdownSearch<String>.multiSelection(
            items: Action_options.map<String>((item) =>
            EasyLocalization.of(context).locale == Locale("en", "US")
                ? item['value']
                : item['valueAr']
            ).toList(),

            popupProps: PopupPropsMultiSelection.menu(
              showSelectedItems: true,
              showSearchBox: false,
            ),

            dropdownButtonProps: DropdownButtonProps(
              icon: Icon(Icons.expand_more, color: Colors.grey),
            ),

            dropdownDecoratorProps: DropDownDecoratorProps(
              dropdownSearchDecoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFD1D7E0)),
                ),
                hintText: EasyLocalization.of(context).locale == Locale("en", "US")
                    ? "Select Action"
                    : "حدد الإجراء ",
                hintStyle: TextStyle(
                  color: Color(0xFFD1D7E0),
                  fontSize: 14,
                ),
              ),
            ),

            selectedItems: selectAction,

            onChanged: (List<String> selectedValues) {
              setState(() {
                selectAction = selectedValues;

                // Update filtered actions based on selection
                if (selectedValues.isEmpty) {
                  filteredActions = Action_options;
                } else {
                  filteredActions = Action_options.where((action) {
                    return selectedValues.contains(action['value']);
                  }).toList();
                }

                // Update selectedActions keys only (e.g., for API)
                selectedActions = Action_options
                    .where((action) => selectedValues.contains(action['value']))
                    .map((action) => action['value'].toString())
                    .toList();

                // Update controller with comma-separated keys
                selectedActionController.text = selectedActions.join(',');
              });

              print("Selected Action Keys: $selectedActions");
              print("Controller Text: ${selectedActionController.text}");
            },
          ),
        ),
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Darak Log Visit'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 10,),
               buildSubject(),
              SizedBox(height: 20),
          buildDescription(),

              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: AppTextField(
                      labelText: "Reports.from".tr().toString(),
                      hintText: "Reports.dd/mm/yyyy".tr().toString(),
                      controller: startDateController,
                      isRequired: true,
                        readOnly: true,
                      isError: showStartDateError,
                      keyboardType: TextInputType.name,
                      onTap: () => pickDate(startDateController),

                        // Do something with the input

                    ),
                  ),

                  SizedBox(width: 10),
                  Expanded(
                    child: AppTextField(
                      labelText:  "Reports.to".tr().toString(),
                      hintText: "Reports.dd/mm/yyyy".tr().toString(),
                      controller: endDateController,
                      isRequired: true,
                      readOnly: true,
                      isError: showEndDateError,
                      keyboardType: TextInputType.name,
                      onTap: () => pickDate(endDateController),
                    ),
                  ),

                ],
              ),
              SizedBox(height: 20),
              buildMSISDN(),
              SizedBox(height: 20),
              buildAccountRegarding(),
              SizedBox(height: 20),
              buildSearchActions(),

              SizedBox(height: 20),
              isLoadingSubmit? SizedBox(
                child: CircularProgressIndicator(
                    color: Color(0xFF392156)),
                height: 20.0,
                width: 20.0,
              ):Container(),
              SizedBox(height: 20),
              Container(
                height: 48,
                width: 420,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: isLoadingSubmit ? Colors.grey : Color(0xFF4f2565),
                ),
                child: TextButton(

                  onPressed: isLoadingSubmit ?null:submitForm,
                  style: TextButton.styleFrom(
                    backgroundColor: isLoadingSubmit ? Colors.grey : Color(0xFF4f2565),
                    shape: const BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(24))),
                  ),
                  child: Text(
                    "alert.submit".tr().toString(),
                    style: TextStyle(
                        color: Colors.white,
                        letterSpacing: 0,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
