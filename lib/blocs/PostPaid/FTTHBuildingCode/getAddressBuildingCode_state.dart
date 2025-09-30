import 'package:equatable/equatable.dart';
class GetBuildingCodeState extends Equatable{
  @override
  // TODO: implement props
  List<Object> get props => [];
}
class GetBuildingCodeInitState extends GetBuildingCodeState{}
class GetBuildingCodeLoadingState extends GetBuildingCodeState{}
class GetBuildingCodeSuccessState extends GetBuildingCodeState{
  String data ;
  GetBuildingCodeSuccessState ({this.data});
}
class GetBuildingCodeErrorState extends GetBuildingCodeState{
  final String arabicMessage ;
  final String englishMessage ;
  GetBuildingCodeErrorState({this.arabicMessage, this.englishMessage});
}
class GetBuildingCodeTokenErrorState extends GetBuildingCodeState{

}