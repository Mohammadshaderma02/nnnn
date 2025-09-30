import 'package:equatable/equatable.dart';
class  PostGenerateWFMTokenState extends Equatable{
  @override
  // TODO: implement props
  List<Object> get props => [];
}
class PostGenerateWFMTokenInitState extends  PostGenerateWFMTokenState{}
class PostGenerateWFMTokenLoadingState extends  PostGenerateWFMTokenState{}
class PostGenerateWFMTokenSuccessState extends  PostGenerateWFMTokenState{
  Map<String,dynamic> data ;
  final String arabicMessage ;
  final String englishMessage ;
  final String url;
  final String accessToken;

  PostGenerateWFMTokenSuccessState ({this.data,this.arabicMessage, this.englishMessage,this.url,this.accessToken});
}
class PostGenerateWFMTokenErrorState extends  PostGenerateWFMTokenState{
  final String arabicMessage ;
  final String englishMessage ;
  PostGenerateWFMTokenErrorState({this.arabicMessage, this.englishMessage});
}

class PostGenerateWFMTokenTokenErrorState extends  PostGenerateWFMTokenState{}
