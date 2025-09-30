import 'package:equatable/equatable.dart';
class GetAddressLookupStreetEvents extends Equatable{
  @override
  // TODO: implement props
  List<Object> get props => [] ;
}
class GetAddressLookupStreetFetchEvent extends GetAddressLookupStreetEvents{
  final String value;

  GetAddressLookupStreetFetchEvent(this.value);

}
