import 'package:equatable/equatable.dart';
class GetCurrentPackageEvents extends Equatable{
  @override
  // TODO: implement props
  List<Object> get props => [] ;
}
class GetCurrentPackageEvent extends GetCurrentPackageEvents{}
class GetCurrentPackageButtonPressed extends GetCurrentPackageEvents{
  final String msisdn;
  GetCurrentPackageButtonPressed(this.msisdn);
}