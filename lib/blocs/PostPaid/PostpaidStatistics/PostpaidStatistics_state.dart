import 'package:equatable/equatable.dart';
class  GetPostpaidStatisticsState extends Equatable{
  @override
  // TODO: implement props
  List<Object> get props => [];
}
class GetPostpaidStatisticsStateState extends  GetPostpaidStatisticsState{}
class GetPostpaidStatisticsLoadingState extends  GetPostpaidStatisticsState{}
class GetPostpaidStatisticsSuccessState extends  GetPostpaidStatisticsState{
  Map<String,dynamic> data ;
  GetPostpaidStatisticsSuccessState ({this.data});
}
class GetPostpaidStatisticsErrorState extends  GetPostpaidStatisticsState{
  final String arabicMessage ;
  final String englishMessage ;
  GetPostpaidStatisticsErrorState({this.arabicMessage, this.englishMessage});
}

class GetPostpaidStatisticsTokenErrorState extends  GetPostpaidStatisticsState{}
