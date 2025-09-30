import 'package:equatable/equatable.dart';

class GetCurrentPackageState extends Equatable{
  @override
  // TODO: implement props
  List<Object> get props => [];
}
class GetCurrentPackageInitState extends GetCurrentPackageState{}
class GetCurrentPackageLoadingState extends GetCurrentPackageState{}
class GetCurrentPackageSuccessState extends GetCurrentPackageState{
  final String arabicName ;
  final String englishName ;
  GetCurrentPackageSuccessState({this.arabicName, this.englishName});
}

class GetCurrentPackageErrorState extends GetCurrentPackageState{
  final String arabicMessage ;
  final String englishMessage ;
  GetCurrentPackageErrorState({this.arabicMessage, this.englishMessage});
}

class GetCurrentPackageTokenErrorState extends GetCurrentPackageState{

}

