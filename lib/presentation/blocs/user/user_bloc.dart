import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fitness_tracker/domain/entities/user.dart';
import 'package:fitness_tracker/domain/repositories/fitness_repository.dart';

// Events
abstract class UserEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadUser extends UserEvent {}

class UpdateUser extends UserEvent {
  final User user;
  UpdateUser(this.user);
}

// State
abstract class UserState extends Equatable {
  @override
  List<Object?> get props => [];
}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final User user;
  UserLoaded(this.user);
  @override
  List<Object?> get props => [user];
}

// Bloc
class UserBloc extends Bloc<UserEvent, UserState> {
  final FitnessRepository repository;

  UserBloc({required this.repository}) : super(UserInitial()) {
    on<LoadUser>((event, emit) async {
      emit(UserLoading());
      final user = await repository.getUser();
      emit(UserLoaded(user));
    });

    on<UpdateUser>((event, emit) async {
      await repository.saveUser(event.user);
      emit(UserLoaded(event.user));
    });
  }
}
