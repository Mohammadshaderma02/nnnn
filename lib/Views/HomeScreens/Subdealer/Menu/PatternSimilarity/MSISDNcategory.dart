import 'dart:async';
import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Dashboard/Dashboard.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/PatternSimilarity/ListOfNumbers.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/PatternSimilarity/ReservedNumbers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../Shared/BaseUrl.dart';
import 'package:http/http.dart' as http;
import '../../../Corporate/Multi_Use_Components/RequiredField.dart';


class MSISDN_Category extends StatefulWidget {
  //const MSISDN_Category({Key? key}) : super(key: key);

  @override
  State<MSISDN_Category> createState() => _MSISDN_CategoryState();
}
APP_URLS urls = new APP_URLS();

class _MSISDN_CategoryState extends State<MSISDN_Category> {
  List listOfReservedMSISDN = [];
  DateTime backButtonPressedTime;
  bool isLooding = false;
  TextEditingController msisdn = TextEditingController();
  var Permessions = [];
  var role;
  var outDoorUserName;

  bool emptyMSISDN = false;
  bool errorMSISDN = false;

  bool emptyType = false;
  var type;
  var listOfNumbers=[];




  void initState() {
    super.initState();
    print("*******************************************************");
    getReservedMSISDNsAPI ();
    print(msisdn.text);
    if(msisdn.text.length != 0){
      setState(() {
        msisdn.text='';
      });
    }

  }
//listOfReservedMSISDN.length==0
  getReservedMSISDNsAPI ()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var apiArea = urls.BASE_URL + '/Lines/msisdn/reserved/list';
    final Uri url = Uri.parse(apiArea);
    print(url);
    final response = await http.get(url, headers: {
      "content-type": "application/json",
      "Authorization": prefs.getString("accessToken")
    },);
    int statusCode = response.statusCode;
    print('TOKEN');
    print(prefs.getString("accessToken"));

    print("statusCode");
    print(statusCode);
    print('body: [${response.body}]');

    if (statusCode == 500) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(EasyLocalization.of(context).locale == Locale("en", "US")?statusCode.toString():statusCode.toString())));

    }
    if(statusCode==401 ){
      print('401  error ');

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(EasyLocalization.of(context).locale == Locale("en", "US")?statusCode.toString():statusCode.toString())));

    }
    if (statusCode == 200) {


      var result = json.decode(response.body);



      if( result["status"]==0){
        if(result["data"]==null||result["data"].length==0){
          prefs.setString('isThereReserved', 'False');
         // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("PatternSimilarity.EmptyData".tr().toString())));

          setState(() {
            listOfReservedMSISDN=[];
          });
        }else{
         // prefs.setString('isThereReserved', 'True');

          print(result["data"]);
          setState(() {
            listOfReservedMSISDN=result["data"];
          });


        }

      }else{
       // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(EasyLocalization.of(context).locale == Locale("en", "US")?result["message"]:result["messageAr"])));
      }
      return result;
    }else{
     // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(EasyLocalization.of(context).locale == Locale("en", "US")?statusCode.toString():statusCode.toString())));

    }
  }



  Widget enterMSISDN() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: EasyLocalization.of(context).locale == Locale("en", "US")
                ? 'Enter MSISDN'
                : "أدخل رقم",
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
        SizedBox(height: 5),
        Container(

          alignment: Alignment.centerLeft,
          height: 70,
          child: TextField(
           // maxLength: 10,
            controller: msisdn,
            keyboardType: TextInputType.phone,
            style: TextStyle(color: Color(0xff11120e)),
            decoration: InputDecoration(
              filled: true,
               fillColor:Colors.white,
              enabledBorder: emptyMSISDN == true || errorMSISDN ==true
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
              hintText: "079xxxxxxx",
              hintStyle: TextStyle(color: Color(0xFFA4B0C1), fontSize: 14),
            ),
            onChanged: (msisdn){
              print("haya");
            if (msisdn.length < 3) {
              setState(() {
                emptyMSISDN=false;
                errorMSISDN=true;

              });
              print("aya");

            } else {
              setState(() {
                emptyMSISDN=false;
                errorMSISDN=false;
              });
            }
            },
          ),
        ),
    errorMSISDN==true && type=='0'? RequiredFeild(

    text: EasyLocalization.of(context).locale == Locale("en", "US")
        ? 'Minimum of 3 digits'
        : "3 أرقام كحد أدنى")
        : Container(),
      ],
    );
  }

  Widget searchType() {
    return Container(
      height: 100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          RichText(
            text: TextSpan(
              text: EasyLocalization.of(context).locale == Locale("en", "US")
                  ? 'Select Search Type'
                  : "اختر نوع البحث" ,
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
                  color:emptyType== true
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
                    icon:  Icon(Icons.keyboard_arrow_down_rounded),
                    iconSize: 30,
                    iconEnabledColor: Colors.grey,
                    underline: SizedBox(),
                    isExpanded: true,
                    style: TextStyle(
                      color: Color(0xff11120e),
                      fontSize: 14,
                    ),
                    items:[
                      DropdownMenuItem<String>(
                        value: "0" ,
                        child: Text("Similarity"),
                      ), DropdownMenuItem<String>(
                        value: "1",
                        child: Text("Similarity with Shuffle "),
                      )
                    ].toList()

                    ,
                    value: type,
                    onChanged: (String newValue) {
                      if(newValue != null){
                        setState(() {
                          emptyType=false;
                        });
                      }
                      setState(() {
                        type = newValue;

                      });
                      print(type);





                    },
                  ),
                ),
              )),
          emptyType==true? RequiredFeild(
              text:  EasyLocalization.of(context).locale == Locale("en", "US")
                  ? 'This field is required'
                  : "هذا الحقل مطلوب")
              : Container(),
        ],
      ),
    );
  }

  Widget buildSearchBtn() {
    return Column(
        children :[
          Container(
            height: 48,
            width:400,
            margin: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50), color: Color(0xFF4f2565)),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF4f2565),
                textStyle: TextStyle(fontSize: 16),
                minimumSize: Size.fromHeight(30),
                shape: StadiumBorder(),
              ),
              child: isLooding?Row(mainAxisAlignment: MainAxisAlignment.center,
              children: [Text(EasyLocalization.of(context).locale == Locale("en", "US")?"Please wait":"يرجى الانتظار"),
              const SizedBox(width: 24,),
                CircularProgressIndicator(color: Colors.white,)],):Text(EasyLocalization.of(context).locale == Locale("en", "US")?"Search":"ابحث",style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold
              )),
              onPressed: ()async{
                if(isLooding) return;

                if(msisdn.text.length ==0 ){
                  setState(() {
                    emptyMSISDN=true;
                  });
                }
                if(msisdn.text.length<3 && type.text=='0'){
                  setState(() {
                    errorMSISDN=true;
                  });
                }
                if(type == null){
                  setState(() {
                    emptyType=true;
                  });
                }
                if(type != null && msisdn.text.length !=0){
                  if(type=='0' && msisdn.text.length>=3){
                    setState(() {
                      isLooding =true;
                    });
                    searchAPI();
                  }
                  if(type=='1'){
                    setState(() {
                      isLooding =true;
                    });
                    searchAPI();
                  }

                }

              },
            )
            /*TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Color(0xFF4f2565),
                shape: const BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(24))),
              ),
              onPressed: () {
                if(msisdn.text.length ==0 ){
                  setState(() {
                    emptyMSISDN=true;
                  });
                }
                if(msisdn.text.length<3 && type.text=='0'){
                  setState(() {
                    errorMSISDN=true;
                  });
                }
                if(type == null){
                  setState(() {
                    emptyType=true;
                  });
                }
                if(type != null && msisdn.text.length !=0){
                  if(type=='0' && msisdn.text.length>=3){
                    searchAPI();
                  }
                  if(type=='1'){
                    searchAPI();
                  }

                }

              },

              child: Text(
                "Search",
                style: TextStyle(
                    color: Colors.white,
                    letterSpacing: 0,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
            ),*/
          ),]
    );
  }

  Widget reservedNumbersBtn(){
    return Column(
        children :[
          Container(
            height: 48,
            width:400,
            margin: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50), color: Color(0xFF4f2565)),
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Color(0xFF4f2565),
                shape: const BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(24))),
              ),
              onPressed: ()async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                if(listOfReservedMSISDN.length!=0){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ReservedNumbers(),
                    ),
                  );
                }else{
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(EasyLocalization.of(context).locale == Locale("en", "US")?
                  "There is no reserved numbers ":"لا توجد أرقام محجوزة")));
                }
              /*  if(prefs.getString('isThereReserved')=='True'){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ReservedNumbers(),
                    ),
                  );
                }else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(EasyLocalization.of(context).locale == Locale("en", "US")?
                  "There is no reserved numbers ":"لا توجد أرقام محجوزة")));

                }*/

              },

              child: Text(
                EasyLocalization.of(context).locale == Locale("en", "US")
                    ? 'Reserved Numbers'
                    : "الأرقام المحجوزة",
                style: TextStyle(
                    color: Colors.white,
                    letterSpacing: 0,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),]
    );
  }


 /********************************************** APIS  **********************************************/
  void searchAPI() async{

    SharedPreferences prefs = await SharedPreferences.getInstance();

    var apiArea = urls.BASE_URL+'/Lines/msisdn/search';
    final Uri url = Uri.parse(apiArea);
    prefs.getString("accessToken");
    final access = prefs.getString("accessToken");
    print(url);

    Map body = {
      "text":msisdn.text,
      "type": type,
    };
    final response = await http.post(url, headers: {
      "content-type": "application/json",
      "Authorization": prefs.getString("accessToken")
    }, body: json.encode(body),);
    int statusCode = response.statusCode;
    var data = response.request;
    print(statusCode);
    print(json.encode(body));
    print(response);
    print('body: [${response.body}]');
    if (statusCode == 500) {
      print('500  error ');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(EasyLocalization.of(context).locale == Locale("en", "US")?statusCode.toString():statusCode.toString())));

    }
    if (statusCode == 401) {
      print('401  error ');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(EasyLocalization.of(context).locale == Locale("en", "US")?statusCode.toString():statusCode.toString())));

    }

    if (statusCode == 200) {
      var result = json.decode(response.body);
      print(result);
      setState(() {
        // isLoading=false;

      });
      if( result["status"]==0){
        setState(() {
          isLooding =false;
        });
        if(result["data"]==null||result["data"].length==0){
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("PatternSimilarity.EmptyData".tr().toString())));
        }else{
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("PatternSimilarity.Success".tr().toString())));

          setState(() {
            listOfNumbers=result["data"];
          });
          print("listOfNumbers");
          print(listOfNumbers);
          Timer(
            Duration(seconds: 1),
                () =>   Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ListOfNumbers(this.listOfNumbers,msisdn.text,type),
                  ),
                ),
          );

        }
      }else{
        //  showAlertDialogERROR(context,result["messageAr"], result["message"]);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(EasyLocalization.of(context).locale == Locale("en", "US")?result["message"]:result["messageAr"])));

        setState(() {
          isLooding =false;
        });

      }




      return result;
    }else{
      //   showAlertDialogOtherERROR(context,statusCode, statusCode);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(EasyLocalization.of(context).locale == Locale("en", "US")?statusCode.toString():statusCode.toString())));

      setState(() {
        isLooding =false;
      });
    }
  }
  /******************************************** End APIS ********************************************/



  /******** for back button on mobile tap ******/
  Future<bool> onWillPop() async {
    DateTime currentTime = DateTime.now();
    bool backButton = backButtonPressedTime == null ||
        currentTime.difference(backButtonPressedTime) > Duration(seconds: 0);
    if (backButton) {
      backButtonPressedTime = currentTime;
      Navigator.pop(context);

      /*  Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => OrdersScreen()),
      );*/
     /* Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Dashboard(),
        ),
      );*/

      return true;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  //tooltip: 'Menu Icon',

                  onPressed: () async {
                    Navigator.pop(context);

                    /*  Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => OrdersScreen()),
                );  */
                  },
                ),
                centerTitle: false,
                title: Text(
                  EasyLocalization.of(context).locale == Locale("en", "US")
                      ? 'MSISDN Category'
                      : "فئة الأرقام",
                ),
                backgroundColor: Color(0xFF4f2565),
              ),
              backgroundColor: Color(0xFFEBECF1),
              body: Center(
                child: ListView(
                  shrinkWrap: true,
                  padding:
                      EdgeInsets.only(top: 0, bottom: 20, left: 32, right: 32),
                  children: <Widget>[
                    Center(
                      child: Image(
                          image: AssetImage('assets/images/SearchIcon.png'),
                          width: 184,
                          height: 184),
                    ),
                    SizedBox(height: 30,),
                    Center(child: searchType(),),
                    SizedBox(height: 10),
                    Center(
                      child: enterMSISDN(),
                    ),
                    emptyMSISDN==true?  SizedBox(height: 10):Container(),
                    emptyMSISDN==true?   RequiredFeild(
                        text:  EasyLocalization.of(context).locale == Locale("en", "US")
                            ? 'This field is required'
                            : "هذا الحقل مطلوب"):Container(),
                    SizedBox(height: 30,),
                    Center(child: buildSearchBtn() ,),
                    SizedBox(height: 15),
                    Center(child: reservedNumbersBtn() ,),
                    SizedBox(height: 15),
                  ],
                ),
              )),
        ),
        onWillPop: onWillPop);
  }
}
