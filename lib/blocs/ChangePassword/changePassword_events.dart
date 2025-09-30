import 'package:equatable/equatable.dart';

class ChangePasswordEvents extends Equatable {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class ChangeStartEvent extends ChangePasswordEvents {}

class SubmitChangeButtonPressed extends ChangePasswordEvents {
  final String currentPassword;
  final String newPassword;
  SubmitChangeButtonPressed({this.currentPassword, this.newPassword});
}