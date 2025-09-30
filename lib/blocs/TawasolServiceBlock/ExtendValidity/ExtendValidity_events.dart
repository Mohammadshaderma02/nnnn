import 'package:equatable/equatable.dart';

class ExtendValidityEvents extends Equatable {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class ExtendValidityStartEvent extends ExtendValidityEvents {}

class ExtendValidityPressed extends ExtendValidityEvents {
  final String msisdn;
  final String kitCode;

  ExtendValidityPressed({this.msisdn, this.kitCode});
}


