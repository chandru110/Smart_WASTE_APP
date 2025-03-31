import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'mainscreen_event.dart';
part 'mainscreen_state.dart';

class MainscreenBloc extends Bloc<MainscreenEvent, MainscreenState> {
  MainscreenBloc() : super(MainscreenInitial()) {
    on<MainscreenEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
