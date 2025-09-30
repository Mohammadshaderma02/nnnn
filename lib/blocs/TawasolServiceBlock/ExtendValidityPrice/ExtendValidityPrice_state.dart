import 'package:equatable/equatable.dart';

class GetExtendValidityPriceState extends Equatable{
  @override
  // TODO: implement props
  List<Object> get props => [];
}
class GetExtendValidityPriceInitState extends GetExtendValidityPriceState{}
class GetExtendValidityPriceLoadingState extends GetExtendValidityPriceState{}
class GetExtendValidityPriceSuccessState extends GetExtendValidityPriceState{
  final String price;
  final String arabicName ;
  final String englishName ;
  final String expiryDate ;
  GetExtendValidityPriceSuccessState({this.arabicName, this.englishName,this.price,this.expiryDate});
}

class GetExtendValidityPriceErrorState extends GetExtendValidityPriceState{
  final String arabicMessage ;
  final String englishMessage ;

  GetExtendValidityPriceErrorState({this.arabicMessage, this.englishMessage});
}

class GetExtendValidityPriceTokenErrorState extends GetExtendValidityPriceState{

}

