import 'package:apyar_app/core/extensions/apyar_extensions.dart';
import 'package:apyar_app/core/models/apyar.dart';
import 'package:apyar_app/core/services/apyar_services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ApyarListCubit extends Cubit<ApyarListCubitState> {
  final _service = ApyarServices.instance;

  ApyarListCubit() : super(ApyarListCubitState.empty());

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
      final id = await _service.add(apyar);

      list.insert(0, apyar.copyWith(autoId: id));

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
      await _service.deleteById(apyar.autoId);
      emit(state.copyWith(list: list, errorMessage: ''));
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }
}

class ApyarListCubitState {
  final List<Apyar> list;
  final bool isLoading;
  final String errorMessage;

  const ApyarListCubitState({
    required this.list,
    required this.isLoading,
    required this.errorMessage,
  });

  ApyarListCubitState copyWith({
    List<Apyar>? list,
    bool? isLoading,
    String? errorMessage,
  }) {
    return ApyarListCubitState(
      list: list ?? this.list,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  factory ApyarListCubitState.empty({bool isLoading = false}) {
    return ApyarListCubitState(
      list: const [],
      isLoading: isLoading,
      errorMessage: '',
    );
  }
}
