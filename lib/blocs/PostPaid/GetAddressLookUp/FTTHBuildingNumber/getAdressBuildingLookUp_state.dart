import 'package:equatable/equatable.dart';
class GetAddressLookupBuildingState extends Equatable{
  @override
  // TODO: implement props
  List<Object> get props => [];
}
class GetAddressLookupBuildingInitState extends GetAddressLookupBuildingState{}
class GetAddressLookupBuildingLoadingState extends GetAddressLookupBuildingState{}
class GetAddressLookupBuildingSuccessState extends GetAddressLookupBuildingState{
  List data ;
  GetAddressLookupBuildingSuccessState ({this.data});
}

class GetAddressLookupBuildingErrorState extends GetAddressLookupBuildingState{
  final String arabicMessage ;
  final String englishMessage ;
  GetAddressLookupBuildingErrorState({this.arabicMessage, this.englishMessage});
}
class GetAddressLookupBuildingTokenErrorState extends GetAddressLookupBuildingState{

}