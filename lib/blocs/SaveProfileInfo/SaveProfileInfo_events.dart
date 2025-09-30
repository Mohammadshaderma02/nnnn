import 'package:equatable/equatable.dart';
class SaveProfileInfoEvents extends Equatable{
  @override
  // TODO: implement props
  List<Object> get props => [] ;
}
class SaveProfileInfoEvent extends SaveProfileInfoEvents{}
class SaveProfileInfoButtonPressed extends SaveProfileInfoEvents{
  final String gender;
  final String nationality;
  final String profession;
  final String language;
  final String comtype;
  final String marital_status;
  final String education;
  final String gift;
  final String email;
  final String day;
  final String month;
  final String year;
  final String MobileNumber;
  final String MobileNumber1;
  final String MobileNumber2;
  final String MobileNumber3;
  final String FirstName;
  final String SecondName;
  final String ThirdName;
  final String FamilytName;


  SaveProfileInfoButtonPressed({this.gender, this.nationality, this.profession,this.language,this.comtype,this.marital_status,this.education,
    this.gift,this.email,this.day,this.month,this.year,this.MobileNumber,this.MobileNumber1,this.MobileNumber2,this.MobileNumber3,
    this.FirstName,this.SecondName,this.ThirdName,this.FamilytName
  });
}