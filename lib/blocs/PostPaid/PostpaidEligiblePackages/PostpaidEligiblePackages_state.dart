import 'package:equatable/equatable.dart';

class PostpaidEligiblePackagesState extends Equatable{
  @override
  // TODO: implement props
  List<Object> get props => [];
}
class PostpaidEligiblePackagesStateInitState extends PostpaidEligiblePackagesState{}
class PostpaidEligiblePackagesStateLoadingState extends PostpaidEligiblePackagesState{}
class PostpaidEligiblePackagesStateSuccessState extends PostpaidEligiblePackagesState{
  List data ;
  PostpaidEligiblePackagesStateSuccessState ({this.data});
}
class PostpaidEligiblePackagesStateErrorState extends PostpaidEligiblePackagesState{
  final String arabicMessage ;
  final String englishMessage ;
  PostpaidEligiblePackagesStateErrorState({this.arabicMessage, this.englishMessage});
}

class PostpaidEligiblePackagesStateTokenErrorState extends PostpaidEligiblePackagesState{}




