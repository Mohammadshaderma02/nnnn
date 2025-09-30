import 'package:equatable/equatable.dart';

class ValidateKitCodeRqState extends Equatable{
  @override
  // TODO: implement props
  List<Object> get props => [];
}
class ValidateKitCodeRqInitState extends ValidateKitCodeRqState{}
class ValidateKitCodeRqLoadingState extends ValidateKitCodeRqState{}
class ValidateKitCodeRqScanLoadingState extends ValidateKitCodeRqState{}
class ValidateKitCodeRqSuccessState extends ValidateKitCodeRqState{
  final String arabicMessage ;
  final String englishMessage ;
  final bool displayReference ;
  final bool isShahamah ;
  final bool showJordanian;
  final bool showNonJordanian;

  ValidateKitCodeRqSuccessState({this.arabicMessage, this.englishMessage,this.displayReference,this.isShahamah, this.showJordanian,this.showNonJordanian});
}
class ValidateKitCodeRqSuccessScanState extends ValidateKitCodeRqState{
  final String arabicMessage ;
  final String englishMessage ;
  final bool displayReference ;
  final bool isShahamah ;
  final bool showJordanian;
  final bool showNonJordanian;
  final String msisdn;
  ValidateKitCodeRqSuccessScanState({this.arabicMessage, this.englishMessage,this.displayReference,this.isShahamah, this.showJordanian,this.showNonJordanian,this.msisdn});
}
class ValidateKitCodeRqErrorState extends ValidateKitCodeRqState{
  final String arabicMessage ;
  final String englishMessage ;
ValidateKitCodeRqErrorState({this.arabicMessage, this.englishMessage});
}

class ValidateKitCodeRqErrorScanState extends ValidateKitCodeRqState{
  final String arabicMessageScan ;
  final String englishMessageScan ;
  ValidateKitCodeRqErrorScanState({this.arabicMessageScan, this.englishMessageScan});
}
class ValidateKitCodeRqTokenErrorState extends ValidateKitCodeRqState{
}
