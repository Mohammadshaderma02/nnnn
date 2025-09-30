import 'package:equatable/equatable.dart';

class UploadImageEvents extends Equatable{
  @override
  // TODO: implement props
  List<Object> get props => [] ;
}
class UploadImageRepositoryStartEvent extends UploadImageEvents{}

class PressUploadImageRepositoryEvent extends UploadImageEvents{
  final String kitCode;
  final String idImageBase64;
  final String contractImageBase64;

  PressUploadImageRepositoryEvent({this.kitCode, this.idImageBase64, this.contractImageBase64});
}
