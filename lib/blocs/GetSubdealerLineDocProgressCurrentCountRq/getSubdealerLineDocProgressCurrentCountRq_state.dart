import 'package:equatable/equatable.dart';
class GetSubdealerLineDocProgressCurrentCountRqState extends Equatable{
  @override
  // TODO: implement props
  List<Object> get props => [];
}
class GetSubdealerLineDocProgressCurrentCountRqInitState extends GetSubdealerLineDocProgressCurrentCountRqState{}
class GetSubdealerLineDocProgressCurrentCountRqLoadingState extends GetSubdealerLineDocProgressCurrentCountRqState{}
class GetSubdealerLineDocProgressCurrentCountRqSuccessState extends GetSubdealerLineDocProgressCurrentCountRqState{
  Map<String,dynamic> data ;
  GetSubdealerLineDocProgressCurrentCountRqSuccessState ({this.data});
}
class GetSubdealerLineDocProgressCurrentCountRqErrorState extends GetSubdealerLineDocProgressCurrentCountRqState{
  final String arabicMessage ;
  final String englishMessage ;
  GetSubdealerLineDocProgressCurrentCountRqErrorState({this.arabicMessage, this.englishMessage});
}

class GetSubdealerLineDocProgressCurrentCountRqTokenErrorState extends GetSubdealerLineDocProgressCurrentCountRqState{}
