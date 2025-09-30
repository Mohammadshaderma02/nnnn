import 'package:equatable/equatable.dart';
class ValidateKitCodeRqEvents extends Equatable{
  @override
  // TODO: implement props
  List<Object> get props => [] ;
}

class ValidateKitCodeRqStartEvent extends ValidateKitCodeRqEvents{}
class ValidateKitCodeRqEvent extends ValidateKitCodeRqEvents{}

class ValidateKitCodeRqButtonPressed extends ValidateKitCodeRqEvents{
  final String msisdn;
  final String kitCode;
  final String iccid;
  ValidateKitCodeRqButtonPressed({this.msisdn, this.kitCode,this.iccid });

}
class ValidateKitCodeRqScanButtonPressed extends ValidateKitCodeRqEvents{
  final String msisdn;
  final String kitCode;
  final String iccid;
  ValidateKitCodeRqScanButtonPressed({this.msisdn, this.kitCode,this.iccid });

}