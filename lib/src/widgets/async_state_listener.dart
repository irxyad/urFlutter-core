import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:urflutter_core/src/api/api.dart';
import 'package:urflutter_core/src/state/state.dart';
import 'package:urflutter_core/src/widgets/loading/loading.dart';

class AsyncStateListener<B extends StateStreamable<S>, S, T>
    extends StatelessWidget {
  const AsyncStateListener({
    super.key,
    required this.selector,
    required this.onSuccess,
    required this.child,
    this.onFailure,
  });

  final AsyncState<T> Function(S state) selector;
  final void Function(BuildContext context, T data) onSuccess;
  final void Function(BuildContext context, Failure error)? onFailure;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocListener<B, S>(
      listenWhen: (previous, current) =>
          selector(previous) != selector(current),
      listener: (context, state) {
        final asyncState = selector(state);

        switch (asyncState) {
          case AsyncState(isLoading: true):
            UrLoading.show();
          case AsyncState(isSuccess: true):
            UrLoading.hide();
            onSuccess(context, asyncState.data as T);
          case AsyncState(isFailure: true):
            UrLoading.hide();
            final error = asyncState.error!;
            onFailure?.call(context, error);
          default:
            UrLoading.hide();
        }
      },
      child: child,
    );
  }
}
