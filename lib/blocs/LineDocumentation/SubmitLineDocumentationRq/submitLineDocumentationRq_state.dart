import 'package:equatable/equatable.dart';

class SubmitLineDocumentationRqState extends Equatable{
  @override
  // TODO: implement props
  List<Object> get props => [];
}
class SubmitLineDocumentationRqInitState extends SubmitLineDocumentationRqState{}
class SubmitLineDocumentationRqLoadingState extends SubmitLineDocumentationRqState{}
class SubmitLineDocumentationRqSuccessState extends SubmitLineDocumentationRqState{
  final String arabicMessage ;
  final String englishMessage ;
  SubmitLineDocumentationRqSuccessState({this.arabicMessage, this.englishMessage});
}

class SubmitLineDocumentationRqErrorState extends SubmitLineDocumentationRqState{
  final String arabicMessage ;
  final String englishMessage ;
  SubmitLineDocumentationRqErrorState({this.arabicMessage, this.englishMessage});
}
class  SubmitLineDocumentationRqTokenErrorState extends SubmitLineDocumentationRqState{
}
