import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/newAccountsDocumentsChecking.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/Multi_Use_Components/CorpNavigationBar.dart';
import 'package:sales_app/Views/HomeScreens/DeliveryEShop/Eshope_Menu.dart';
import 'package:sales_app/Views/HomeScreens/DeliveryEShop/OrdersScreen.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/CustomBottomNavigationBar.dart';
import 'package:sales_app/Views/Biometric/Biometric_FingerPrint.dart';
import 'package:sales_app/Views/HomeScreens/ZainOutdoorHeads/ZainOutdoorHeads_Dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:local_auth/local_auth.dart';
import 'dart:async';
import '../ForgerPasswordScreens/forgetPasswordSuccess.dart';
import 'SignInScreen.dart';
import 'package:package_info/package_info.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_app/blocs/UpdateVersionBloc/androidBloc/androidBloc_bloc.dart';
import 'package:sales_app/blocs/UpdateVersionBloc/androidBloc/androidBloc_events.dart';
import 'package:sales_app/blocs/UpdateVersionBloc/androidBloc/androidBloc_state.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'dart:io' show Platform;
import 'package:sales_app/Shared/BaseUrl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:store_redirect/store_redirect.dart';
import 'package:device_info/device_info.dart';
import 'package:store_checker/store_checker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

//new uploade with haya
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  LocalAuthentication auth = LocalAuthentication();
  bool _canCheckBiometrics;
  String autherized = "Not autherized";
  String version;
  String versionAPI;
  bool androidCheck;
  var device_manufacturer;
  String source = 'None';
  APP_URLS urls = new APP_URLS();

  AndroidBloc androidBloc;
  void setBiometricLogedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('biomitric_is_logged_in', true);
  }

  Future<void> _authenticate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool authenticated = false;
    try {
      authenticated = await auth.authenticate(
          localizedReason: "Scan your finger print to authenticate");
    } on PlatformException catch (e) {
      print(e);
    }

    if (!mounted) return;
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => SignInScreen(),
        ),
      );
    }
    setState(() {
      autherized =
          authenticated ? "Autherized success" : "Failed to authenticate";
      print(autherized);
      if (authenticated) {
        setBiometricLogedIn();
        if (prefs.getStringList('Permessions') == null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => SignInScreen(),
            ),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => CustomBottomNavigationBar(
                Permessions: prefs.getStringList('Permessions'),
                role: prefs.getString('role'),
                outDoorUserName: prefs.getString('outDoorUserName'),
              ),
            ),
          );
        }

        if (prefs.getStringList('PermessionCorporate') == null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => SignInScreen(),
            ),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => CorpNavigationBar(
                PermessionCorporate: prefs.getStringList('PermessionCorporate'),
                role: prefs.getString('role'),
              ),
            ),
          );
        }

        if (prefs.getStringList('PermessionDeliveryEShop') == null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => SignInScreen(),
            ),
          );
        } else {
          Navigator.pushReplacement(
            context,
           /* MaterialPageRoute(
              builder: (context) => OrdersScreen(),
            ),*/
            MaterialPageRoute(builder: (context) => Eshope_Menu()),
          );
        }
      }
    });
  }

  Future<bool> isFirstTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var isFirstTime = prefs.getBool('first_time');
    if (isFirstTime != null && !isFirstTime) {
      return false;
    } else {
      // prefs.setInt('lang',2);
      prefs.setBool('first_time', false);
      return true;
    }
  }

  void setFirstFunction() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('lang', 1);
    print('first login');
    prefs.setBool('is_logged_in', false);
    prefs.setBool('biomitric_is_logged_in', false);
    prefs.remove("accessToken");
    prefs.remove('counter');
    prefs.setBool('isRememberMe', false);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => SignInScreen(),
      ),
    );
  }

  Future<void> initPlatformState() async {
    Source installationSource = await StoreChecker.getSource;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      //get origin of installed application
      installationSource = await StoreChecker.getSource;
    } on PlatformException {
      installationSource = Source.UNKNOWN;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    // Set source text state
    setState(() {
      switch (installationSource) {
        case Source.IS_INSTALLED_FROM_PLAY_STORE:
          // Installed from Play Store
          source = "Play Store";
          print("___________________________________________________");
          print(source);
          getAndroidVersion();
          break;
        case Source.IS_INSTALLED_FROM_LOCAL_SOURCE:
          // Installed using adb commands or side loading or any cloud service
          source = "Local Source";
          print("___________________________________________________");
          print(source);
          getAndroidVersion();
          break;
        case Source.IS_INSTALLED_FROM_HUAWEI_APP_GALLERY:
          // Installed from Huawei app store
          source = "Huawei App Gallery";
          print("___________________________________________________");
          print(source);
          getHUAWEIVersion();
          break;
      }
    });
  }

  void _getManufacturer() async {
    print("_getManufacturer Function");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.getStringList('PermessionCorporate'));
    var androidInfo = await DeviceInfoPlugin().androidInfo;
    var release = androidInfo.version.release;
    var sdkInt = androidInfo.version.sdkInt;
    var manufacturer = androidInfo.manufacturer;
    var model = androidInfo.model;
    setState(() {
      device_manufacturer = androidInfo.manufacturer;
    });
    print("//////////////////////////////");
    // print(' $release (SDK $sdkInt), $manufacturer $model');
    print('manufacturer: $manufacturer');
    print("//////////////////////////////");

    if (device_manufacturer == "HUAWEI") {
      print("yes i'm HUAWEI device");
      getHUAWEIVersion();  //i disabell it on 11/10/12023 becuse i ges there is issue
      initPlatformState();
    } else {
      print("No i'm OTHER Android device");
      getAndroidVersion();
    }
  }

  void _getPlatform() async {
    if (kIsWeb) {
      // running on the web!
      getWebVersion();
      print("Web MODE");
    } else {
      // NOT running on the web! You can check for additional platforms here.
      if (Platform.isAndroid) {
        _getManufacturer();
        print("Android MODE");
      }
      if (Platform.isIOS) {
        print("IOS MODE");
        getIOSVersion();
      }
    }
  }

  // @override
  // void initState() {
  //   super.initState();
  //   //getAndroidVersion () ;

  //   _getPlatform();

  //   /*if(Platform.isAndroid){
  //     _getManufacturer();
  //     print("Android MODE");
  //   }
  //   if (Platform.isIOS){
  //     print("IOS MODE");
  //     getIOSVersion ();
  //   }*/
  // }
@override
void initState() {
  super.initState();
  // Skip version checking - directly navigate after a short delay
  Timer(Duration(seconds: 1), () {
    _navigateBasedOnLoginState();
  });
}

Future<void> _navigateBasedOnLoginState() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  
  bool firstTime = await isFirstTime();
  if (firstTime) {
    setFirstFunction();
    return;
  }
  
  if (prefs.getBool('biomitric_is_logged_in') == true) {
    _authenticate();
    return;
  }
  
  if (prefs.getBool('is_logged_in') == true) {
    String role = prefs.getString('role');
    
    // Navigate based on role
    if (role == 'Corporate') {
      if (prefs.getStringList('PermessionCorporate') == null) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignInScreen()));
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => CorpNavigationBar(
              PermessionCorporate: prefs.getStringList('PermessionCorporate'),
              role: role,
            ),
          ),
        );
      }
    } else if (role == 'DeliveryEShop') {
      if (prefs.getStringList('PermessionDeliveryEShop') == null) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignInScreen()));
      } else {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Eshope_Menu()));
      }
    } else if (role == 'ZainOutdoorHeads') {
      if (prefs.getStringList('PermessionZainOutdoorHeads') == null) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignInScreen()));
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ZainOutdoorHeads_Dashboard(
              PermessionZainOutdoorHeads: prefs.getStringList('PermessionZainOutdoorHeads'),
              role: role,
              outDoorUserName: prefs.getString('outDoorUserName'),
            ),
          ),
        );
      }
    } else if (role == 'DealerAgent') {
      if (prefs.getStringList('PermessionDealerAgent') == null) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignInScreen()));
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => CustomBottomNavigationBar(
              Permessions: prefs.getStringList('PermessionDealerAgent'),
              role: role,
              outDoorUserName: prefs.getString('outDoorUserName'),
            ),
          ),
        );
      }
    } else if (role == 'Reseller') {
      if (prefs.getStringList('PermessionReseller') == null) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignInScreen()));
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => NewAccountDocumnetChecking(
              prefs.getStringList('PermessionReseller'),
              role,
            ),
          ),
        );
      }
    } else {
      // Default role (SubDealer, etc.)
      if (prefs.getStringList('Permessions') == null) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignInScreen()));
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => CustomBottomNavigationBar(
              Permessions: prefs.getStringList('Permessions'),
              role: role,
              outDoorUserName: prefs.getString('outDoorUserName'),
            ),
          ),
        );
      }
    }
  } else {
    // Not logged in
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => SignInScreen()),
    );
  }
}
  /////////////////////////////////////////////////Web Part/////////////////////////////////////////////////////////
  void getWebVersion() async {
    String version;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print('hellogetWebVersion');
    var url = urls.BASE_URL + '/Version/Android';
    final response = await http.get(Uri.parse(url), headers: {
      "content-type": "application/json",
      "Authorization": prefs.getString("accessToken"),
      "Accept": "application/json",
      "Access-Control_Allow_Origin": "*",
      
    });
    int statusCode = response.statusCode;
    print(statusCode);
    print('body: [${response.body}]');
    if (statusCode == 200) {
      var result = json.decode(response.body);
      print('Web_Version');
      print(result['currentVersion']);

      Timer(Duration(seconds: 1), () {
        isFirstTime().then((isFirstTime) {
          isFirstTime
              ? setFirstFunction()
              : Future.delayed(
                  Duration(seconds: 1),
                  () async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();

                    if (prefs.getBool('biomitric_is_logged_in') == true) {
                      _authenticate();
                    } else {
                      if (prefs.getBool('is_logged_in') == true) {
                        if (prefs.getStringList('Permessions') == null) {
                          print("SubDelar Splash Screen");

                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SignInScreen(),
                            ),
                          );
                        } else {
                          print("Sucsses SubDelar Splash Screen");
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CustomBottomNavigationBar(
                                Permessions: prefs.getStringList('Permessions'),
                                role: prefs.getString('role'),
                                outDoorUserName:
                                    prefs.getString('outDoorUserName'),
                              ),
                            ),
                          );
                          //    androidBloc.add(AndroidFetchEvent());
                        }

                        if (prefs.getString('role') == 'Corporate') {
                          if (prefs.getStringList('PermessionCorporate') == null) {
                            print("Corporate Splash Screen");
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SignInScreen(),
                              ),
                            );
                          }else{
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CorpNavigationBar(
                                  PermessionCorporate: prefs
                                      .getStringList('PermessionCorporate'),
                                  role: prefs.getString('role'),
                                ),
                              ),
                            );
                          }
                        }

                        if (prefs.getString('role') == 'DeliveryEShop') {
                          if (prefs.getStringList('PermessionDeliveryEShop') ==
                              null) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SignInScreen(),
                              ),
                            );
                          } else {
                            Navigator.pushReplacement(
                              context,
                             /* MaterialPageRoute(
                                builder: (context) => OrdersScreen(),
                              ),*/
                              MaterialPageRoute(builder: (context) => Eshope_Menu()),
                            );
                          }
                        }
                        if (prefs.getString('role') == 'ZainOutdoorHeads') {
                          print(prefs.getString('role'));
                          if (prefs.getStringList('PermessionZainOutdoorHeads') ==
                              null) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SignInScreen(),
                              ),
                            );
                          } else {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => ZainOutdoorHeads_Dashboard( PermessionZainOutdoorHeads: prefs.getStringList('PermessionZainOutdoorHeads'),
                                role: prefs.getString('role'),
                                outDoorUserName:
                                prefs.getString('outDoorUserName'),)),
                            );
                          }
                        }

                        if (prefs.getString('role') == 'DealerAgent') {
                          print(prefs.getString('role'));
                          if (prefs.getStringList('PermessionDealerAgent') ==
                              null) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SignInScreen(),
                              ),
                            );
                          } else {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CustomBottomNavigationBar(
                                  Permessions: prefs.getStringList('Permessions'),
                                  role: prefs.getString('role'),
                                  outDoorUserName:
                                  prefs.getString('outDoorUserName'),
                                ),
                              ),
                            );
                          }
                        }
                      } else {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SignInScreen(),
                          ),
                        );
                      }
                    }
                  },
                );
        });
      });

      return result;
    }
  }
  /////////////////////////////////////////////////OTHER ANDROID DEVICESS/////////////////////////////////////////////////////////

  void getAndroidVersion() async {
    String version;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print('hellogetAndroidVersion');


    var url = urls.BASE_URL + '/Version/Android';
    final response = await http.get(Uri.parse(url), headers: {
      "content-type": "application/json",
      "Authorization": prefs.getString("accessToken"),
      "Accept": "application/json",
      "Access-Control_Allow_Origin": "*",

    });
    int statusCode = response.statusCode;
    print(statusCode);
    print('body: [${response.body}]');
    if (statusCode == 200) {
      var result = json.decode(response.body);
      print('Android_Version haya haya haya');
      print(result['currentVersion']);

      PackageInfo.fromPlatform().then((PackageInfo packageInfo) async {
        String appName = packageInfo.appName;
        String packageName = packageInfo.packageName;
        version = packageInfo.version;
        String buildNumber = packageInfo.buildNumber;

        print("appName");
        print(appName);
        print("version");
        print(version);
        print("packageName");
        print(packageName);
        print("buildNumber");
        print(buildNumber);

        return packageInfo;
      });

      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      print("----------------haya-------------");
      print(result['currentVersion']);
      print("-------------haya----------------");
      print(packageInfo);
      print("-----------haya------------------");
      print(packageInfo.version);
      print("-------------haya----------------");

      if (packageInfo.version == result['currentVersion']) {
        print("version is === currentVersion");
        Timer(Duration(seconds: 1), () {
          isFirstTime().then((isFirstTime) {
            isFirstTime
                ? setFirstFunction()
                : Future.delayed(
                    Duration(seconds: 1),
                    () async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();

                      if (prefs.getBool('biomitric_is_logged_in') == true) {
                        _authenticate();
                      } else {
                        if (prefs.getBool('is_logged_in') == true) {
                        /*  if (prefs.getStringList('Permessions') == null) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SignInScreen(),
                              ),
                            );
                          } else {

                         Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CustomBottomNavigationBar(
                                  Permessions:
                                      prefs.getStringList('Permessions'),
                                  role: prefs.getString('role'),
                                  outDoorUserName:
                                      prefs.getString('outDoorUserName'),
                                ),
                              ),
                            );
                            //    androidBloc.add(AndroidFetchEvent());
                          }*/


                          if (prefs.getString('role') != 'Corporate' && prefs.getString('role') != 'DeliveryEShop' && prefs.getString('role') != 'ZainOutdoorHeads' && prefs.getString('role') != 'DealerAgent') {
                            if (prefs.getStringList('Permessions') == null) {
                              print("Error SubDelar Splash Screen");
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SignInScreen(),
                                ),
                              );
                            }else{
                              print("Sucsses SubDelar Splash Screen");
                              print(prefs.getString('SalesAppUser'));
                              print(prefs.getString('role'));
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CustomBottomNavigationBar(
                                    Permessions: prefs.getStringList('Permessions'),
                                    role: prefs.getString('role'),
                                    outDoorUserName:
                                    prefs.getString('outDoorUserName'),
                                  ),
                                ),
                              );
                            }
                          }


                          if (prefs.getString('role') == 'Corporate') {
                            if (prefs.getStringList('PermessionCorporate') ==
                                null) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SignInScreen(),
                                ),
                              );
                            } else {

                             Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CorpNavigationBar(
                                    PermessionCorporate: prefs
                                        .getStringList('PermessionCorporate'),
                                    role: prefs.getString('role'),
                                  ),
                                ),
                              );
                            }
                          }
                          if (prefs.getString('role') == 'Reseller') {
                            if (prefs.getStringList('PermessionReseller') ==
                                null) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SignInScreen(),
                                ),
                              );
                            } else {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>NewAccountDocumnetChecking(
                                    prefs.getStringList('PermessionReseller'), prefs.getString('role'), ),
                                ),
                              );
                            }
                          }

                          if (prefs.getString('role') == 'DeliveryEShop') {
                            print(prefs.getString('role'));
                            if (prefs.getStringList('PermessionDeliveryEShop') ==
                                null) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SignInScreen(),
                                ),
                              );
                            } else {
                              Navigator.pushReplacement(
                                context,
                              /*  MaterialPageRoute(
                                  builder: (context) => OrdersScreen(),
                                ),*/
                                MaterialPageRoute(builder: (context) => Eshope_Menu()),
                              );
                            }
                          }


                          if (prefs.getString('role') == 'ZainOutdoorHeads') {
                            print(prefs.getString('role'));
                            if (prefs.getStringList('PermessionZainOutdoorHeads') ==
                                null) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SignInScreen(),
                                ),
                              );
                            } else {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => ZainOutdoorHeads_Dashboard( PermessionZainOutdoorHeads: prefs.getStringList('PermessionZainOutdoorHeads'),
                                  role: prefs.getString('role'),
                                  outDoorUserName:
                                  prefs.getString('outDoorUserName'),)),
                              );
                            }
                          }


                          if (prefs.getString('role') == 'DealerAgent') {
                            print(prefs.getString('role'));
                            if (prefs.getStringList('PermessionDealerAgent') ==
                                null) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SignInScreen(),
                                ),
                              );
                            } else{

                              print(prefs.getString('DealerAgent'));
                              print(prefs.getString('role'));
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CustomBottomNavigationBar(
                                    Permessions: prefs.getStringList('PermessionDealerAgent'),
                                    role: prefs.getString('role'),
                                    outDoorUserName:
                                    prefs.getString('outDoorUserName'),
                                  ),
                                ),
                              );
                            }
                          }
                        } else {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SignInScreen(),
                            ),
                          );
                        }
                      }
                    },
                  );
          });
        });
      } else if (packageInfo.version != result['currentVersion']) {
        print("version is not === currentVersion");
        Future.delayed(
          Duration(seconds: 4),
          () async {
            showDialog<String>(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: Text("Login_Form.update_version".tr().toString()),
                content: Text("Login_Form.new_version".tr().toString()),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => {
                      // Navigator.pop(context, 'OK'),
                      //exit(0),

                      // when ios stop bellow line
                        StoreRedirect.redirect(androidAppId:'com.sales_app_zainjo' )
                    },
                    child: Text(
                      "alert.UPDATE".tr().toString(),
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
        );
      }

      return result;
    }
  }

  //////////////////////////////////////////////HUAWEI DEVICESS///////////////////////////////////////////////////////////////////

  void getHUAWEIVersion() async {
    String version;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print('hellogetHUAWEIVersion');
    var url = urls.BASE_URL + '/Version/Huawei';
    final response = await http.get(Uri.parse(url), headers: {
      "content-type": "application/json",
      "Authorization": prefs.getString("accessToken")
    });
    int statusCode = response.statusCode;
    print('body: [${response.body}]');
    if (statusCode == 200) {
      var result = json.decode(response.body);
      print('Android_Version For HUAWEI device');
      print(result['currentVersion']);

      PackageInfo.fromPlatform().then((PackageInfo packageInfo) async {
        String appName = packageInfo.appName;
        String packageName = packageInfo.packageName;
        version = packageInfo.version;
        String buildNumber = packageInfo.buildNumber;

        print("appName");
        print(appName);
        print("version");
        print(version);
        print("packageName");
        print(packageName);
        print("buildNumber");
        print(buildNumber);

        return packageInfo;
      });

      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      print(result['currentVersion']);
      print("-----------------------------");
      print(packageInfo);
      print("-----------------------------");
      print(packageInfo.version);

      if (int.parse(packageInfo.buildNumber) ==
          int.parse(result['currentVersion'])) {
        print("version is === currentVersion");
        Timer(Duration(seconds: 1), () {
          isFirstTime().then((isFirstTime) {
            isFirstTime
                ? setFirstFunction()
                : Future.delayed(
                    Duration(seconds: 1),
                    () async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();

                      if (prefs.getBool('biomitric_is_logged_in') == true) {
                        _authenticate();
                      } else {
                        if (prefs.getBool('is_logged_in') == true) {
                         /* if (prefs.getStringList('Permessions') == null) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SignInScreen(),
                              ),
                            );
                          } else {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CustomBottomNavigationBar(
                                  Permessions:
                                      prefs.getStringList('Permessions'),
                                  role: prefs.getString('role'),
                                  outDoorUserName:
                                      prefs.getString('outDoorUserName'),
                                ),
                              ),
                            );
                            //    androidBloc.add(AndroidFetchEvent());
                          }*/
                          if (prefs.getString('role') != 'Corporate' && prefs.getString('role') != 'DeliveryEShop' && prefs.getString('role') != 'ZainOutdoorHeads' && prefs.getString('role') != 'DealerAgent' && prefs.getString('role') != 'Reseller') {
                            if (prefs.getStringList('Permessions') == null) {
                              print("Error SubDelar Splash Screen");
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SignInScreen(),
                                ),
                              );
                            }else{
                              print("Sucsses SubDelar Splash Screen");
                              print(prefs.getString('SalesAppUser'));
                              print(prefs.getString('role'));
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CustomBottomNavigationBar(
                                    Permessions: prefs.getStringList('Permessions'),
                                    role: prefs.getString('role'),
                                    outDoorUserName:
                                    prefs.getString('outDoorUserName'),
                                  ),
                                ),
                              );
                            }
                          }

                          if (prefs.getString('role') == 'Corporate') {
                            if (prefs.getStringList('PermessionCorporate') ==
                                null) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SignInScreen(),
                                ),
                              );
                            } else {

                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CorpNavigationBar(
                                    PermessionCorporate: prefs
                                        .getStringList('PermessionCorporate'),
                                    role: prefs.getString('role'),
                                  ),
                                ),
                              );
                            }
                          }
                          if (prefs.getString('role') == 'Reseller') {
                            if (prefs.getStringList('PermessionReseller') ==
                                null) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SignInScreen(),
                                ),
                              );
                            } else {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>NewAccountDocumnetChecking(
                                prefs.getStringList('PermessionReseller'), prefs.getString('role'), ),
                                ),
                              );
                            }
                          }
                          if (prefs.getString('role') == 'DeliveryEShop') {
                            if (prefs.getStringList('PermessionDeliveryEShop') ==
                                null) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SignInScreen(),
                                ),
                              );
                            } else {
                              Navigator.pushReplacement(
                                context,
                              /*  MaterialPageRoute(
                                  builder: (context) => OrdersScreen(),
                                ),*/
                                MaterialPageRoute(builder: (context) => Eshope_Menu()),
                              );
                            }
                          }

                          if (prefs.getString('role') == 'ZainOutdoorHeads') {
                            print(prefs.getString('role'));
                            if (prefs.getStringList('PermessionZainOutdoorHeads') ==
                                null) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SignInScreen(),
                                ),
                              );
                            } else {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => ZainOutdoorHeads_Dashboard( PermessionZainOutdoorHeads: prefs.getStringList('PermessionZainOutdoorHeads'),
                                  role: prefs.getString('role'),
                                  outDoorUserName:
                                  prefs.getString('outDoorUserName'),)),
                              );
                            }
                          }
                          if (prefs.getString('role') == 'DealerAgent') {
                            print(prefs.getString('role'));
                            if (prefs.getStringList('PermessionDealerAgent') ==
                                null) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SignInScreen(),
                                ),
                              );
                            } else{

                              print(prefs.getString('DealerAgent'));
                              print(prefs.getString('role'));
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CustomBottomNavigationBar(
                                    Permessions: prefs.getStringList('PermessionDealerAgent'),
                                    role: prefs.getString('role'),
                                    outDoorUserName:
                                    prefs.getString('outDoorUserName'),
                                  ),
                                ),
                              );
                            }
                          }

                        } else {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SignInScreen(),
                            ),
                          );
                        }
                      }
                    },
                  );
          });
        });
      } else if (int.parse(packageInfo.buildNumber) !=
          int.parse(result['currentVersion'])) {
        print("version is not === currentVersion");
        Future.delayed(
          Duration(seconds: 4),
          () async {
            showDialog<String>(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: Text("Login_Form.update_version".tr().toString()),
                content: Text("Login_Form.new_version_Huawei".tr().toString()),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => {
                      Navigator.pop(context, 'OK'),
                      //exit(0),

                      // when ios stop bellow line
                       StoreRedirect.redirect(androidAppId:'com.sales_app_zainjo' )
                    },
                    child: Text(
                      "alert.close".tr().toString(),
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
        );
      }

      return result;
    }
  }

  /////////////////////////////////////////////IOS DEVICESS///////////////////////////////////////////////////////////////////////
  void getIOSVersion() async {
    String version;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var url = urls.BASE_URL + '/Version/IOS';
    final response = await http.get(Uri.parse(url), headers: {
      "content-type": "application/json",
      "Authorization": prefs.getString("accessToken")
    });
    int statusCode = response.statusCode;
    print('body: [${response.body}]');
    if (statusCode == 200) {
      var result = json.decode(response.body);
      print('IOS_Version haya haya haya');
      print(result['currentVersion']);

      PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
        String appName = packageInfo.appName;
        String packageName = packageInfo.packageName;
        version = packageInfo.version;
        String buildNumber = packageInfo.buildNumber;

        print("appName");
        print(appName);
        print("version");
        print(version);
        print("packageName");
        print(packageName);
        print("buildNumber");
        print(buildNumber);

        return packageInfo;
      });
//
      PackageInfo packageInfo = await PackageInfo.fromPlatform();

      print('check');
      print(double.parse(packageInfo.version));
      print(double.parse(result['currentVersion']));
      // if(double.parse(packageInfo.version)>= double.parse(result['currentVersion'])){

      if (double.parse(packageInfo.version) >=
          double.parse(result['currentVersion'])) {
        print("version is === currentVersion");
        Timer(Duration(seconds: 1), () {
          isFirstTime().then((isFirstTime) {
            isFirstTime
                ? setFirstFunction()
                : Future.delayed(
                    Duration(seconds: 1),
                    () async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();

                      if (prefs.getBool('biomitric_is_logged_in') == true) {
                        _authenticate();
                      } else {
                        if (prefs.getBool('is_logged_in') == true) {
                         /* if (prefs.getStringList('Permessions') == null) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SignInScreen(),
                              ),
                            );
                          } else {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CustomBottomNavigationBar(
                                  Permessions:
                                      prefs.getStringList('Permessions'),
                                  role: prefs.getString('role'),
                                  outDoorUserName:
                                      prefs.getString('outDoorUserName'),
                                ),
                              ),
                            );
                            //    androidBloc.add(AndroidFetchEvent());

                          }*/


                          if (prefs.getString('role') != 'Corporate' && prefs.getString('role') != 'DeliveryEShop' && prefs.getString('role') != 'ZainOutdoorHeads' && prefs.getString('role') != 'DealerAgent' && prefs.getString('role') != 'Reseller') {
                            if (prefs.getStringList('Permessions') == null) {
                              print("Error SubDelar Splash Screen");
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SignInScreen(),
                                ),
                              );
                            }else{
                              print("Sucsses SubDelar Splash Screen");
                              print(prefs.getString('SalesAppUser'));
                              print(prefs.getString('role'));
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CustomBottomNavigationBar(
                                    Permessions: prefs.getStringList('Permessions'),
                                    role: prefs.getString('role'),
                                    outDoorUserName:
                                    prefs.getString('outDoorUserName'),
                                  ),
                                ),
                              );
                            }
                          }



                          if (prefs.getString('role') == 'Corporate') {
                            if (prefs.getStringList('PermessionCorporate') ==
                                null) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SignInScreen(),
                                ),
                              );
                            } else {

                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CorpNavigationBar(
                                    PermessionCorporate: prefs
                                        .getStringList('PermessionCorporate'),
                                    role: prefs.getString('role'),
                                  ),
                                ),
                              );
                            }
                          }
                          if (prefs.getString('role') == 'Reseller') {
                            if (prefs.getStringList('PermessionReseller') ==
                                null) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SignInScreen(),
                                ),
                              );
                            } else {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>NewAccountDocumnetChecking(
                                    prefs.getStringList('PermessionReseller'), prefs.getString('role'), ),
                                ),
                              );
                            }
                          }
                          if (prefs.getString('role') == 'DeliveryEShop') {
                            if (prefs.getStringList('PermessionDeliveryEShop') ==
                                null) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SignInScreen(),
                                ),
                              );
                            } else {
                              Navigator.pushReplacement(
                                context,
                              /*  MaterialPageRoute(
                                  builder: (context) => OrdersScreen(),
                                ),*/
                                MaterialPageRoute(builder: (context) => Eshope_Menu()),
                              );
                            }
                          }

                          if (prefs.getString('role') == 'ZainOutdoorHeads') {
                            print(prefs.getString('role'));
                            if (prefs.getStringList('PermessionZainOutdoorHeads') ==
                                null) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SignInScreen(),
                                ),
                              );
                            } else {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => ZainOutdoorHeads_Dashboard( PermessionZainOutdoorHeads: prefs.getStringList('PermessionZainOutdoorHeads'),
                                  role: prefs.getString('role'),
                                  outDoorUserName:
                                  prefs.getString('outDoorUserName'),)),
                              );
                            }
                          }

                          if (prefs.getString('role') == 'DealerAgent') {
                            print(prefs.getString('role'));
                            if (prefs.getStringList('PermessionDealerAgent') ==
                                null) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SignInScreen(),
                                ),
                              );
                            } else{

                              print(prefs.getString('DealerAgent'));
                              print(prefs.getString('role'));
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CustomBottomNavigationBar(
                                    Permessions: prefs.getStringList('PermessionDealerAgent'),
                                    role: prefs.getString('role'),
                                    outDoorUserName:
                                    prefs.getString('outDoorUserName'),
                                  ),
                                ),
                              );
                            }
                          }

                        } else {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SignInScreen(),
                            ),
                          );
                        }
                      }
                    },
                  );
          });
        });
      } else if (double.parse(packageInfo.version) !=
          double.parse(result['currentVersion'])) {
        print("version is not === currentVersion");
        Future.delayed(
          Duration(seconds: 4),
          () async {
            showDialog<String>(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: Text("Login_Form.update_version".tr().toString()),
                content: Text("Login_Form.new_version".tr().toString()),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => {
                      print('hello'),
                      //   Navigator.pop(context, 'OK'),
                      StoreRedirect.redirect(iOSAppId: '1579522784'),

                      // exit(0),
                    },
                    child: Text(
                      "alert.UPDATE".tr().toString(),
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
        );
      }

      return result;
    }
  }

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        child: Stack(
          children: <Widget>[
            Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF008388), Color(0xFF4f2565)],
                ),
              ),
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 100, vertical: 200),
                //child: Image(image: AssetImage('assets/images/logoo.png'))
              ),
            ),
          ],
        ),
      ),
    );
  }
}
