import 'package:equatable/equatable.dart';
class PostpaidGenerateContractEvents extends Equatable{
  @override
  // TODO: implement props
  List<Object> get props => [] ;
}
class PostpaidGenerateContractEvent extends PostpaidGenerateContractEvents{}
class PostpaidGenerateContractButtonPressed extends PostpaidGenerateContractEvents{
  final bool isRental;
  final String marketType;
  final bool isJordanian;
  final String nationalNo;
  final String passportNo;
  final String firstName;
  final String secondName;
  final String thirdName;
  final String lastName;
  final String birthDate;
  final String msisdn;
  final String buildingCode;
  final bool migrateMBB;
  final String mbbMsisdn;
  final String packageCode;
  final String username;
  final String password;
  final String referenceNumber;
  final String referenceNumber2;
  final String frontIdImageBase64;
  final String backIdImageBase64;
  final String passportImageBase64;
  final String ContractImageBase64;
  final String locationScreenshotImageBase64;








  final  String extraFreeMonths ;
  final String  extraExtender;


  final String simCard;
  final String contractImageBase64;

  final String deviceSerialNumber;
  final String deviceSerialNumberImageBase64;
  final String onBehalfUser;
  final String resellerID;
  final bool isClaimed;
  final int salesLeadType;
  final String salesLeadValue;
  final String backPassportImageBase64;
  final note;
  final String scheduledDate;
  final String militaryID;
  final String jeeranPromoCode;


  final String device5GType;
  final String serialNumber;
  final String itemCode;
  final String rentalMsisdn;

  final String eshopOrderId;



  PostpaidGenerateContractButtonPressed({
    this.isRental,
    this.marketType,
    this.isJordanian,
    this.nationalNo,
    this.passportNo,
    this.firstName,
    this.secondName,
    this.thirdName,
    this.lastName,
    this.birthDate,
    this.msisdn,
    this.buildingCode,
    this.migrateMBB,
    this.mbbMsisdn,
    this.packageCode,
    this.username,
    this.password,
    this.referenceNumber,
    this.referenceNumber2,
    this.frontIdImageBase64,
    this.backIdImageBase64,
    this.passportImageBase64,
    this.ContractImageBase64,
    this.locationScreenshotImageBase64,
    this.extraFreeMonths,
    this.extraExtender,
    this.simCard,
    this.contractImageBase64,
    this.deviceSerialNumber,
    this.deviceSerialNumberImageBase64,
    this.onBehalfUser,
    this.resellerID,
    this.isClaimed,
    this.salesLeadType,
    this.salesLeadValue,
    this.backPassportImageBase64,
    this.note,
    this.militaryID,
    this.scheduledDate,
    this.jeeranPromoCode,

    this.device5GType,
    this.serialNumber,
    this.itemCode,
    this.rentalMsisdn,
    this.eshopOrderId,


  });

}