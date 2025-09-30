import 'package:equatable/equatable.dart';
class GetBuildingCodeEvents extends Equatable{
  @override
  // TODO: implement props
  List<Object> get props => [] ;
}

class GetBuildingCodeFetchEvent extends GetBuildingCodeEvents{

  final String area;
  final String street;
  final String building;
  GetBuildingCodeFetchEvent(this.area,this.street,this.building);
}
