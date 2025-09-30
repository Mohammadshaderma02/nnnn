import 'package:equatable/equatable.dart';
class ChangePackagePreToPreRqTawasolState extends Equatable{
  @override
  // TODO: implement props
  List<Object> get props => [];
}
class ChangePackagePreToPreRqTawasolInitState extends ChangePackagePreToPreRqTawasolState{}
class ChangePackagePreToPreRqTawasolLoadingState extends ChangePackagePreToPreRqTawasolState{}
class ChangePackagePreToPreRqTawasolSuccessState extends ChangePackagePreToPreRqTawasolState{
  final String arabicMessage ;
  final String englishMessage ;
  ChangePackagePreToPreRqTawasolSuccessState ({this.arabicMessage, this.englishMessage});
}
class ChangePackagePreToPreRqTawasolErrorState extends ChangePackagePreToPreRqTawasolState{
  final String arabicMessage ;
  final String englishMessage ;
  ChangePackagePreToPreRqTawasolErrorState({this.arabicMessage, this.englishMessage});
}

class ChangePackagePreToPreRqTawasolTokenErrorState extends ChangePackagePreToPreRqTawasolState{

}