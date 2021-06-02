
import 'package:flutter_bloc/flutter_bloc.dart';

class UICubit<T> extends Cubit<T>
{
  T currentState;
  UICubit(T state) : super(state);
  void updateState(T isLoaded)
  {
    this.currentState=isLoaded;
    emit(currentState);
  }
}