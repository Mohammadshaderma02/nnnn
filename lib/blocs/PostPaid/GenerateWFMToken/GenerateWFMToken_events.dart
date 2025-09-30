import 'package:equatable/equatable.dart';
class GetGenerateWFMTokenEvents extends Equatable{
  @override
  // TODO: implement props
  List<Object> get props => [] ;
}
class GetGenerateWFMTokenFetchEvent extends GetGenerateWFMTokenEvents{}
class GetGenerateWFMTokenMSISDN extends GetGenerateWFMTokenEvents{
  final String msisdn;
  GetGenerateWFMTokenMSISDN({this.msisdn});
}
