import 'package:equatable/equatable.dart';

class PostpaidSubmitState extends Equatable{
  @override
  // TODO: implement props
  List<Object> get props => [];
}
class PostpaidSubmitInitState extends PostpaidSubmitState{}
class PostpaidSubmitLoadingState extends PostpaidSubmitState{}
class PostpaidSubmitSuccessState extends PostpaidSubmitState{
   final String arabicMessage ;
   final String englishMessage ;
   final String contractUrl;
   final bool showAppointment;

  PostpaidSubmitSuccessState({this.arabicMessage,this.englishMessage,
    this.contractUrl,this.showAppointment});
}

class PostpaidSubmitErrorState extends PostpaidSubmitState{
  final String arabicMessage ;
  final String englishMessage ;
  PostpaidSubmitErrorState({this.arabicMessage, this.englishMessage});
}
class  PostpaidSubmitTokenErrorState extends PostpaidSubmitState{
}
