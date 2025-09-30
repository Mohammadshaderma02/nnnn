import 'package:equatable/equatable.dart';

class ForgetPasswordState extends Equatable{
  @override
  // TODO: implement props
  List<Object> get props => [];
}
class ForgetPasswordInitState extends ForgetPasswordState{}
class ForgetPasswordLoadingState extends ForgetPasswordState{}
class ForgetPasswordSuccessState extends ForgetPasswordState{}
class ForgetPasswordErrorState extends ForgetPasswordState{
  final String arabicMessage ;
  final String englishMessage ;
  ForgetPasswordErrorState({this.arabicMessage, this.englishMessage});
}
class UserNameForgetErrorState extends ForgetPasswordState{}


