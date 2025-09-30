import 'package:equatable/equatable.dart';

class ForgetPasswordEvents extends Equatable{
  @override
  // TODO: implement props
  List<Object> get props => [] ;
}
class ForgetStartEvent extends ForgetPasswordEvents{}
class SubmitButtonPressed extends ForgetPasswordEvents{
  final String userName;
  final String userType;
  SubmitButtonPressed({this.userName,this.userType} );
}