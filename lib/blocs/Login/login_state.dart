import 'package:equatable/equatable.dart';

class LoginState extends Equatable{
  @override
  // TODO: implement props
  List<Object> get props => [];
}
class LoginInitState extends LoginState{}
class LoginLoadingState extends LoginState{}

class SubdealerLoginSuccessState extends LoginState{
  final Map<String,dynamic>  tawasolData;
  final List<dynamic> Permessions ;
  final String role;
  final String userName;
  SubdealerLoginSuccessState({this.tawasolData,this.Permessions,this.role, this.userName});
}
class SubdealerLoginSuccessStateWithBiometric extends LoginState{
  final Map<String,dynamic>  tawasolData;
  final List<dynamic> Permessions ;
  final String role;
  final String userName;

  SubdealerLoginSuccessStateWithBiometric({this.tawasolData,this.Permessions,this.role,this.userName});

}


class CorporateLoginSuccessState extends LoginState{
 // final Map<String,dynamic>  tawasolData;
  final List<dynamic> PermessionCorporate ;
 // final String PermessionCorporate;
  final String role;

  CorporateLoginSuccessState({this.PermessionCorporate,this.role});
}
class CorporateLoginSuccessStateWithBiometric extends LoginState{
  //final Map<String,dynamic>  tawasolData;
  final List<dynamic> PermessionCorporate ;
  //final String PermessionCorporate;
  final String role;

  CorporateLoginSuccessStateWithBiometric({this.PermessionCorporate,this.role});
}

class DeliveryEShopLoginSuccessState extends LoginState{
  final List<dynamic> PermessionDeliveryEShop ;
  final String role;
  DeliveryEShopLoginSuccessState({this.PermessionDeliveryEShop,this.role});
}
class DeliveryEShopLoginSuccessStateWithBiometric extends LoginState{
  final List<dynamic> PermessionDeliveryEShop ;
  final String role;

  DeliveryEShopLoginSuccessStateWithBiometric({this.PermessionDeliveryEShop,this.role});
}
class ZainOutdoorHeadsLoginSuccessState extends LoginState{
  final List<dynamic> PermessionZainOutdoorHeads ;
  final String role;
  final String userName;
  ZainOutdoorHeadsLoginSuccessState({this.PermessionZainOutdoorHeads,this.role,this.userName});
}
class ZainOutdoorHeadsLoginSuccessStateWithBiometric extends LoginState{
  final List<dynamic> PermessionZainOutdoorHeads ;
  final String role;
  final String userName;

  ZainOutdoorHeadsLoginSuccessStateWithBiometric({this.PermessionZainOutdoorHeads,this.role,this.userName});
}

class DealerAgentLoginSuccessState extends LoginState{
  final List<dynamic> PermessionDealerAgent ;
  final String role;
  final String userName;
  DealerAgentLoginSuccessState({this.PermessionDealerAgent,this.role,this.userName});
}
class DealerAgentLoginSuccessStateWithBiometric extends LoginState{
  final List<dynamic> PermessionDealerAgent ;
  final String role;
  final String userName;

  DealerAgentLoginSuccessStateWithBiometric({this.PermessionDealerAgent,this.role,this.userName});
}

class ResellerLoginSuccessState extends LoginState{
 final List<dynamic> PermessionReseller ;
 final String role;

 ResellerLoginSuccessState({this.PermessionReseller,this.role});
}
class ResellerLoginSuccessStateWithBiometric extends LoginState{
  final List<dynamic> PermessionReseller ;
  final String role;
  ResellerLoginSuccessStateWithBiometric({this.PermessionReseller,this.role});
}

class LoginErrorState extends LoginState{
  final String arabicMessage ;
  final String englishMessage ;
  LoginErrorState({this.arabicMessage, this.englishMessage});
}

class LoginErrorTokenState extends LoginState{}

class UserNameLoginErrorState extends LoginState{}
class DisabeledLoginState extends LoginState{}
