import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_app/Views/HomeScreens/DeliveryEShop/PostPaid/FTTH/Nationality/NationalityList.dart';
// import 'package:huawei_hmsavailability/huawei_hmsavailability.dart';

import 'package:sales_app/blocs/CreateTicket/createTicket_bloc.dart';
import 'package:sales_app/blocs/ForgetPassword/forgetPasssword_state.dart';
import 'package:sales_app/blocs/GetSubdealerLineDocProgressCurrentCountRq/getSubdealerLineDocProgressCurrentCountRq_bloc.dart';
import 'package:sales_app/blocs/GetTawasolInfo/getTawasoInfo_state.dart';
import 'package:sales_app/blocs/GetTawasolInfo/getTawasolInfo_bloc.dart';
import 'package:sales_app/blocs/JordainaianLookUp/LokkUpList_state.dart';
import 'package:sales_app/blocs/JordainaianLookUp/LookUpList_bloc.dart';
import 'package:sales_app/blocs/Login/login_bloc.dart';
import 'package:sales_app/blocs/Login/login_state.dart';
import 'package:sales_app/blocs/LookUpList/LokkUpList_state.dart';
import 'package:sales_app/blocs/LookUpList/LookUpList_bloc.dart';


import 'package:sales_app/repository/PostPaid/GetAddressStreetLookUp_repo.dart';
import 'package:sales_app/repository/PostPaid/GetAdressAreaLookUp_repo.dart';
import 'package:sales_app/repository/PostPaid/GetAdressBuildingLookUp_repo.dart';
import 'package:sales_app/repository/PostPaid/GetFTTHBuildingCode.dart';
import 'package:sales_app/repository/PostPaid/GetPostpaidGSM_MSISDNList.dart';
import 'package:sales_app/repository/PostPaid/PostValidateSubscriber.dart';
import 'package:sales_app/repository/PostPaid/Postpaid%E2%80%8BGenerate%E2%80%8BContract_repo.dart';
import 'package:sales_app/repository/PostPaid/PostpaidEligiblePackages.dart';
import 'package:sales_app/repository/PostPaid/PostpaidStatistics.dart';
import 'package:sales_app/repository/PostPaid/postpaidSubmit_repo.dart';
import 'package:sales_app/repository/changePackageEligibilityRq_repo.dart';
import 'package:sales_app/repository/changePackagePreToPreRq_repo.dart';
import 'package:sales_app/repository/changePassword_repo.dart';
import 'package:sales_app/repository/Notifications_repo.dart';
import 'package:sales_app/repository/create-ticket.dart';
import 'package:sales_app/repository/forgetPassword_repo.dart';
import 'package:sales_app/repository/getCurrentPackage_repo.dart';
import 'package:sales_app/repository/getPending_RejectedLineDocQueue_repo.dart';
import 'package:sales_app/repository/getSubdealerLineDocProgressCurrentCountRq_repo.dart';
import 'package:sales_app/repository/getTawasolList_repo.dart';
import 'package:sales_app/repository/getTawasolNumber_repo.dart';
import 'package:sales_app/repository/jordainianLookUpList.dart';
import 'package:sales_app/repository/login_repo.dart';
import 'package:sales_app/repository/logout_repo.dart';
import 'package:sales_app/repository/lookUpList_repo.dart';
import 'package:sales_app/repository/saveProfileInfo_repo.dart';
import 'package:sales_app/repository/submitLineDocumentationRq_repo.dart';
import 'package:sales_app/repository/validateKitCodeRq_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Views/ForgerPasswordScreens/forgetPasswordSuccess.dart';
import 'Views/HomeScreens/DeliveryEShop/OrdersScreen.dart';
import 'Views/LoginScreens/SplashScreen.dart';
import 'Views/LoginScreens/SignInScreen.dart';
import 'Views/Biometric/Biometric_FingerPrint.dart';
import 'Views/Biometric/Biometric_FaceID.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/CustomBottomNavigationBar.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Dashboard/AcceptedContracts/AcceptedContracts.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Setting/SettingsScreen.dart';
import 'blocs/ChangePackageEligibilityRq/changePackageEligibilityRq_bloc.dart';
import 'blocs/ChangePackageEligibilityRq/changePackageEligibilityRq_state.dart';
import 'blocs/ChangePackagePreToPreRq/changePackagePreToPreRq_bloc.dart';
import 'blocs/ChangePackagePreToPreRq/changePackagePreToPreRq_state.dart';
import 'blocs/ChangePassword/changePassword_bloc.dart';
import 'blocs/ChangePassword/changePassword_state.dart';


import 'blocs/CreateTicket/createTicket_state.dart';
import 'blocs/CustomerService/SendOTPS/SendOTPS_bloc.dart';
import 'blocs/CustomerService/SendOTPS/SendOTPS_state.dart';
import 'blocs/CustomerService/VerifyOTPS/VerifyOTPS_state.dart';
import 'blocs/GetCurrentPackage/getCurrentPackage_bloc.dart';
import 'blocs/GetCurrentPackage/getCurrentPackage_state.dart';
import 'blocs/GetPendingLineDocQueue/getPendingLineDocQueue_bloc.dart';
import 'blocs/GetPendingLineDocQueue/getPendingLineDocQueue_state.dart';
import 'blocs/GetPendingLineDocQueue/getRejectedLineDocQueue_block.dart';
import 'blocs/GetPendingLineDocQueue/getRejectedLineDocQueue_state.dart';
import 'blocs/LineDocumentation/SubmitLineDocumentationRq/submitLineDocumentationRq_bloc.dart';
import 'blocs/LineDocumentation/SubmitLineDocumentationRq/submitLineDocumentationRq_state.dart';
import 'blocs/LineDocumentation/ValidateKitCodeRq/validateKitCodeRq_bloc.dart';
import 'blocs/LineDocumentation/ValidateKitCodeRq/validateKitCodeRq_state.dart';
import 'blocs/Notifications/Notifications_bloc.dart';
import 'blocs/Notifications/Notifications_state.dart';
import 'blocs/ForgetPassword/forgetPasssword_bloc.dart';
import 'blocs/GetSubdealerLineDocProgressCurrentCountRq/getSubdealerLineDocProgressCurrentCountRq_state.dart';
import 'blocs/GetTawasolList/gerTawasolList_bloc.dart';
import 'blocs/GetTawasolList/getTawasolList_state.dart';
import 'blocs/Login/logout_bloc.dart';
import 'blocs/Login/logout_state.dart';
import 'blocs/PostPaid/FTTHBuildingCode/getAddressBuildingCode_bloc.dart';
import 'blocs/PostPaid/FTTHBuildingCode/getAddressBuildingCode_state.dart';
import 'blocs/PostPaid/GSM_MSISDN_LIST/PostpaidGSMMSISDNList_block.dart';
import 'blocs/PostPaid/GSM_MSISDN_LIST/PostpaidGSMMSISDNList_state.dart';
import 'blocs/PostPaid/GetAddressLookUp/FTTHArea/getAdressAreaLookUp_bloc.dart';
import 'blocs/PostPaid/GetAddressLookUp/FTTHArea/getAdressAreaLookUp_state.dart';
import 'blocs/PostPaid/GetAddressLookUp/FTTHBuildingNumber/getAdressBuildingLookUp_bloc.dart';
import 'blocs/PostPaid/GetAddressLookUp/FTTHBuildingNumber/getAdressBuildingLookUp_state.dart';
import 'blocs/PostPaid/GetAddressLookUp/FTTHStreet/getAdressStreetLookUp_bloc.dart';
import 'blocs/PostPaid/GetAddressLookUp/FTTHStreet/getAdressStreetLookUp_state.dart';
import 'blocs/PostPaid/PostValidateSubscriber/PostValidateSubscriber_block.dart';
import 'blocs/PostPaid/PostValidateSubscriber/PostValidateSubscriber_state.dart';
import 'blocs/PostPaid/PostpaidEligiblePackages/PostpaidEligiblePackages_block.dart';
import 'blocs/PostPaid/PostpaidEligiblePackages/PostpaidEligiblePackages_state.dart';
import 'blocs/PostPaid/PostpaidGenerateContract/postpaidGenerateContract_bloc.dart';
import 'blocs/PostPaid/PostpaidGenerateContract/postpaidGenerateContract_state.dart';
import 'blocs/PostPaid/PostpaidStatistics/PostpaidStatistics_block.dart';
import 'blocs/PostPaid/PostpaidStatistics/PostpaidStatistics_state.dart';
import 'blocs/PostPaid/PostpaidSubmit/postpaidSubmit_bloc.dart';
import 'blocs/PostPaid/PostpaidSubmit/postpaidSubmit_state.dart';
import 'blocs/SaveProfileInfo/SaveProfileInfo_bloc.dart';
import 'blocs/SaveProfileInfo/SaveProfileInfo_state.dart';



import 'blocs/UploadImage/UploadImage_bloc.dart';
import 'blocs/UploadImage/UploadImage_state.dart';
import 'package:sales_app/repository/uploadImage_repo.dart';

import 'package:sales_app/blocs/ReservedLine/ReservedLine_bloc.dart';
import 'package:sales_app/blocs/ReservedLine/ReservedLine_state.dart';
import 'package:sales_app/repository/reserveLineDocProgressKit_repo.dart';

import 'package:sales_app/blocs/UnReservedLine/UnReservedLine_bloc.dart';
import 'package:sales_app/blocs/UnReservedLine/UnReservedLine_state.dart';
import 'package:sales_app/repository/UnReserveLineProgressKit_repo.dart';

import 'package:sales_app/blocs/Recharge/RechargeDenomination/RechargeType/RechargeType_bloc.dart';
import 'package:sales_app/blocs/Recharge/RechargeDenomination/RechargeType/RechargeType_state.dart';
import 'package:sales_app/repository/RechargeType_repo.dart';

import 'package:sales_app/blocs/Recharge/RechargeDenomination/VoucherAmount/VoucherAmount_bloc.dart';
import 'package:sales_app/blocs/Recharge/RechargeDenomination/VoucherAmount/VoucherAmount_state.dart';
import 'package:sales_app/repository/VoucherAmount_repo.dart';

import 'package:sales_app/blocs/Recharge/RechargeDenomination/SubmitRechargeDenomination/SubmitRechargeDenomination_bloc.dart';
import 'package:sales_app/blocs/Recharge/RechargeDenomination/SubmitRechargeDenomination/SubmitRechargeDenomination_state.dart';
import 'package:sales_app/repository/SubmitRechargeDenomination_repo.dart';

import 'package:sales_app/blocs/Recharge/DirectRecharge/DirectRecharge_bloc.dart';
import 'package:sales_app/blocs/Recharge/DirectRecharge/DirectRecharge_state.dart';
import 'package:sales_app/repository/DirectRecharge_repo.dart';

import 'package:sales_app/blocs/Recharge/CheckVoucher/CheckVoucher_bloc.dart';
import 'package:sales_app/blocs/Recharge/CheckVoucher/CheckVoucher_states.dart';
import 'package:sales_app/repository/Checkvoucher_repo.dart';

import 'package:sales_app/blocs/TawasolServiceBlock/ExtendValidity/ExtendValidity_bloc.dart';
import 'package:sales_app/blocs/TawasolServiceBlock/ExtendValidity/ExtendValidity_state.dart';
import 'package:sales_app/repository/TawasolService/ExtendValidity_repo.dart';

import 'package:sales_app/blocs/TawasolServiceBlock/Activate/Activate_bloc.dart';
import 'package:sales_app/blocs/TawasolServiceBlock/Activate/Activate_state.dart';
import 'package:sales_app/repository/TawasolService/Activate_repo.dart';

import 'package:sales_app/blocs/TawasolServiceBlock/BuyList/BuyList_bloc.dart';
import 'package:sales_app/blocs/TawasolServiceBlock/BuyList/BuyList_state.dart';
import 'package:sales_app/repository/TawasolService/BuyList_repo.dart';

import 'package:sales_app/blocs/TawasolServiceBlock/BuyNumber/BuyNumber_block.dart';
import 'package:sales_app/blocs/TawasolServiceBlock/BuyNumber/BuyNumber_state.dart';
import 'package:sales_app/repository/TawasolService/BuyNumber_repo.dart';

import 'package:sales_app/blocs/TawasolServiceBlock/Inquire/Inquire_block.dart';
import 'package:sales_app/blocs/TawasolServiceBlock/Inquire/Inquire_state.dart';
import 'package:sales_app/repository/TawasolService/Inquire_repo.dart';

import 'package:sales_app/blocs/TawasolServiceBlock/PosNetOffer_GetPackages/GetPackages_block.dart';
import 'package:sales_app/blocs/TawasolServiceBlock/PosNetOffer_GetPackages/GetPackages_state.dart';
import 'package:sales_app/repository/TawasolService/PosNetOffer_GetPackages_repo.dart';

import 'package:sales_app/blocs/TawasolServiceBlock/ChangePackagePreToPreRqTawasol/ChangePackagePreToPreRqTawasol_bloc.dart';
import 'package:sales_app/blocs/TawasolServiceBlock/ChangePackagePreToPreRqTawasol/ChangePackagePreToPreRqTawasol_state.dart';
import 'package:sales_app/repository/TawasolService/ChangePackagePreToPreRqTawasol_repo.dart';

import 'package:sales_app/blocs/CustomerService/SendOTP/SendOTP_bloc.dart';
import 'package:sales_app/blocs/CustomerService/SendOTP/SendOTP_state.dart';
import 'package:sales_app/repository/CustomerService/SendOTP_repo.dart';

import 'package:sales_app/blocs/CustomerService/SendOTPSCheckMSISDN/SendOTPSCheckMSISDN_bloc.dart';
import 'package:sales_app/blocs/CustomerService/SendOTPSCheckMSISDN/SendOTPSCheckMSISDN_state.dart';

import 'package:sales_app/blocs/CustomerService/VerifyOTP/VerifyOTP_bloc.dart';
import 'package:sales_app/blocs/CustomerService/VerifyOTP/VerifyOTP_state.dart';

import 'package:sales_app/blocs/CustomerService/VerifyOTPSCheckMSISDN/VerifyOTPSCheckMSISDN_bloc.dart';
import 'package:sales_app/blocs/CustomerService/VerifyOTPSCheckMSISDN/VerifyOTPSCheckMSISDN_state.dart';

import 'package:sales_app/blocs/CustomerService/VerifyOTPS/VerifyOTPS_bloc.dart';
import 'package:sales_app/blocs/CustomerService/VerifyOTPS/VerifyOTPS_state.dart';
import 'package:sales_app/repository/CustomerService/VerifyOTP_repo.dart';

import 'package:sales_app/blocs/CustomerService/GetEligibleServices/GetEligibleServices_bloc.dart';
import 'package:sales_app/blocs/CustomerService/GetEligibleServices/GetEligibleServices_state.dart';
import 'package:sales_app/repository/CustomerService/GetEligibleServices_repo.dart';

import 'package:sales_app/blocs/CustomerService/AddRemoveService/AddRemoveService_bloc.dart';
import 'package:sales_app/blocs/CustomerService/AddRemoveService/AddRemoveService_state.dart';
import 'package:sales_app/repository/CustomerService/AddRemoveService_repo.dart';

import 'package:sales_app/blocs/CheckMSISDNAssignedSDLR/CheckMSISDNAssignedSDLR_bloc.dart';
import 'package:sales_app/blocs/CheckMSISDNAssignedSDLR/CheckMSISDNAssignedSDLR_state.dart';
import 'package:sales_app/repository/CheckMSISDNAssignedSDLR_repo.dart';
import 'package:sales_app/blocs/TawasolServiceBlock/ExtendValidityPrice/ExtendValidityPrice_bloc.dart';
import 'package:sales_app/blocs/TawasolServiceBlock/ExtendValidityPrice/ExtendValidityPrice_state.dart';
import 'package:sales_app/repository/TawasolService/GetExtendValidityPrice_repo.dart';

import 'package:sales_app/blocs/PostPaid/GenerateWFMToken/GenerateWFMToken_block.dart';
import 'package:sales_app/blocs/PostPaid/GenerateWFMToken/GenerateWFMToken_state.dart';
import 'package:sales_app/repository/PostPaid/GenerateWFMToken_repo.dart';

import 'package:sales_app/blocs/UpdateVersionBloc/androidBloc/androidBloc_bloc.dart';
import 'package:sales_app/blocs/UpdateVersionBloc/androidBloc/androidBloc_state.dart';
import 'package:sales_app/repository/UpdateVersion/AndroidVersion.dart';



/////////////////////////////*********Corp Part*********/////////////////////////////

import 'package:sales_app/blocs/CorpPart/LookupSearchCriteria/LookupSearchCriteria_block.dart';
import 'package:sales_app/blocs/CorpPart/LookupSearchCriteria/LookupSearchCriteria_state.dart';
import 'package:sales_app/repository/CorpPart/LookupSearchCriteria/LookupSearchCriteria.dart';


import 'package:sales_app/blocs/CorpPart/SearchCriteria/SearchCriteria.block.dart';
import 'package:sales_app/blocs/CorpPart/SearchCriteria/SearchCriteria_state.dart';
import 'package:sales_app/repository/CorpPart/SearchCriteria/SearchCriteria.dart';



import 'package:http_proxy/http_proxy.dart';


MaterialColor createMaterialColor(Color color) {
  Map<int, Color> colorSwatch = {
    50: color.withOpacity(0.1),
    100: color.withOpacity(0.2),
    200: color.withOpacity(0.3),
    300: color.withOpacity(0.4),
    400: color.withOpacity(0.5),
    500: color.withOpacity(0.6),
    600: color.withOpacity(0.7),
    700: color.withOpacity(0.8),
    800: color.withOpacity(0.9),
    900: color.withOpacity(1.0),
  };
  return MaterialColor(color.value, colorSwatch);
}

var initialRoute = '/';
Future<SharedPreferences> prefs =SharedPreferences.getInstance();
void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await EasyLocalization.ensureInitialized();



  //HttpProxy httpProxy = await HttpProxy.createHttpProxy();
  //HttpOverrides.global=httpProxy;

 /* int result = await HmsApiAvailability().getServicesVersionCode();*/
  runApp(EasyLocalization(
    child: MyApp(),
    saveLocale: true,
    path: "i18n",
    supportedLocales: [
      Locale('en', 'US'),
      Locale('ar', 'AR'),
    ],
  ));

}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return MultiBlocProvider(
      providers: [
        BlocProvider( create: (context) => LoginBloc(LoginInitState(), LoginRepository(),GetTawasolNumberRepository())),
        BlocProvider(create: (context) => LogoutBloc(LogoutInitState(), LogoutRepository())),
        BlocProvider(create: (context) => ForgetPasswordBloc( ForgetPasswordInitState(), ForgetPasswordRepository())),
        BlocProvider(create: (context) => ChangePasswordBloc( ChangePasswordInitState(), ChangePasswordRepository()),),
        BlocProvider(create: (context)=>GetTawasolInfoBloc(GetTawasolInfoInitState(), GetTawasolNumberRepository())),
        BlocProvider(create: (context)=>GetTawasolListBloc(GetTawasolListInitState(), GetTawasolListRepository())),
        BlocProvider(create: (context)=>GetSubdealerLineDocProgressCurrentCountRqBloc(GetSubdealerLineDocProgressCurrentCountRqInitState(), GetSubdealerLineDocProgressCurrentCountRqRepository())),
        BlocProvider(create: (context)=>GetNotificationsListBloc(GetNotificationsListInitState(), GetNotificationsRepository())),
        BlocProvider(create: (context)=>GetLookUpListBloc(GetLookUpListInitState(), GetLookUpListRepository())),
        BlocProvider(create: (context)=>SaveProfileInfoBloc(SaveProfileInfoInitState(), SaveProfileInfoRepository())),
        BlocProvider(create: (context)=>GetPendingLineDocQueueBloc(GetPendingLineDocQueueInitState(), GetPendingRejectedLineDocQueueRepository())),
        BlocProvider(create: (context)=>GetRejectedLineDocQueueBloc(GetRejectedLineDocQueueInitState(), GetPendingRejectedLineDocQueueRepository())),
        BlocProvider(create: (context)=>ReservedLineBloc(ReservedLineInitState(), ReservedLineRepository())),
        BlocProvider(create: (context)=>UploadImageBloc(UploadImageStateInitState(), UploadImageRepository())), //New UnReservedLineRepository()
        BlocProvider(create: (context)=>UnReservedLineBloc(UnReservedLineInitState(), UnReservedLineRepository())),
        BlocProvider(create: (context)=>GetCurrentPackageBloc(GetCurrentPackageInitState(), GetCurrentPackageRepository())),
        BlocProvider(create: (context)=>ChangePackageEligibilityRqBloc(ChangePackageEligibilityRqInitState(), ChangePackageEligibilityRqRepository())),
        BlocProvider(create: (context)=>ChangePackagePreToPreRqBloc(ChangePackagePreToPreRqInitState(), ChangePackagePreToPreRqRepository())),
        BlocProvider(create: (context)=>RechargeTypeBloc(RechargeTypeInitState(), RechargeTypeRepository())),
        BlocProvider(create: (context)=>VoucherAmountBloc(VoucherAmountInitState(), VoucherAmountRepository())),
        BlocProvider(create: (context)=>SubmitRechargeDenominationBloc(SubmitRechargeDenominationInitState(), SubmitRechargeDenominationRepository())),
        BlocProvider(create: (context)=>DirectRechargeBloc(DirectRechargeInitState(), DirectRechargeRepository())),
        BlocProvider(create: (context)=>CheckVoucherBloc(CheckVoucherInitState(), CheckVoucherRepository())),
        BlocProvider(create: (context)=>ValidateKitCodeRqBloc(ValidateKitCodeRqInitState(), ValidateKitCodeRqRepository())),
        BlocProvider(create: (context)=>SubmitLineDocumentationRqBloc(SubmitLineDocumentationRqInitState(),SubmitLineDocumentationRqRepository())),
        BlocProvider(create: (context)=>CreateTicketBloc(CreateTicketInitState(),CreateTicketRepository())),
        BlocProvider(create: (context)=>ExtendValidityBloc(ExtendValidityInitState(),ExtendValidityRepository())),
        BlocProvider(create: (context)=>ActivateBloc(ActivateInitState(),ActivateRepository())),
        BlocProvider(create: (context)=>BuyListBloc(BuyListInitState(),BuyListRepository())),
        BlocProvider(create: (context)=>BuyNumberBloc(BuyNumberInitState(),BuyNumberRepository())),
        BlocProvider(create: (context)=>InquireBloc(InquireInitState(),InquireRepository())),
        BlocProvider(create: (context)=>GetPackageBloc(GetPackageInitState(),GetPosNetOfferPackageRepository())),
        BlocProvider(create: (context)=>ChangePackagePreToPreRqTawasolBloc(ChangePackagePreToPreRqTawasolInitState(),ChangePackagePreToPreRqTawasolRepository())),
        BlocProvider(create: (context)=>VerifyOTPBloc(VerifyOTPInitState(),VerifyOTPRepository())),
        BlocProvider(create: (context)=>VerifyOTPSBloc(VerifyOTPSInitState(),VerifyOTPRepository())),
        BlocProvider(create: (context)=>SendOTPBloc(SendOTPInitState(),SendOTPRepository())),
        BlocProvider(create: (context)=>SendOTPSBloc(SendOTPSInitState(),SendOTPRepository())),
        BlocProvider(create: (context)=>GetEligibleServicesBloc(GetEligibleServicesInitState(),GetEligibleServicesRepository())),
        BlocProvider(create: (context)=>AddRemoveServiceBloc(AddRemoveServiceInitState(),AddRemoveServiceRepository())),
        BlocProvider(create: (context)=>CheckMSISDNAssignedSDLRBloc(CheckMSISDNAssignedSDLRInitState(),CheckMSISDNAssignedSDLRRepository())),
        BlocProvider(create: (context)=>VerifyOTPSCheckMSISDNBloc(VerifyOTPSCheckMSISDNInitState(),VerifyOTPRepository())),
        BlocProvider(create: (context)=>SendOTPSCheckMSISDNBloc(SendOTPSCheckMSISDNInitState(),SendOTPRepository())),
        BlocProvider(create: (context)=>GetExtendValidityPriceBloc(GetExtendValidityPriceInitState(),GetExtendValidityPriceRepository())),
        BlocProvider(create: (context)=>GetJordainainLookUpListBloc(GetJordainainLookUpListInitState(),GetJordainainLookUpListRepository())),
        BlocProvider(create: (context)=>PostpaidStatisticsBlock(GetPostpaidStatisticsState(),PostpaidStatisticsRepository())),
        BlocProvider(create: (context)=>PostpaidEligiblePackagesBlock(PostpaidEligiblePackagesState(),PostpaidEligiblePackages())),
        BlocProvider(create: (context)=>PostValidateSubscriberBlock(PostValidateSubscriberState(),PostValidateSubscriberRepository())),
        BlocProvider(create: (context)=>GetAddressLookupAreaBloc(GetAddressLookupAreaInitState(),GetAdressAreaLookUpRepository())),
        BlocProvider(create: (context)=>GetAddressLookupStreetBloc(GetAddressLookupStreetInitState(),GetAdressStreetLookUpRepository())),
        BlocProvider(create: (context)=>GetAddressLookupBuildingBloc(GetAddressLookupBuildingInitState(),GetAdressBuildingLookUpRepository())),
        BlocProvider(create: (context)=>GetBuildingCodeBloc(GetBuildingCodeInitState(),GetBuildingCodeRepository())),
        BlocProvider(create: (context)=>PostpaidGenerateContractBloc(PostpaidGenerateContractInitState(),PostpaidGenerateContractRepository())),
        BlocProvider(create: (context)=>PostpaidSubmitBloc(PostpaidSubmitInitState(),PostpaidSubmitRepository())),
        BlocProvider(create: (context)=>GenerateWFMTokenBlock(PostGenerateWFMTokenInitState(),GetGenerateWFMToken())),
        BlocProvider(create: (context)=>AndroidBloc(AndroidInitState(),UpdateAndroid())),
        BlocProvider(create: (context)=>GetPostPaidGSMMSISDNListBloc(GetPostPaidGSMMSISDNListInitState(),GetPostpaidGSMMSISDNListRepository())),
        BlocProvider(create: (context)=>LookupSearchCriteriaBloc(LookupSearchCriteriaInitState(),LookupSearchCriteriaRepository())),
        BlocProvider(create: (context)=>SearchCriteriaBloc(SearchCriteriaInitState(),SearchCriteriaRepository())),
      ]
      ,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Sales App',
        theme: ThemeData(
          primarySwatch: createMaterialColor(Color(0xFF392156)),
        ),

        supportedLocales: context.supportedLocales,
        localizationsDelegates: context.localizationDelegates,
       // locale:  Locale("ar", "AR"),
       locale:context.locale,
        initialRoute: '/',
        routes: {
          '/': (context) => SplashScreen(),
          '/SignInScreen': (context) => SignInScreen(),
          '/ForgetPasswordSuccess': (context) => ForgetPasswordSuccess(),
          '/BiometricFingerPrint': (context) => BiometricFingerPrint(),
          '/CustomBottomNavigationBar': (context) => CustomBottomNavigationBar(),
          '/BiometricFaceID': (context) => BiometricFaceID(),
          '/AcceptedContracts': (context) => AcceptedContracts(),
          '/SettingsScreen': (context) => SettingsScreen(),
          '/OrdersScreen':(context)=>OrdersScreen(),

        },

      ),
    );
  }
}


