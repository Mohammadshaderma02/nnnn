import 'package:equatable/equatable.dart';
class GetPackageEvents extends Equatable{
  @override
  // TODO: implement props
  List<Object> get props => [] ;
}
class GetPackageEventsEvent extends GetPackageEvents{}
class PackageButtonPressed extends GetPackageEvents{
  final String msisdn;
  PackageButtonPressed(this.msisdn);
}