import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/TawasolService/SpecialOffersScreen/Buy/ListNumber.dart';
import 'package:sales_app/blocs/TawasolServiceBlock/BuyList/BuyList_bloc.dart';
import 'package:sales_app/blocs/TawasolServiceBlock/BuyList/BuyList_events.dart';
import 'package:sales_app/blocs/TawasolServiceBlock/BuyList/BuyList_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';



class Buy extends StatefulWidget {
  List<dynamic> Permessions=[];
  var role;
  var outDoorUserName;
  Buy({this.Permessions,this.role,this.outDoorUserName});

  @override
  _BuyState createState() => _BuyState(this.Permessions,this.role,this.outDoorUserName);
}

class _BuyState extends State<Buy> {
  List<dynamic> Permessions=[];
  var role;
  var outDoorUserName;
  _BuyState(this.Permessions,this.role,this.outDoorUserName);
  BuyListBloc buyListBloc;
  List<dynamic> NumberTypeList =[];
  String categoryID;
  @override
  void initState() {
    super.initState();
    buyListBloc = BlocProvider.of<BuyListBloc>(context);
    buyListBloc.add(BuyListFetchEvent());
  }
  final msg = BlocBuilder<BuyListBloc,
      BuyListState>(builder: (context, state) {
    if (state is BuyListLoadingState) {
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
              },
            ),
            centerTitle:false,
            title: Text(
              "Menu_Form.buy".tr().toString(),
            ),
            backgroundColor: Color(0xFF4f2565),
          ),
          backgroundColor: Color(0xFFEBECF1),
          body: ListView(
              physics: ClampingScrollPhysics(),
              shrinkWrap: true,
              padding: EdgeInsets.only(top: 8),
              children: <Widget>[
                BlocBuilder<BuyListBloc,BuyListState>(
                    builder: (context,state){
                      // ignore: missing_return
                      if(state is BuyListLoadingState){

                      return Center(child: Container(
                      padding: EdgeInsets.only(bottom: 10),
                      child: CircularProgressIndicator(
                      valueColor:AlwaysStoppedAnimation<Color>(Color(0xFF4F2565)),
                      ),
                      ));




                      }else if(state is BuyListInitState){
                        return Container();
                      }
                      else if(state is BuyListSuccessState){
                        return ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            physics: ClampingScrollPhysics(),
                            itemCount : state.data.length,
                            itemBuilder:(context,index){
                              return Container(
                                color: Colors.white,
                                child: Column(
                                    children:[
                                      SizedBox(
                                        height: 50,
                                        child: ListTile(
                                          title: Text(
                                              EasyLocalization.of(context).locale ==
                                                  Locale("en", "US")
                                                  ? state.data[index]['value']
                                                  : state.data[index]['valueAr'],
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
                                          onTap : () => {
                                            setState(() {
                                            categoryID = state.data[index]['key'];}),
                                            print("categoryID"),
                                            print(categoryID),
                                            Navigator.of(context).push(MaterialPageRoute(builder:(context)=>
                                                ListNumber(categoryID:categoryID,Permessions:Permessions,role:role,outDoorUserName:outDoorUserName,))),
                                         }

                                        ),
                                      ),
                                      Divider(
                                        thickness: 1,
                                        color: Color(0xFFedeff3),
                                      ),
                                    ]
                                ),

                              );

                           }
                        );

                      }
                      else{
                      }return Container();
                    }

                ),
              ])

      ),
    );
  }
}




