 import 'package:equatable/equatable.dart';
class LoginEvents extends Equatable{
  @override
  // TODO: implement props
  List<Object> get props => [] ;
}
class StartEvent extends LoginEvents{}
class LoginButtonPressed extends LoginEvents{
  final String userName;
  final String password;
  final String userType;
  final bool isRememberMe;
  final bool isSwitched;
  LoginButtonPressed({this.userName, this.password, this.userType,this.isRememberMe,this.isSwitched} );
}