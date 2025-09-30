import 'package:equatable/equatable.dart';
class ChangePackageEligibilityRqState extends Equatable{
  @override
  // TODO: implement props
  List<Object> get props => [];
}
class ChangePackageEligibilityRqInitState extends ChangePackageEligibilityRqState{}
class ChangePackageEligibilityRqLoadingState extends ChangePackageEligibilityRqState{}
class ChangePackageEligibilityRqSuccessState extends ChangePackageEligibilityRqState{
  List data ;
  ChangePackageEligibilityRqSuccessState ({this.data});
}
class ChangePackageEligibilityRqErrorState extends ChangePackageEligibilityRqState{
  final String arabicMessage ;
  final String englishMessage ;
  ChangePackageEligibilityRqErrorState({this.arabicMessage, this.englishMessage});
}
 class ChangePackageEligibilityRqNoDataState extends ChangePackageEligibilityRqState{
   final String arabicMessage ;
   final String englishMessage ;
   ChangePackageEligibilityRqNoDataState({this.arabicMessage, this.englishMessage});
 }
class ChangePackageEligibilityRqTokenErrorState extends ChangePackageEligibilityRqState{
  final String arabicMessage ;
  final String englishMessage ;
  ChangePackageEligibilityRqTokenErrorState({this.arabicMessage, this.englishMessage});
}