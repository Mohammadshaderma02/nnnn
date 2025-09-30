import 'package:equatable/equatable.dart';
class PostValidateSubscriberEvents extends Equatable{
  @override
  // TODO: implement props
  List<Object> get props => [] ;
}
class PostValidateSubscriberEventsFetchEvent extends PostValidateSubscriberEvents{}
class PostValidateSubscriberPressed extends PostValidateSubscriberEvents{
  final String marketType;
  final bool isJordanian;
  final String nationalNo;
  final String passportNo;
  final String packageCode;
  final String msisdn;
  final bool isRental;
  final String device5GType;
  final String buildingCode;
  final String serialNumber;
  final String itemCode;
  final bool  isLocked;

  PostValidateSubscriberPressed({
    this.marketType,
    this.isJordanian,
    this.nationalNo,
    this.passportNo,
    this.packageCode,
    this.msisdn,
    this.isRental,
    this.device5GType,
    this.buildingCode,
    this.serialNumber,
    this.itemCode,
    this.isLocked
  });
}