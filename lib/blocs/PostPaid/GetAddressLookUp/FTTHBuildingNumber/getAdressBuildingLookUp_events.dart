import 'package:equatable/equatable.dart';
class GetAddressLookupBuildingEvents extends Equatable{
  @override
  // TODO: implement props
  List<Object> get props => [] ;
}
class GetAddressLookupBuildingFetchEvent extends GetAddressLookupBuildingEvents{
  final String value;

  GetAddressLookupBuildingFetchEvent(this.value);

}
