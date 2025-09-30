import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_app/Views/ReusableComponents/requiredText.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:sales_app/blocs/TawasolServiceBlock/PosNetOffer_GetPackages/GetPackages_block.dart';
import 'package:sales_app/blocs/TawasolServiceBlock/PosNetOffer_GetPackages/GetPackages_state.dart';
import 'package:sales_app/blocs/TawasolServiceBlock/PosNetOffer_GetPackages/GetPackages_events.dart';

import 'package:sales_app/blocs/TawasolServiceBlock/ChangePackagePreToPreRqTawasol/ChangePackagePreToPreRqTawasol_bloc.dart';
import 'package:sales_app/blocs/TawasolServiceBlock/ChangePackagePreToPreRqTawasol/ChangePackagePreToPreRqTawasol_state.dart';
import 'package:sales_app/blocs/TawasolServiceBlock/ChangePackagePreToPreRqTawasol/ChangePackagePreToPreRqTawasol_events.dart';

import 'package:flutter_styled_toast/flutter_styled_toast.dart';

import 'TawasolServices.dart';

class PosNetOffer extends StatefulWidget {
  final List<dynamic> Permessions;

  var role;
  var outDoorUserName;
  PosNetOffer({this.Permessions,this.role,this.outDoorUserName});
  @override
  _PosNetOfferState createState() => _PosNetOfferState(this.Permessions,this.role,this.outDoorUserName);
}

class _PosNetOfferState extends State<PosNetOffer> {
  final List<dynamic> Permessions;

  var role;
  var outDoorUserName;
  _PosNetOfferState(this.Permessions,this.role,this.outDoorUserName);
  bool emptyTawasolNumber = false;
  bool emptyDataLine = false;
  bool emptyKitCode = false;
  var response ;
  bool errorTawasolNumber = false;
  bool errorDataLine = false;
  bool errorKitCode = false;
  String ActivePackageArabic ;
  String ActivePackageEnglish ;

  bool NoActiveFlag =false;
  List<dynamic> data ;
  var lengthOfData;

  GetPackageBloc getPackageBloc;
  ChangePackagePreToPreRqTawasolBloc changePackagePreToPreRqTawasolBloc;

  FocusNode tawasolnumberFocusNode;

  TextEditingController tawasolnumber = TextEditingController();
  TextEditingController dataline = TextEditingController();
  TextEditingController kitcode = TextEditingController();


  @override
  void initState() {
    super.initState();
    super.initState();
    tawasolnumberFocusNode = FocusNode();
    getPackageBloc = BlocProvider.of<GetPackageBloc>(context);
    changePackagePreToPreRqTawasolBloc = BlocProvider.of<ChangePackagePreToPreRqTawasolBloc>(context);

  }
  final msg = BlocBuilder<GetPackageBloc,
      GetPackageState>(builder: (context, state) {
    if (state is GetPackageLoadingState) {
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


  final msgTwo = BlocBuilder<ChangePackagePreToPreRqTawasolBloc, ChangePackagePreToPreRqTawasolState>(builder: (context, state) {
    if (state is ChangePackagePreToPreRqTawasolLoadingState) {
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
    tawasolnumberFocusNode.dispose();
  }

  Widget dataLine() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: "Menu_Form.data_line".tr().toString(),
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
            controller: dataline,
            keyboardType: TextInputType.phone,
            style: TextStyle(color: Color(0xff11120e)),
            decoration: InputDecoration(
              enabledBorder: emptyDataLine== true || errorDataLine==true
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


  showAlertDialogConvert(BuildContext context, arabicMessage, englishMessage) {
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


  Widget kitCode() {
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
            controller: kitcode,
            keyboardType: TextInputType.phone,
            style: TextStyle(color: Color(0xff11120e)),
            decoration: InputDecoration(
              enabledBorder: emptyKitCode== true
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
        dataline.clear();
        kitcode.clear();
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

  @override
  Widget build(BuildContext context) {
    return BlocListener<GetPackageBloc, GetPackageState>(
    listener: (context, state) {
    if (state is GetPackageErrorState) {
    showAlertDialog(context, state.arabicMessage, state.englishMessage);
    }
    if (state is GetPackageSuccessState) {
      setState(() {
        response=1;
      });
    }
    },
      child:  GestureDetector(
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
                "Menu_Form.pos_net_offer".tr().toString(),
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
                          dataLine(),
                          emptyDataLine == true
                              ? ReusableRequiredText(
                              text: "Menu_Form.serial_numbe_required"
                                  .tr()
                                  .toString())
                              : Container(),
                          errorDataLine == true
                              ? ReusableRequiredText(
                              text: EasyLocalization.of(context).locale ==
                                  Locale("en", "US")
                                  ? "Data Line shoud be 10 digits and start with 079"
                                  : "رقم خط الانترنت يجب أن يتكون من 10 أرقام ويبدأ ب 079"): Container(),
                          SizedBox(height: 20),
                          kitCode(),
                          emptyKitCode == true
                              ? ReusableRequiredText(
                              text: "Menu_Form.kit_required".tr().toString())
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

              msg,
              msgTwo,


          Container(
              height: 48,
              width: 420,
              margin: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Color(0xFF4f2565),
              ),

            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor:Color(0xFF4f2565),
                shape: const BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(24))),
              ),
              onPressed: () {
                FocusScope.of(context).unfocus();
                if (dataline.text == '') {
                  setState(() {
                    errorDataLine = false;
                    emptyDataLine = true;
                  });
                }
                if (dataline.text != '') {
                  if(dataline.text.length == 10 ){
                    if( dataline.text.substring(0, 3) == '079'){
                      setState(() {
                        errorDataLine = false;
                        emptyDataLine=false;
                      });}
                  }else {
                    setState(() {
                      errorDataLine = true;
                      emptyDataLine=false;
                    });
                  }
                }


                if (kitcode.text == '') {
                  setState(() {
                    emptyKitCode = true;
                  });
                }
                else{
                  setState(() {
                    emptyKitCode = false;
                  });
                }

                if (kitcode.text != '' && dataline.text != '' && dataline.text.length == 10 && dataline.text.substring(0, 3) == '079') {

                  getPackageBloc.add(PackageButtonPressed(dataline.text));
                }
              },

              child: Text(
                "Menu_Form.get_data_line_packages".tr().toString(),
                style: TextStyle(
                    color: Colors.white,
                    letterSpacing: 0,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
              SizedBox(height: 20),
            response==1?

            Container(
              padding:
              EdgeInsets.only(left: 16, right: 10, top: 8, bottom: 15),
              //margin: EdgeInsets.only(top: 20),
              child: Text(
                "Menu_Form.Active_Pakeges".tr().toString(),
                style: TextStyle(
                  color: Color(0xFF11120e),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,

                ),
              ),
            ):Container(),


              response==1? BlocBuilder<GetPackageBloc, GetPackageState>(
                builder: (context,state){
                 if(state is GetPackageSuccessState){

                   print(state.data);
                    return Container(
                      color: Colors.white,
                      child: Center(
                        child: state.data.length!=0? ListView.builder(
                            shrinkWrap: true,
                            physics: ClampingScrollPhysics(),
                            itemCount : state.data.length,
                            itemBuilder:(context,index){
                              return Container(
                                color: Colors.white,
                                child: Column(
                                    children:[
                                      SizedBox(
                                        height: 55,
                                        child: ListTile(
                                            title: Text(
                                              EasyLocalization.of(context).locale == Locale("en", "US")
                                                  ? state.data[index]['englishDescription']
                                                  : state.data[index]['arabicDescription'],
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Color(0xff11120e),
                                                  fontWeight: FontWeight.normal),
                                            ),
                                            trailing:  GestureDetector(
                                                child: BlocListener<ChangePackagePreToPreRqTawasolBloc, ChangePackagePreToPreRqTawasolState>(
                                                  listener: (context, state) {
                                                    if(state is ChangePackagePreToPreRqTawasolLoadingState){

                                                      showToast(
                                                          EasyLocalization.of(context).locale == Locale("en", "US")
                                                              ?  "TawasolService.verifying".tr().toString()
                                                              :  "TawasolService.verifying".tr().toString(),
                                                          context: context,
                                                          animation: StyledToastAnimation.fadeScale,
                                                          fullWidth: true);



                                                    }
                                                    if (state is ChangePackagePreToPreRqTawasolErrorState) {
                                                      showAlertDialogConvert(context, state.arabicMessage, state.englishMessage);


                                                    }

                                                    if (state is ChangePackagePreToPreRqTawasolSuccessState) {


                                                      showToast(
                                                          EasyLocalization.of(context).locale == Locale("en", "US")
                                                              ? state.englishMessage
                                                              : state.arabicMessage,
                                                          context: context,
                                                          animation: StyledToastAnimation.scale,
                                                          fullWidth: true);
                                                      Navigator.pop(
                                                        context,
                                                      );

                                                    }
                                                  },


                                                  child: Container(
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        return showDialog(
                                                          context: context,
                                                          builder: (ctx) => AlertDialog(
                                                            title:  new Text(
                                                              "TawasolService.Convert_Package".tr().toString(),

                                                              style: TextStyle(
                                                                  color: Color(0xff000000),
                                                                  fontSize: 16,
                                                                  fontWeight: FontWeight.bold),
                                                            ),
                                                            content: Text(
                                                              "TawasolService.Ask_to_convert_package".tr().toString(),

                                                              style: TextStyle(
                                                                  color: Color(0xff000000),
                                                                  fontSize: 16,
                                                                  fontWeight: FontWeight.normal),
                                                            ),
                                                            actions: <Widget>[
                                                              TextButton(
                                                                onPressed: () {
                                                                  Navigator.of(ctx).pop();
                                                                  changePackagePreToPreRqTawasolBloc.add(ChangePackagePreToPreRqFetchTawasolEvent(kitcode.text,dataline.text, state.data[index]['packageCode'],true));
                                                                },
                                                                child: Text("TawasolService.OK".tr().toString(),

                                                                  style: TextStyle(
                                                                    color: Color(0xFF4f2565),
                                                                    fontSize: 16,
                                                                  ),
                                                                ),
                                                              ),

                                                              TextButton(
                                                                onPressed: () {
                                                                  Navigator.of(ctx).pop();
                                                                },
                                                                child: Text("TawasolService.Cancel".tr().toString(),

                                                                  style: TextStyle(
                                                                    color: Color(0xFF4f2565),
                                                                    fontSize: 16,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                      },

                                                      child: new Text(
                                                        "TawasolService.convert".tr().toString(),
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(
                                                            color: Color(0xff0070c9),
                                                            fontSize: 16,
                                                            fontWeight: FontWeight.w600),
                                                      ),),),



                                                )




                                            ),
                                        ),
                                      ),
                                      index != state.data.length-1 ?
                                      Divider(
                                        thickness: 1,
                                        color: Color(0xFFedeff3),
                                      ):Container(),
                                    ]
                                ),

                              );
                            }
                        ):'',

                      ),
                    );
                  }

                  else{
                    return  Container();
                  }
                },
              ):Container(),







            ]),
          ),
      )
    );
  }}














