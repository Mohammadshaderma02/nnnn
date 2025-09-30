import 'package:equatable/equatable.dart';

class InquireEvents extends Equatable {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class InquireStartEvent extends InquireEvents {}

class InquirePressed extends InquireEvents {
  final String msisdn;
  InquirePressed({this.msisdn});
}


