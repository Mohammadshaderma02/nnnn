import 'package:equatable/equatable.dart';
class RechargeTypeState extends Equatable{
  @override
  // TODO: implement props
  List<Object> get props => [];
}
class RechargeTypeInitState extends RechargeTypeState{}
class RechargeTypeLoadingState extends RechargeTypeState{}
class RechargeTypeSuccessState extends RechargeTypeState{
  List data ;
  RechargeTypeSuccessState ({this.data});
}
class RechargeTypeErrorState extends RechargeTypeState{
  final String arabicMessage ;
  final String englishMessage ;
  RechargeTypeErrorState({this.arabicMessage, this.englishMessage});
}
class RechargeTypeNoDataState extends RechargeTypeState{
  final String arabicMessage ;
  final String englishMessage ;
  RechargeTypeNoDataState({this.arabicMessage, this.englishMessage});
}
class RechargeTypeTokenErrorState extends RechargeTypeState{
  final String arabicMessage ;
  final String englishMessage ;
  RechargeTypeTokenErrorState({this.arabicMessage, this.englishMessage});
}