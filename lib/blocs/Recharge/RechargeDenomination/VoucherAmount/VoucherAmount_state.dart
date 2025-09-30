import 'package:equatable/equatable.dart';
class VoucherAmountState extends Equatable{
  @override
  // TODO: implement props
  List<Object> get props => [];
}
class VoucherAmountInitState extends VoucherAmountState{}
class VoucherAmountLoadingState extends VoucherAmountState{}
class VoucherAmountSuccessState extends VoucherAmountState{
  List data ;
  VoucherAmountSuccessState ({this.data});
}
class VoucherAmountErrorState extends VoucherAmountState{
  final String arabicMessage ;
  final String englishMessage ;
  VoucherAmountErrorState({this.arabicMessage, this.englishMessage});
}
class VoucherAmountNoDataState extends VoucherAmountState{
  final String arabicMessage ;
  final String englishMessage ;
  VoucherAmountNoDataState({this.arabicMessage, this.englishMessage});
}
class ChangePackageEligibilityRqTokenErrorState extends VoucherAmountState{
  final String arabicMessage ;
  final String englishMessage ;
  ChangePackageEligibilityRqTokenErrorState({this.arabicMessage, this.englishMessage});
}