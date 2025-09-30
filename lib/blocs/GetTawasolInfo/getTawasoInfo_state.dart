import 'package:equatable/equatable.dart';
class GetTawasolInfoState extends Equatable{
  @override
  // TODO: implement props
  List<Object> get props => [];
}
class GetTawasolInfoInitState extends GetTawasolInfoState{}

class GetTawasolInfoLoadingState extends GetTawasolInfoState{}
class GetTawasolInfoSuccessState extends GetTawasolInfoState{
  Map<String,dynamic> data ;
  GetTawasolInfoSuccessState ({this.data});
}
class GetTawasolInfoErrorState extends GetTawasolInfoState{
  final String arabicMessage ;
  final String englishMessage ;
  GetTawasolInfoErrorState({this.arabicMessage, this.englishMessage});
}
class GetTawasolInfoTokenErrorState extends GetTawasolInfoState{

}