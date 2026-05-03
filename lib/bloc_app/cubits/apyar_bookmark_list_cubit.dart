import 'package:apyar_app/core/extensions/apyar_extensions.dart';
import 'package:apyar_app/core/models/apyar.dart';
import 'package:apyar_app/core/services/apyar_bookmark_services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ApyarBookmarkListCubit extends Cubit<ApyarBookmarkListCubitState> {
  final _service = ApyarBookmarkServices.instance;

  ApyarBookmarkListCubit() : super(ApyarBookmarkListCubitState.empty());

  Future<void> init() async {
    try {
      emit(state.copyWith(list: [], isLoading: true, errorMessage: ''));

      final list = await _service.getAll();

      list.sortDate();

      emit(state.copyWith(isLoading: false, list: list));
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString(), isLoading: false));
    }
  }

  Future<void> add(Apyar apyar) async {
    try {
      final list = state.list;
      // remove db
      list.insert(0, apyar);

      await _service.setAll(list);
      emit(state.copyWith(list: list, errorMessage: ''));
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  Future<void> delete(Apyar apyar) async {
    try {
      final list = state.list;
      final index = list.indexWhere((e) => e.autoId == apyar.autoId);
      if (index == -1) return;
      list.removeAt(index);
      // remove db
      await _service.setAll(list);
      emit(state.copyWith(list: list, errorMessage: ''));
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  bool exists(Apyar apyar) {
    final index = state.list.indexWhere((e) => e.autoId == apyar.autoId);
    return index != -1;
  }

  Future<void> toggle(Apyar apyar) async {
    if (exists(apyar)) {
      await delete(apyar);
    } else {
      await add(apyar);
    }
  }
}

class ApyarBookmarkListCubitState {
  final List<Apyar> list;
  final bool isLoading;
  final String errorMessage;

  const ApyarBookmarkListCubitState({
    required this.list,
    required this.isLoading,
    required this.errorMessage,
  });

  ApyarBookmarkListCubitState copyWith({
    List<Apyar>? list,
    bool? isLoading,
    String? errorMessage,
  }) {
    return ApyarBookmarkListCubitState(
      list: list ?? this.list,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  factory ApyarBookmarkListCubitState.empty({bool isLoading = false}) {
    return ApyarBookmarkListCubitState(
      list: const [],
      isLoading: isLoading,
      errorMessage: '',
    );
  }
}
