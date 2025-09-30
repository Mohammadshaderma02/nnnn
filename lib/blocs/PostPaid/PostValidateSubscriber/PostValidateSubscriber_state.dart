import 'package:equatable/equatable.dart';
class  PostValidateSubscriberState extends Equatable{
  @override
  // TODO: implement props
  List<Object> get props => [];
}
class PostValidateSubscriberInitState extends  PostValidateSubscriberState{}
class PostValidateSubscriberLoadingState extends  PostValidateSubscriberState{}
class PostValidateSubscriberSuccessState extends  PostValidateSubscriberState{
  Map<String,dynamic> data ;
  final String arabicMessage ;
  final String englishMessage ;
  final String msisdn;
  final String Username;
  final String Password;
  var Price;
  final bool sendOTP;
  final bool showSimCard;
  final bool isArmy;
  final bool showCommitmentList;
  final String rentalMsisdn;
  var rentalPrice;
  final String commitment;
  final bool isLocked;


  PostValidateSubscriberSuccessState ({
    this.data,
    this.arabicMessage,
    this.englishMessage,
    this.msisdn,
    this.Username,
    this.Password,
    this.Price,
    this.sendOTP,
    this.showSimCard,
    this.isArmy,
    this.showCommitmentList,
    this.rentalMsisdn,
    this.rentalPrice,
    this.commitment,
    this.isLocked
  });
}
class PostValidateSubscriberErrorState extends  PostValidateSubscriberState{
  final String arabicMessage ;
  final String englishMessage ;
  PostValidateSubscriberErrorState({this.arabicMessage, this.englishMessage});
}

class PostValidateSubscriberTokenErrorState extends  PostValidateSubscriberState{}
