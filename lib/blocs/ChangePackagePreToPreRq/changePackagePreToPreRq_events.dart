import 'package:equatable/equatable.dart';
class ChangePackagePreToPreRqEvents extends Equatable{
  @override
  // TODO: implement props
  List<Object> get props => [] ;
}
class ChangePackagePreToPreRqFetchEvent extends ChangePackagePreToPreRqEvents{
 final String mssid;
 final String newPackageCode;
 final bool isPOSOffer ;
 ChangePackagePreToPreRqFetchEvent(this.mssid,this.newPackageCode,this.isPOSOffer);

}
