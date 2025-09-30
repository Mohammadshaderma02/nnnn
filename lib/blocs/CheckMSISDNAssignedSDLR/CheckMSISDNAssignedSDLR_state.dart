import 'package:equatable/equatable.dart';

class CheckMSISDNAssignedSDLRState extends Equatable{
  @override
  // TODO: implement props
  List<Object> get props => [];
}
class CheckMSISDNAssignedSDLRInitState extends CheckMSISDNAssignedSDLRState{}
class CheckMSISDNAssignedSDLRLoadingState extends CheckMSISDNAssignedSDLRState{}
class CheckMSISDNAssignedSDLRSuccessState extends CheckMSISDNAssignedSDLRState{
  final String arabicMessage ;
  final String englishMessage ;
  CheckMSISDNAssignedSDLRSuccessState({this.arabicMessage, this.englishMessage});
}
class CheckMSISDNAssignedSDLRErrorState extends CheckMSISDNAssignedSDLRState{
  final String arabicMessage ;
  final String englishMessage ;
  CheckMSISDNAssignedSDLRErrorState({this.arabicMessage, this.englishMessage});
}
class CheckMSISDNAssignedSDLRNoDataState extends CheckMSISDNAssignedSDLRState{
  final String arabicMessage ;
  final String englishMessage ;
  CheckMSISDNAssignedSDLRNoDataState({this.arabicMessage, this.englishMessage});
}
class CheckMSISDNAssignedSDLRTokenErrorState extends CheckMSISDNAssignedSDLRState{
  final String arabicMessage ;
  final String englishMessage ;
  CheckMSISDNAssignedSDLRTokenErrorState({this.arabicMessage, this.englishMessage});
}



