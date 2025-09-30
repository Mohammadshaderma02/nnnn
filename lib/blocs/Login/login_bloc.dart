import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_app/blocs/Login/login_events.dart';
import 'package:sales_app/blocs/Login/login_state.dart';
import 'package:sales_app/repository/getTawasolNumber_repo.dart';
import 'package:sales_app/repository/login_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
class LoginBloc extends  Bloc<LoginEvents ,LoginState> {
  LoginRepository loginRepo;
  GetTawasolNumberRepository getTawasolNumberRepo;
  var counter = 0;
  var userName = '';

  LoginBloc(LoginState initialState, this.loginRepo, this.getTawasolNumberRepo)
      :
        super(initialState) {
    on<StartEvent>(_StartEvent);
    on<LoginButtonPressed>(_LoginButtonPressed);
  }

  _StartEvent(StartEvent event,
      Emitter<LoginState> emit,) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    emit(LoginInitState());
    if (prefs.getBool('TokenError') == true) {
      prefs.setBool('TokenError', false);
      emit(LoginErrorTokenState());
    }
    try {
      if (prefs.getBool('TokenError') == true) {
        prefs.setBool('TokenError', false);
        emit(LoginErrorTokenState());
      }
    } catch (e) {
      print('caled bloc error ONE');
      print("one");
      print(e);
      // emit(ErrorState(message: e.toString()));
    }
  }

  _LoginButtonPressed(LoginButtonPressed event,
      Emitter<LoginState> emit,) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    emit(LoginLoadingState());
    try {
      emit(LoginLoadingState());

      Map<String, dynamic> data = await loginRepo.login(
          event.userName, event.password, event.userType, event.isRememberMe,
          event.isSwitched);
      Map<String, dynamic> tawasolData;
      if (data['status'] == 0) {
        prefs.setString("accessToken", data['data']['accessToken']);
        prefs.setString("userName", event.userName);
        prefs.setBool("isRememberMe", event.isRememberMe);
        userName = data['data']['username'];
        print("haya");
        print(userName = data['data']['username']);
        print("haya");
        if (event.isRememberMe == true) {
          prefs.setString('password', event.password);
        }
        prefs.setInt('counter', 0);
        prefs.setBool('is_logged_in', true);
        print("ROLE TYPE");
        print(data['data']['role']);
        prefs.setString('subdealerFreeze', '0');
        prefs.setString('role', data['data']['role']);
        prefs.setString('outDoorUserName', data['data']['username']);

        /****************************************************************************************************************************************/
        /**..................................................Role Subdealer....................................................................**/
        /****************************************************************************************************************************************/
        if (data['data']['role'] == 'Subdealer') {
          print("Subdealer Subdealer Subdealer Subdealer Subdealer 2025");

          tawasolData = await getTawasolNumberRepo.getTawasolNumber();
          if (tawasolData['status'] == 0) {
            print("tawasolData 2025");
            prefs.setString('subdealerTawasolKitcode', tawasolData['data']['tawasol']['subdealerTawasolKitcode']);

            prefs.setString('subdealerFreeze', tawasolData['data']['tawasol']['subdealerFreeze']);


              print("testing one");
              if (event.isSwitched == true) {
                if (data['data']['role'] == 'Subdealer') {
                  emit(SubdealerLoginSuccessStateWithBiometric(
                      tawasolData: tawasolData,
                      Permessions: prefs.getStringList('Permessions'),
                      role: data['data']['role'],
                      userName: userName
                  ));
                } else {
                  emit(SubdealerLoginSuccessStateWithBiometric(
                      tawasolData: tawasolData,
                      Permessions: prefs.getStringList('Permessions'),
                      role: data['data']['role'],
                      userName: userName
                  ));
                }
              }
              else {
                if (data['data']['role'] == 'Subdealer') {
                  print("yesy yse yes yes");
                  print("Subdealer Subdealer Subdealer Subdealer Subdealer ");
                  print("Hazaimeh");

                  emit(SubdealerLoginSuccessState(
                      tawasolData: tawasolData,
                      Permessions: prefs.getStringList('Permessions'),
                      role: data['data']['role'],
                      userName: userName
                  ));
                } else {
                  emit(SubdealerLoginSuccessState(
                      tawasolData: tawasolData,
                      Permessions: prefs.getStringList('Permessions'),
                      role: data['data']['role'],
                      userName: userName
                  ));
                }
              }

          } else {
            emit(LoginErrorState(
                englishMessage: "Something went wrong please try again",
                arabicMessage: "حدث خطأ ما. أعد المحاولة من فضلك"));
          }
        } // here new
        /****************************************************************************************************************************************/
        /**..................................................Role Corporate....................................................................**/
        /****************************************************************************************************************************************/
        if (data['data']['role'] == 'Corporate') {
          if (event.isSwitched == true) {

            if (data['data']['role'] == 'Corporate') {
              emit(CorporateLoginSuccessStateWithBiometric(
                  PermessionCorporate: prefs.getStringList('PermessionCorporate'),
                  role: data['data']['role'],
              ));
            } else {
              emit(CorporateLoginSuccessStateWithBiometric(
                  PermessionCorporate: prefs.getStringList('PermessionCorporate'),
                  role: data['data']['role'],

              ));
            }
          }
          else {
            if (data['data']['role'] == 'Corporate') {
              print("Corporate Corporate Corporate Corporate Corporate ");

              emit(CorporateLoginSuccessState(
                  PermessionCorporate: prefs.getStringList('PermessionCorporate'),
                  role: data['data']['role'],
              ));
            } else if(data['data']['role'] == 'Corporate') {
              emit(CorporateLoginSuccessState(
                  PermessionCorporate: prefs.getStringList('PermessionCorporate'),
                  role: data['data']['role'],

              ));
            }
          }
        }
        /****************************************************************************************************************************************/
        /**................................................Role DeliveryEShop..................................................................**/
        /****************************************************************************************************************************************/
        if (data['data']['role'] == 'DeliveryEShop') {
          if (event.isSwitched == true) {

            if (data['data']['role'] == 'DeliveryEShop') {
              emit(DeliveryEShopLoginSuccessStateWithBiometric(
                PermessionDeliveryEShop: prefs.getStringList('PermessionDeliveryEShop'),
                role: data['data']['role'],
              ));
            } else {
              emit(DeliveryEShopLoginSuccessStateWithBiometric(
                PermessionDeliveryEShop: prefs.getStringList('PermessionDeliveryEShop'),
                role: data['data']['role'],

              ));
            }
          }
          else {
            if (data['data']['role'] == 'DeliveryEShop') {
              print("DeliveryEShop DeliveryEShop DeliveryEShop ");

              emit(DeliveryEShopLoginSuccessState(
                PermessionDeliveryEShop: prefs.getStringList('PermessionDeliveryEShop'),
                role: data['data']['role'],
              ));
            } else if(data['data']['role'] == 'DeliveryEShop') {
              emit(DeliveryEShopLoginSuccessState(
                PermessionDeliveryEShop: prefs.getStringList('PermessionDeliveryEShop'),
                role: data['data']['role'],

              ));
            }
          }
        }
        /****************************************************************************************************************************************/
        /**................................................Role ZainOutdoorHeads...............................................................**/
        /****************************************************************************************************************************************/
        if (data['data']['role'] == 'ZainOutdoorHeads') {
          print("2025");
          if (event.isSwitched == true) {

            if (data['data']['role'] == 'ZainOutdoorHeads') {
              emit(ZainOutdoorHeadsLoginSuccessStateWithBiometric(
                PermessionZainOutdoorHeads: prefs.getStringList('PermessionZainOutdoorHeads'),
                role: data['data']['role'],
                  userName: userName

              ));
            } else {
              emit(ZainOutdoorHeadsLoginSuccessStateWithBiometric(
                PermessionZainOutdoorHeads: prefs.getStringList('PermessionZainOutdoorHeads'),
                role: data['data']['role'],
                  userName: userName

              ));
            }
          }
          else {
            if (data['data']['role'] == 'ZainOutdoorHeads') {
              print("ZainOutdoorHeads ZainOutdoorHeads");

              emit(ZainOutdoorHeadsLoginSuccessState(
                PermessionZainOutdoorHeads: prefs.getStringList('PermessionZainOutdoorHeads'),
                role: data['data']['role'],
                  userName: userName
              ));
            } else if(data['data']['role'] == 'ZainOutdoorHeads') {
              emit(ZainOutdoorHeadsLoginSuccessState(
                PermessionZainOutdoorHeads: prefs.getStringList('PermessionZainOutdoorHeads'),
                role: data['data']['role'],
                  userName: userName

              ));
            }
          }
        }
        /****************************************************************************************************************************************/
        /**................................................Role Dealer Agent..................................................................**/
        /****************************************************************************************************************************************/
        if (data['data']['role'] == 'DealerAgent') {
          if (event.isSwitched == true) {

            if (data['data']['role'] == 'DealerAgent') {
              emit(DealerAgentLoginSuccessStateWithBiometric(
                  PermessionDealerAgent: prefs.getStringList('PermessionDealerAgent'),
                  role: data['data']['role'],
                  userName: userName

              ));
            } else {
              emit(DealerAgentLoginSuccessStateWithBiometric(
                  PermessionDealerAgent: prefs.getStringList('PermessionDealerAgent'),
                  role: data['data']['role'],
                  userName: userName

              ));
            }
          }
          else {
            if (data['data']['role'] == 'DealerAgent') {
              print("DealerAgent DealerAgent");

              emit(DealerAgentLoginSuccessState(
                  PermessionDealerAgent: prefs.getStringList('PermessionDealerAgent'),
                  role: data['data']['role'],
                  userName: userName
              ));
            } else if(data['data']['role'] == 'DealerAgent') {
              emit(DealerAgentLoginSuccessState(
                  PermessionDealerAgent: prefs.getStringList('PermessionDealerAgent'),
                  role: data['data']['role'],
                  userName: userName

              ));
            }
          }
        }
/*******************************************************************************************************************************************************/
        /**..................................................Role Resseler....................................................................**/
/****************************************************************************************************************************************/
        if (data['data']['role'] == 'Reseller') {
          if (event.isSwitched == true) {

            if (data['data']['role'] == 'Reseller') {
              emit(ResellerLoginSuccessStateWithBiometric(
                PermessionReseller : prefs.getStringList('PermessionReseller'),
                role: data['data']['role'],
              ));
            } else {
              emit(ResellerLoginSuccessStateWithBiometric(
                PermessionReseller: prefs.getStringList('PermessionReseller'),
                role: data['data']['role'],

              ));
            }
          }
          else {
            if (data['data']['role'] == 'Reseller') {
              print("resseller resseller resseller resseller  ");

              emit(ResellerLoginSuccessState(
                PermessionReseller: prefs.getStringList('PermessionReseller'),
                role: data['data']['role'],
              ));
            } else if(data['data']['role'] == 'Reseller') {
              emit(ResellerLoginSuccessState(
                PermessionReseller: prefs.getStringList('PermessionReseller'),
                role: data['data']['role'],

              ));
            }
          }
        }
/****************************************************************************************************************************************/


        else if(data['data']['role'] != 'Subdealer' && data['data']['role'] != 'Corporate' && data['data']['role'] != 'DeliveryEShop'&& data['data']['role'] != 'ZainOutdoorHeads' && data['data']['role'] !="DealerAgent" && data['data']['role'] !="Reseller"){
          print(data['data']['role']);
          print("new code ");
          /*New code*/
          if (event.isSwitched == true) {
            if (data['data']['role'] != 'Subdealer' && data['data']['role'] != 'Corporate' && data['data']['role'] != 'DeliveryEShop' && data['data']['role'] != 'ZainOutdoorHeads' && data['data']['role'] !="DealerAgent" && data['data']['role'] !="Reseller") {
              emit(SubdealerLoginSuccessStateWithBiometric(
                  tawasolData: tawasolData,
                  Permessions: prefs.getStringList('Permessions'),
                  role: data['data']['role'],
                  userName: userName
              ));
            } else {
              emit(SubdealerLoginSuccessStateWithBiometric(
                  tawasolData: tawasolData,
                  Permessions: prefs.getStringList('Permessions'),
                  role: data['data']['role'],
                  userName: userName
              ));
            }
          }
          else {
            if (data['data']['role'] != 'Subdealer' && data['data']['role'] != 'Corporate'&& data['data']['role'] != 'DeliveryEShop' && data['data']['role'] != 'ZainOutdoorHeads' && data['data']['role'] !="DealerAgent"&& data['data']['role'] !="Reseller") {
              print("NOT Subdealer Corporate DeliveryEShop ZainOutdoorHeads DealerAgent");

              emit(SubdealerLoginSuccessState(
                  tawasolData: tawasolData,
                  Permessions: prefs.getStringList('Permessions'),
                  role: data['data']['role'],
                  userName: userName
              ));
            } else {
              emit(SubdealerLoginSuccessState(
                  tawasolData: tawasolData,
                  Permessions: prefs.getStringList('Permessions'),
                  role: data['data']['role'],
                  userName: userName
              ));
            }
          }
        }
      }
      if (data['status'] == 401) {
        counter = counter + 1;
        prefs.setInt('counter', counter);
        if (prefs.getInt('counter') > 2) {
          counter = 0;
          prefs.setInt('counter', counter);
          emit(LoginErrorState(englishMessage: "Invalid Username or Password",
              arabicMessage: "اسم المستخدم أو كلمة السر خاطئة"));
          emit(DisabeledLoginState());
        } else {
          emit(LoginErrorState(englishMessage: "Invalid Username or Password",
              arabicMessage: "اسم المستخدم أو كلمة السر خاطئة"));
        }
      }
      else if (data['error'] != null) {
        emit(LoginInitState());
        counter = counter + 1;
        prefs.setInt('counter', counter);
        if (prefs.getInt('counter') > 2) {
          counter = 0;
          prefs.setInt('counter', counter);
          emit(LoginErrorState(
              englishMessage: "Something went wrong please try again",
              arabicMessage: "حدث خطأ ما. أعد المحاولة من فضلك"));
          emit(DisabeledLoginState());
        } else {
          emit(LoginErrorState(
              englishMessage: "Something went wrong please try again",
              arabicMessage: "حدث خطأ ما. أعد المحاولة من فضلك"));
        }
      }
    } catch (e) {
      print('caled bloc error TWO');
      print(e);
      // emit(ErrorState(message: e.toString()));
    }
  }

}


