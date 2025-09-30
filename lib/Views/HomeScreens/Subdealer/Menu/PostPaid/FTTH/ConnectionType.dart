import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/PostPaid/FTTH/contract_details.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/PostPaid/GSM/GSM_Package.dart';
import 'package:sales_app/Views/LoginScreens/SignInScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/Menu.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/PostPaid/FTTH/FTTHpackage.dart';
import 'package:sales_app/blocs/PostPaid/PostpaidEligiblePackages/PostpaidEligiblePackages_block.dart';
import 'package:sales_app/blocs/PostPaid/PostpaidEligiblePackages/PostpaidEligiblePackages_events.dart';
import 'package:sales_app/blocs/PostPaid/PostpaidEligiblePackages/PostpaidEligiblePackages_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';


import '../../../CustomBottomNavigationBar.dart';


class ConnectionType extends StatefulWidget {
  final List<dynamic> Permessions;
  var role;
  var outDoorUserName;
  var marketType;
  bool MADA_Activat;
  ConnectionType({this.Permessions,this.role,this.outDoorUserName,this.marketType,this.MADA_Activat});

  @override
  _ConnectionTypeState createState() => _ConnectionTypeState(this.Permessions,this.role,this.outDoorUserName,this.marketType,this.MADA_Activat);
}

class _ConnectionTypeState extends State<ConnectionType> {
  final List<dynamic> Permessions;
  var role;
  var outDoorUserName;
  String marketType;
  _ConnectionTypeState(this.Permessions,this.role,this.outDoorUserName,this.marketType,this.MADA_Activat);
  bool response= false;
  String packagesSelect;
  String connectionTypes;
  bool MADA_Activat;

  PostpaidEligiblePackagesBlock postpaidEligiblePackages;
  PostpaidEligiblePackagesBlock postpaidEligiblePackagesBlock;

  final msg = BlocBuilder<PostpaidEligiblePackagesBlock,
      PostpaidEligiblePackagesState>(builder: (context, state) {
    if (state is PostpaidEligiblePackagesStateLoadingState) {
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
  void initState() {
    super.initState();

    postpaidEligiblePackagesBlock = BlocProvider.of<PostpaidEligiblePackagesBlock>(context);
    //postpaidEligiblePackages.add(PostpaidEligiblePackagesSelect());
    postpaidEligiblePackagesBlock.add(PostpaidEligiblePackagesSelect(marketType:marketType));
    print("MADA_Activat");
    print(MADA_Activat);
    print(marketType);
    print("TESTING");
  }
  @override

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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

                /*Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CustomBottomNavigationBar(),
                  ),
                );*/
              },
            ),
            centerTitle:false,

            title: Text(
              "Menu_Form.ConnectionType".tr().toString(),
            ),
            backgroundColor: Color(0xFF4f2565),
          ),
          backgroundColor: Color(0xFFEBECF1),
          body: ListView(padding: EdgeInsets.only(top: 8),
              children: <Widget>[
                BlocBuilder<PostpaidEligiblePackagesBlock,PostpaidEligiblePackagesState>(
                    builder: (context,state){
                      // ignore: missing_return
                      if(state is PostpaidEligiblePackagesStateLoadingState){
                        return Container(
                          padding: EdgeInsets.only(top: 10),
                          child: Center(
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4f2565)),
                                  ),SizedBox(height: 20,),
                                  Text("DashBoard_Form.loading".tr().toString(),
                                    style: TextStyle(
                                      color:Colors.grey,
                                      fontSize: 16,
                                    ),
                                  )

                                ]
                            ),
                          ),
                        );

                      }
                      else if(state is PostpaidEligiblePackagesStateInitState){
                        return Container();
                      }
                      else if(state is PostpaidEligiblePackagesStateSuccessState){
                        List<dynamic> test =state.data;
                        List<dynamic> test2 =[];
                        for(var i=0; i< state.data.length;i++){
                          test2.add(test[i]['subGroup']);
                        }
                        var seen = Set<dynamic>();
                        List<dynamic> uniquelist = test2.where((country) => seen.add(country)).toList();
                       // print("uniquelist");
                        //print(uniquelist);

                        return Container(
                            padding: EdgeInsets.only(bottom: 8),
                            child: ListView.builder(
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                physics: ClampingScrollPhysics(),
                                itemCount : uniquelist.length,
                                itemBuilder:(context,index){
                                  return Container(
                                    color: Colors.white,
                                    child: Column(
                                        children:[
                                          SizedBox(
                                            height:index  !=  uniquelist.length-1 ? 50 :55,
                                            child: ListTile(
                                              title: Text(
                                                EasyLocalization.of(context).locale ==
                                                    Locale("en", "US")
                                                    ? uniquelist[index]
                                                    :  uniquelist[index],
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    letterSpacing: 0,
                                                    color: Color(0xff11120e),
                                                    fontWeight: FontWeight.normal),
                                              ),



                                              trailing: IconButton(
                                                icon: EasyLocalization.of(context).locale ==
                                                    Locale("en", "US")
                                                    ? Icon(Icons.keyboard_arrow_right)
                                                    : Icon(Icons.keyboard_arrow_left),

                                              ),
                                              onTap: () {
                                                setState(() {
                                                  packagesSelect="FTTH";
                                                  connectionTypes=uniquelist[index];
                                                });
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) => FTTHpackage(connectionTypes:connectionTypes,Permessions:Permessions,role:role,
                                                        outDoorUserName:outDoorUserName,
                                                        marketType:packagesSelect,
                                                        MADA_Activat:MADA_Activat),
                                                  ),
                                                );

                                              },




                                            ),
                                          ),
                                          index!= uniquelist.length-1 ?
                                          Divider(
                                            thickness: 1,
                                            color: Color(0xFFedeff3),
                                          ):Container(),
                                        ]
                                    ),

                                  );

                                }
                            )

                        );

                      }
                      else{
                      }return Container();
                    }

                ),
              ]
          )),
    );

  }
}




//////
/**/


/*
*[
                    Permessions.contains('05.02.03')==true?
                    SizedBox(
                      height: 50,
                      child: ListTile(
                        title: Text(
                          "ZainFiber",
                          style: TextStyle(
                              fontSize: 16,
                              color: Color(0xff11120e),
                              fontWeight: FontWeight.normal),
                        ),
                        trailing: IconButton(
                          icon: EasyLocalization.of(context).locale ==
                              Locale("en", "US")
                              ? Icon(Icons.keyboard_arrow_right)
                              : Icon(Icons.keyboard_arrow_left),

                        ),
                        onTap: () {
                           setState(() {
                            packagesSelect="FTTH";
                            connectionTypes="ZainFiber";
                          });
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FTTHpackage(connectionTypes:connectionTypes,Permessions:Permessions,role:role,
                                  outDoorUserName:outDoorUserName,
                                  marketType:packagesSelect),
                            ),
                          );

                        },
                      ),
                    ):Container(),
                    Permessions.contains('05.02.01')==true?Divider(
                      thickness: 1,
                      color: Color(0xFFedeff3),
                    ):Container(),
                    Permessions.contains('05.02.01')==true? SizedBox(
                      height: 50,
                      child: ListTile(
                        title: Text(
                          "Fibertech",
                          style: TextStyle(
                              fontSize: 16,
                              color: Color(0xff11120e),
                              fontWeight: FontWeight.normal),
                        ),
                        trailing: IconButton(
                          icon: EasyLocalization.of(context).locale ==
                              Locale("en", "US")
                              ? Icon(Icons.keyboard_arrow_right)
                              : Icon(Icons.keyboard_arrow_left),

                        ),
                        onTap: () {
                          setState(() {
                            packagesSelect="FTTH";
                            connectionTypes="Fibertech";
                          });
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FTTHpackage(connectionTypes:connectionTypes,Permessions:Permessions,role:role,
                                  outDoorUserName:outDoorUserName,
                                  marketType:packagesSelect),
                            ),
                          );

                        },
                      ),
                    ):Container(),
                    Permessions.contains('05.02.02')==true?Divider(
                      thickness: 1,
                      color: Color(0xFFedeff3),
                    ):Container(),
                    Permessions.contains('05.02.02')==true?
                    SizedBox(
                      height: 50,
                      child: ListTile(
                        title: Text(
                          "NaiTel",
                          style: TextStyle(
                              fontSize: 16,
                              color: Color(0xff11120e),
                              fontWeight: FontWeight.normal),
                        ),
                        trailing: IconButton(
                          icon: EasyLocalization.of(context).locale ==
                              Locale("en", "US")
                              ? Icon(Icons.keyboard_arrow_right)
                              : Icon(Icons.keyboard_arrow_left),

                        ),



                        onTap: () {
                          setState(() {
                            packagesSelect="FTTH";
                            connectionTypes="NaiTel";

                          });
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FTTHpackage(connectionTypes:connectionTypes,Permessions:Permessions,role:role,
                                  outDoorUserName:outDoorUserName,
                                  marketType:packagesSelect),
                            ),
                          );

                        },
                      ),
                    ):Container(),

                  ]*/