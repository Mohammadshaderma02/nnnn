import 'package:equatable/equatable.dart';
class ChangePackagePreToPreRqTawasolEvents extends Equatable{
  @override
  // TODO: implement props
  List<Object> get props => [] ;
}
class ChangePackagePreToPreRqFetchTawasolEvent extends ChangePackagePreToPreRqTawasolEvents{
  final String mssid;
  final String newPackageCode;
  final bool isPOSOffer ;
  final String kitCode;
  ChangePackagePreToPreRqFetchTawasolEvent(this.kitCode,this.mssid,this.newPackageCode,this.isPOSOffer);

}
