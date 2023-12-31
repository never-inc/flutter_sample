import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sample/repositories/local_database/database_key.dart';
import 'package:flutter_sample/utils.dart';

final counterControllerProvider =
    AsyncNotifierProvider.autoDispose<CounterController, int>(
  CounterController.new,
);

final class CounterController extends AutoDisposeAsyncNotifier<int> {
  static const _key = DatabaseKey.counter;

  @override
  FutureOr<int> build() async {
    final value =
        await ref.watch(localDatabaseRepositoryProvider).fetchInt(_key);
    return value ?? 0;
  }

  Future<void> increment() async {
    state = await AsyncValue.guard<int>(() async {
      final value = (state.asData?.value ?? 0) + 1;
      await ref.read(localDatabaseRepositoryProvider).saveInt(_key, value);
      return value;
    });
  }
}
