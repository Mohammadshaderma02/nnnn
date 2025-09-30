import 'package:equatable/equatable.dart';
class GetAddressLookupAreaState extends Equatable{
  @override
  // TODO: implement props
  List<Object> get props => [];
}
class GetAddressLookupAreaInitState extends GetAddressLookupAreaState{}
class GetAddressLookupAreaLoadingState extends GetAddressLookupAreaState{}
class GetAddressLookupAreaSuccessState extends GetAddressLookupAreaState{
  List data ;
  GetAddressLookupAreaSuccessState ({this.data});
}

class GetAddressLookupAreaErrorState extends GetAddressLookupAreaState{
  final String arabicMessage ;
  final String englishMessage ;
  GetAddressLookupAreaErrorState({this.arabicMessage, this.englishMessage});
}
class GetAddressLookupAreaTokenErrorState extends GetAddressLookupAreaState{

}