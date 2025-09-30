import 'package:equatable/equatable.dart';
class SubmitLineDocumentationRqEvents extends Equatable{
  @override
  // TODO: implement props
  List<Object> get props => [] ;
}
class StartEvent extends SubmitLineDocumentationRqEvents{}
class SubmitLineDocumentationRqEvent extends SubmitLineDocumentationRqEvents{}
class SubmitLineDocumentationRqButtonPressed extends SubmitLineDocumentationRqEvents{
  final String msisdn;
  final String kitCode;
  final String iccid;
  final String listed;
  final String remark;
  final String idImageBase64;
  final String contractImageBase64;
  final String indCompany;
  final String customerTitle;
  final String customerProfession;
  final String customerFirstName;
  final String customerSecondName;
  final String customerThirdName;
  final String customerLastName;
  final String customerMaritalStatus;
  final String customerLanguage;
  final String customerAddressType;
  final String customerHomeTel;
  final String customerHomeTel2;
  final String customerBirthDate;
  final String customerGender;
  final String customerGovernorate;
  final String customerNationality;
  final String customerNationalNumber;
  final String customerIdType;
  final String customerIdNumber;
  final String customerBusinessType;
  final String customerArea;
  final String customerCity;
  final String customerTrade;
  final String customerPF;
  final String customerDepartment;
  final String militaryId;
  final String armyRegisterationTypeId;
  final String armyTypeId;
  final String armyRankId;
  final String  documentExpiryDate;
  SubmitLineDocumentationRqButtonPressed({this.msisdn, this.kitCode,this.iccid,this.listed,this.remark
  ,this.idImageBase64,this.contractImageBase64,this.indCompany,this.customerTitle, this.customerProfession,
    this.customerFirstName,this.customerSecondName,this.customerThirdName,this.customerLastName,this.customerMaritalStatus,
    this.customerLanguage,this.customerAddressType,this.customerHomeTel,this.customerHomeTel2,this.customerBirthDate,this.customerGender,this.customerGovernorate
    , this.customerNationality,this.customerNationalNumber,this.customerIdType,this.customerIdNumber,this.customerBusinessType,
    this.customerArea,this.customerCity,this.customerTrade,this.customerPF,this.customerDepartment,this.militaryId,
    this.armyRegisterationTypeId,this.armyTypeId,this.armyRankId,this.documentExpiryDate
  });

}