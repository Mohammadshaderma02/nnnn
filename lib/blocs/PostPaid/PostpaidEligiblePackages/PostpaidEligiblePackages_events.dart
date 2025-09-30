import 'package:equatable/equatable.dart';

class PostpaidEligiblePackagesEvents extends Equatable{
  @override
  // TODO: implement props
  List<Object> get props => [] ;
}
class PostpaidEligiblePackagesFetchEvent extends PostpaidEligiblePackagesEvents{}
class PostpaidEligiblePackagesSelect extends PostpaidEligiblePackagesEvents{
  final String marketType;
  final bool isMada;
  PostpaidEligiblePackagesSelect({this.marketType,this.isMada});
}



