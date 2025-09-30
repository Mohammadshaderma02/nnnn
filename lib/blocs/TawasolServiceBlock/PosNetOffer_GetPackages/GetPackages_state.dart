import 'package:equatable/equatable.dart';

class GetPackageState extends Equatable{
  @override
  // TODO: implement props
  List<Object> get props => [];
}
class GetPackageInitState extends GetPackageState{}
class GetPackageLoadingState extends GetPackageState{}
class GetPackageSuccessState extends GetPackageState{
  List data ;
  final String arabicName ;
  final String englishName ;
  GetPackageSuccessState({this.arabicName, this.englishName,this.data});
}

class GetPackageErrorState extends GetPackageState{
  final String arabicMessage ;
  final String englishMessage ;
  GetPackageErrorState({this.arabicMessage, this.englishMessage});
}

class GetPackageTokenErrorState extends GetPackageState{

}

