import 'package:equatable/equatable.dart';
class ChangePackagePreToPreRqState extends Equatable{
  @override
  // TODO: implement props
  List<Object> get props => [];
}
class ChangePackagePreToPreRqInitState extends ChangePackagePreToPreRqState{}
class ChangePackagePreToPreRqLoadingState extends ChangePackagePreToPreRqState{}
class ChangePackagePreToPreRqSuccessState extends ChangePackagePreToPreRqState{
  final String arabicMessage ;
  final String englishMessage ;
  ChangePackagePreToPreRqSuccessState ({this.arabicMessage, this.englishMessage});
}
class ChangePackagePreToPreRqErrorState extends ChangePackagePreToPreRqState{
  final String arabicMessage ;
  final String englishMessage ;
  ChangePackagePreToPreRqErrorState({this.arabicMessage, this.englishMessage});
}

class ChangePackagePreToPreRqTokenErrorState extends ChangePackagePreToPreRqState{

}