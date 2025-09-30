import 'package:equatable/equatable.dart';
class GetAddressLookupAreaEvents extends Equatable{
  @override
  // TODO: implement props
  List<Object> get props => [] ;
}
class GetAddressLookupAreaFetchEvent extends GetAddressLookupAreaEvents{
  final String value;

  GetAddressLookupAreaFetchEvent(this.value);

}
