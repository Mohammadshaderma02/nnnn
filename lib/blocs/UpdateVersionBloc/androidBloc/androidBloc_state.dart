import 'package:equatable/equatable.dart';
class AndroidState extends Equatable{
  @override
  // TODO: implement props
  List<Object> get props => [];
}
class AndroidInitState extends AndroidState{}
class AndroidLoadingState extends AndroidState{}
class AndroidSuccessState extends AndroidState{
  String minimumVersion ;
  String currentVersion ;
  AndroidSuccessState ({this.minimumVersion,this.currentVersion});
}
class AndroidErrorState extends AndroidState{
  final String arabicMessage ;
  final String englishMessage ;
  AndroidErrorState({this.arabicMessage, this.englishMessage});
}
class AndroidNoDataState extends AndroidState{
  final String arabicMessage ;
  final String englishMessage ;
  AndroidNoDataState({this.arabicMessage, this.englishMessage});
}
class AndroidTokenErrorState extends AndroidState{
  final String arabicMessage ;
  final String englishMessage ;
  AndroidTokenErrorState({this.arabicMessage, this.englishMessage});
}