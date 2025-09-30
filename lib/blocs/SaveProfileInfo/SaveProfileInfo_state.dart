import 'package:equatable/equatable.dart';

class SaveProfileInfoState extends Equatable{
  @override
  // TODO: implement props
  List<Object> get props => [];
}
class SaveProfileInfoInitState extends SaveProfileInfoState{}
class SaveProfileInfoLoadingState extends SaveProfileInfoState{}
class SaveProfileInfoSuccessState extends SaveProfileInfoState{
  final String arabicMessage ;
  final String englishMessage ;
  SaveProfileInfoSuccessState({this.arabicMessage, this.englishMessage});
}

class SaveProfileInfoErrorState extends SaveProfileInfoState{
  final String arabicMessage ;
  final String englishMessage ;
  SaveProfileInfoErrorState({this.arabicMessage, this.englishMessage});
}

