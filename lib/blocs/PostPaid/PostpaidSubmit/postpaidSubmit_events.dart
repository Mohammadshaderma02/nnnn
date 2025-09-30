import 'package:equatable/equatable.dart';
class PostpaidSubmitEvents extends Equatable{
  @override
  // TODO: implement props
  List<Object> get props => [] ;
}
class PostpaidSubmitEvent extends PostpaidSubmitEvents{}
class PostpaidSubmitButtonPressed extends PostpaidSubmitEvents{

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
  final String signatureImageBase64;
  final String locationScreenshotImageBase64;
  final  String extraFreeMonths ;
  final String  extraExtender;


  final String simCard;
  final String contractImageBase64;
  final String deviceSerialNumber;
  final String deviceSerialNumberImageBase64;

  final String parentMSISDN;

  final int salesLeadType;
  final String  salesLeadValue;
  final String onBehalfUser;
  final String resellerID;
  final bool isClaimed;

  final String  backPassportImageBase64;
  final String note;
  final String scheduledDate;
  final String militaryID;
  final String jeeranPromoCode;

  final bool isRental;
  final String device5GType;
  final String serialNumber;
  final String itemCode;
  final String rentalMsisdn;
  final String eshopOrderId;
  final String authCode;
  final String last4Digits;
  final String receiptImageBase64;

  final String documentExpiryDate;
  final String countryId;
  final String email;
  final String homeInternetSpecialPromo;
  final String SimLock;


  PostpaidSubmitButtonPressed({
    this.marketType,
    this.isJordanian,
    this.nationalNo,
    this.passportNo
    ,this.firstName,
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
    this.signatureImageBase64,
    this.locationScreenshotImageBase64,
    this.extraFreeMonths,
    this.extraExtender,
    this.simCard,
    this.contractImageBase64,
    this.deviceSerialNumber,
    this.deviceSerialNumberImageBase64,
    this.parentMSISDN,
    this.salesLeadType,
    this.salesLeadValue,
    this.onBehalfUser,
    this.resellerID,
    this.isClaimed,
    this.backPassportImageBase64,
    this.note,
    this.scheduledDate,
    this.militaryID,
    this.jeeranPromoCode,
    this.isRental,
    this.device5GType,
    this.serialNumber,
    this.itemCode,
    this.rentalMsisdn,
    this.eshopOrderId,
    this.authCode,
    this.last4Digits,
    this.receiptImageBase64,
    this.documentExpiryDate,
    this.countryId,
    this.email,
    this.homeInternetSpecialPromo,
    this.SimLock


  });

}