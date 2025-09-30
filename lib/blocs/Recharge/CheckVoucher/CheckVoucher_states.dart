import 'package:equatable/equatable.dart';
class CheckVoucherState extends Equatable{
  @override
  // TODO: implement props
  List<Object> get props => [];
}
class CheckVoucherInitState extends CheckVoucherState{}
class CheckVoucherLoadingState extends CheckVoucherState{}
class CheckVoucherSuccessState extends CheckVoucherState{
  final String arabicMessage ;
  final String englishMessage ;
  CheckVoucherSuccessState({this.arabicMessage, this.englishMessage});
}
class CheckVoucherErrorState extends CheckVoucherState{
  final String arabicMessage ;
  final String englishMessage ;
  CheckVoucherErrorState({this.arabicMessage, this.englishMessage});
}
class CheckVoucherNoDataState extends CheckVoucherState{
  final String arabicMessage ;
  final String englishMessage ;
  CheckVoucherNoDataState({this.arabicMessage, this.englishMessage});
}
class CheckVoucherTokenErrorState extends CheckVoucherState{
  final String arabicMessage ;
  final String englishMessage ;
  CheckVoucherTokenErrorState({this.arabicMessage, this.englishMessage});
}



