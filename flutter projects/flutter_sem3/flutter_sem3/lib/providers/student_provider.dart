import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/student_model.dart';
import '../services/student_service.dart';

final _studentServiceProvider = Provider<StudentService>((ref) {
  return StudentService();
});

class _StudentProvider extends AsyncNotifier<List<StudentModel>> {
  @override
  FutureOr<List<StudentModel>> build() {
    final service = ref.watch(_studentServiceProvider);
    return service.fetch();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final service = ref.read(_studentServiceProvider);
      return service.fetch();
    });
  }

  Future<void> delete(int id) async {
    final service = ref.read(_studentServiceProvider);
    await service.delete(id);
    ref.invalidateSelf();
    await future;
  }

}

final studentNotifierProvider = AsyncNotifierProvider(_StudentProvider.new);
