import 'package:equatable/equatable.dart';

class BuyListState extends Equatable{
  @override
  // TODO: implement props
  List<Object> get props => [];
}
class BuyListInitState extends BuyListState{}
class BuyListLoadingState extends BuyListState{}
class BuyListSuccessState extends BuyListState{
  List data ;
  BuyListSuccessState ({this.data});
}
class BuyListErrorState extends BuyListState{
  final String arabicMessage ;
  final String englishMessage ;
  BuyListErrorState({this.arabicMessage, this.englishMessage});
}

class BuyListTokenErrorState extends BuyListState{}




