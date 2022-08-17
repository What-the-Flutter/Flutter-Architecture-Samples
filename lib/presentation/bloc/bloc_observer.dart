import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';

// One added bonus of using the bloc library is that we can have access to all Transitions in one place.
// A Transition consists of the current state, the event, and the next state.
class SimpleBlocObserver extends BlocObserver {
  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    log(transition.toString());
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    log(error.toString());
    super.onError(bloc, error, stackTrace);
  }
}
