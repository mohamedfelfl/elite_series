import 'package:flutter_bloc/flutter_bloc.dart';

class ShellNavigationState {
  final bool isCollapsed;

  const ShellNavigationState({this.isCollapsed = false});

  ShellNavigationState copyWith({bool? isCollapsed}) {
    return ShellNavigationState(isCollapsed: isCollapsed ?? this.isCollapsed);
  }
}

class ShellNavigationCubit extends Cubit<ShellNavigationState> {
  ShellNavigationCubit() : super(const ShellNavigationState());

  void toggleSidebar() {
    emit(state.copyWith(isCollapsed: !state.isCollapsed));
  }

  void setCollapsed(bool value) {
    emit(state.copyWith(isCollapsed: value));
  }
}
