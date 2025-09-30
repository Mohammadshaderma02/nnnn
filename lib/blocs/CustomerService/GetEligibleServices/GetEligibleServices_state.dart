import 'package:equatable/equatable.dart';

class GetEligibleServicesState extends Equatable{
  @override
  // TODO: implement props
  List<Object> get props => [];
}
class GetEligibleServicesInitState extends GetEligibleServicesState{}
class GetEligibleServicesLoadingState extends GetEligibleServicesState{}
class GetEligibleServicesSuccessState extends GetEligibleServicesState{
  List data ;
  GetEligibleServicesSuccessState ({this.data});
}
class GetEligibleServicesErrorState extends GetEligibleServicesState{
  final String arabicMessage ;
  final String englishMessage ;
  GetEligibleServicesErrorState({this.arabicMessage, this.englishMessage});
}

class GetEligibleServicesTokenErrorState extends GetEligibleServicesState{}




