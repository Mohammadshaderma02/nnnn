import 'package:equatable/equatable.dart';
class GetAddressLookupStreetState extends Equatable{
  @override
  // TODO: implement props
  List<Object> get props => [];
}
class GetAddressLookupStreetInitState extends GetAddressLookupStreetState{}
class GetAddressLookupStreetLoadingState extends GetAddressLookupStreetState{}
class GetAddressLookupStreetSuccessState extends GetAddressLookupStreetState{
  List data ;
  GetAddressLookupStreetSuccessState ({this.data});
}

class GetAddressLookupStreetErrorState extends GetAddressLookupStreetState{
  final String arabicMessage ;
  final String englishMessage ;
  GetAddressLookupStreetErrorState({this.arabicMessage, this.englishMessage});
}
class GetAddressLookupStreetokenErrorState extends GetAddressLookupStreetState{

}