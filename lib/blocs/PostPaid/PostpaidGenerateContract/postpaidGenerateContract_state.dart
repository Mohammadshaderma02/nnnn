import 'package:equatable/equatable.dart';

class PostpaidGenerateContractState extends Equatable{
  @override
  // TODO: implement props
  List<Object> get props => [];
}
class PostpaidGenerateContractInitState extends PostpaidGenerateContractState{}
class PostpaidGenerateContractLoadingState extends PostpaidGenerateContractState{}
class PostpaidGenerateContractRentalSuccessState extends PostpaidGenerateContractState{
  final String filePathRental;
  PostpaidGenerateContractRentalSuccessState({this.filePathRental});

}
class PostpaidGenerateContractSuccessState extends PostpaidGenerateContractState{
  final String filePath;
  PostpaidGenerateContractSuccessState({this.filePath});
}



class PostpaidGenerateContractErrorState extends PostpaidGenerateContractState{
  final String arabicMessage ;
  final String englishMessage ;
  PostpaidGenerateContractErrorState({this.arabicMessage, this.englishMessage});
}
class  PostpaidGenerateContractTokenErrorState extends PostpaidGenerateContractState{
}
