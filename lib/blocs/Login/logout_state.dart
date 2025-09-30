import 'package:equatable/equatable.dart';
class LogoutState extends Equatable{
  @override
  // TODO: implement props
  List<Object> get props => [];
}
class LogoutInitState extends LogoutState{}
class LogoutLoadingState extends LogoutState{}
class LogoutSuccessState extends LogoutState{}
class LogoutErrorState extends LogoutState{
  final String arabicMessage ;
  final String englishMessage ;
  LogoutErrorState({this.arabicMessage, this.englishMessage});
}
