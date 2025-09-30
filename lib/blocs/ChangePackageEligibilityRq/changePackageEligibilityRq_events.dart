import 'package:equatable/equatable.dart';
class ChangePackageEligibilityRqEvents extends Equatable{
  @override
  // TODO: implement props
  List<Object> get props => [] ;
}
class ChangePackageEligibilityRqFetchEvent extends ChangePackageEligibilityRqEvents{
  final String mssid;
  final String isPOSOffer;
  ChangePackageEligibilityRqFetchEvent(this.mssid,this.isPOSOffer);

}
