import 'package:equatable/equatable.dart';

import '../../../auth/model/model/user_model.dart';

abstract class ProfileState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {}
class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final User user;
  ProfileLoaded(this.user);

  @override
  List<Object?> get props => [user];
}

class ProfileUpdated extends ProfileState {
  final User user;
  ProfileUpdated(this.user);

  @override
  List<Object?> get props => [user];
}

class ProfileFailure extends ProfileState {
  final String message;
  ProfileFailure(this.message);

  @override
  List<Object?> get props => [message];
}