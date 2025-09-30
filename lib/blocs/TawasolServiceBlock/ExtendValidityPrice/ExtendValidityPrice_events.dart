import 'package:equatable/equatable.dart';
class GetExtendValidityPriceEvents extends Equatable{
  @override
  // TODO: implement props
  List<Object> get props => [] ;
}
class GetExtendValidityPriceEventsEvent extends GetExtendValidityPriceEvents{}
class GetExtendValidityPriceButtonPressed extends GetExtendValidityPriceEvents{
  final String kitCode;
  GetExtendValidityPriceButtonPressed(this.kitCode);
}


