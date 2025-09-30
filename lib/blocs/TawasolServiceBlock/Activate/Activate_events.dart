import 'package:equatable/equatable.dart';

class ActivateEvents extends Equatable {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class ActivateStartEvent extends ActivateEvents {}

class ActivatePressed extends ActivateEvents {
  final String msisdn;
  final String simNumber;
  final String puk;


  ActivatePressed({this.msisdn, this.simNumber, this.puk});
}


