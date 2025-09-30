import 'package:equatable/equatable.dart';
class RechargeDenominationState extends Equatable{
  @override
  // TODO: implement props
  List<Object> get props => [];
}
class RechargeDenominationInitState extends RechargeDenominationState{}
class RechargeDenominationLoadingState extends RechargeDenominationState{}
class RechargeDenominationSuccessState extends RechargeDenominationState{
  List data ;
  RechargeDenominationSuccessState ({this.data});
}
class RechargeDenominationErrorState extends RechargeDenominationState{
  final String arabicMessage ;
  final String englishMessage ;
  RechargeDenominationErrorState({this.arabicMessage, this.englishMessage});
}
class RechargeDenominationNoDataState extends RechargeDenominationState{
  final String arabicMessage ;
  final String englishMessage ;
  RechargeDenominationNoDataState({this.arabicMessage, this.englishMessage});
}
class RechargeDenominationTokenErrorState extends RechargeDenominationState{
  final String arabicMessage ;
  final String englishMessage ;
  RechargeDenominationTokenErrorState({this.arabicMessage, this.englishMessage});
}