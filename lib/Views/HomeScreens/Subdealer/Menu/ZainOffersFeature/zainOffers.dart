import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../../../../Shared/BaseUrl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../ReusableComponents/headerSection.dart';

APP_URLS urls = new APP_URLS();

class ZainOffersScreen extends StatefulWidget {
  List<dynamic> Permessions;

  ZainOffersScreen(this.Permessions);

  @override
  State<ZainOffersScreen> createState() => _ZainOffersScreenState(this.Permessions);
}

class _ZainOffersScreenState extends State<ZainOffersScreen> {
  _ZainOffersScreenState(this.Permessions);

  List<dynamic> Permessions;
  List<dynamic> offers = [];
  bool isLoading = false;
  bool hasFetchedData = false;


  @override
  void initState() {
    // TODO: implement initState
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!hasFetchedData) {
      getOffersData(); // safe to use context here
      hasFetchedData = true;
    }
  }

  Future<void> getOffersData() async {
    print('heeey');
    setState(() => isLoading = true);

    final lang = EasyLocalization.of(context).locale.languageCode;
    final url = Uri.parse("https://www.jo.zain.com/PortalMW/api/public/zain-magazine?lang=$lang");
    final response = await http.get(url);
    print(response.body);
    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      if (result["Status"] == 0 && result["Data"] != null) {
        setState(() {
          offers = result["Data"];
        });
      }
    } else {
      print("Failed to load offers");
    }

    setState(() => isLoading = false);
  }


  void launchOfferUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              context.locale.languageCode == 'en' ?   'Offer Details'
              : "تفاصيل العروض",
            ),
            backgroundColor: Color(0xFF4f2565),

          ),

          backgroundColor: Color(0xFFEBECF1),
          body: SingleChildScrollView(
            child:
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            EasyLocalization.of(context).locale == Locale("en", "US")
                                ? "Zain Offers"
                                : "عروض زين",
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          Text(
                            EasyLocalization.of(context).locale == Locale("en", "US")
                                ? "All offers in a one place just for you."
                                : "كل العروض في مكان واحد من أجلك.",
                            style: TextStyle(fontSize: 14, color: Colors.black54),
                          ),
                        ],
                      ),
                      Container(

                        child: GestureDetector(
                          onTap: context.locale.toString() == "en_US"?
                              () async {
                            SharedPreferences prefs = await SharedPreferences.getInstance();
                            context.setLocale(Locale('ar', 'AR'))  ;
                            prefs.setInt('lang',2);
                            getOffersData();

                          } :()async{
                            SharedPreferences prefs = await SharedPreferences.getInstance();
                            context.setLocale(Locale('en', 'US')) ;

                            prefs.setInt('lang',1);
                            getOffersData();

                          },
                          child: RichText(
                            text: TextSpan(
                              children: <TextSpan>[
                                TextSpan(
                                  text: "Login_Form.language".tr().toString(),
                                  style: TextStyle(fontSize: 16, color: Colors.black,fontWeight: FontWeight.bold,  decoration: TextDecoration.underline,),)
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  )

                ),
                isLoading==true?
                Padding(
                    padding: const EdgeInsets.only(top:300.0),
                  child:
                Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFF392156),
                    backgroundColor: Colors.transparent,
                  )),
                ):ListView.builder(
                  physics: NeverScrollableScrollPhysics(), // Important inside SingleChildScrollView
                  shrinkWrap: true,
                  itemCount: offers.length,
                  itemBuilder: (context, index) {
                    final offer = offers[index];
                    return GestureDetector(
                      onTap: () {
                        // You can use `url_launcher` to open the link
                        launchOfferUrl(offer['Link']);
                      },
                      child: Container(
                        height: 400,
                        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(8),
                                topRight: Radius.circular(8),
                              ),                              child:  offer['ImageLink'] != null?
                             Image.network(offer['ImageLink']):null,
                             ),
                            SizedBox(height: 8),
                            Text(
                              offer['Title'] ?? '',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                            SizedBox(height: 8),
                          ],
                        ),
                      ),
                    );
                  },
                )
              ],
            ),
          ),



        ));
  }
}


class Offer {
  final String ImageLink;
  final String Link;
  final String Title;
  final int Ordering;

  Offer({ this.Link,  this.ImageLink,  this.Title, this.Ordering});
}