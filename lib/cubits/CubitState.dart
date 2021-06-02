class CubitState {}

class LoadingState extends CubitState {
  String loadingMessage;

  LoadingState({this.loadingMessage});
}

class FailedState extends CubitState {
  String message;

  FailedState({this.message});
}

class SuccessState extends CubitState {
  String message;

  SuccessState({this.message});
}

class InitialState extends CubitState {}
