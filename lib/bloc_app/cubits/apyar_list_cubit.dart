import 'package:apyar_app/bloc_app/cubits/apyar_bookmark_list_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:t_widgets/t_widgets.dart';

import 'package:apyar_app/core/extensions/apyar_extensions.dart';
import 'package:apyar_app/core/models/apyar.dart';
import 'package:apyar_app/core/services/apyar_services.dart';
import 'package:than_pkg/than_pkg.dart';

class ApyarListCubit extends Cubit<ApyarListCubitState> {
  final _service = ApyarServices.instance;
  final ApyarBookmarkListCubit bookmark;

  ApyarListCubit(this.bookmark) : super(ApyarListCubitState.empty());

  Future<void> init() async {
    try {
      emit(state.copyWith(list: [], isLoading: true, errorMessage: ''));

      final list = await _service.getAll();

      emit(state.copyWith(isLoading: false, list: list));
      sort();
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString(), isLoading: false));
    }
  }

  Future<int> add(Apyar apyar) async {
    try {
      final list = state.list;
      // remove db
      final id = await _service.add(apyar);

      list.insert(0, apyar.copyWith(autoId: id));

      emit(state.copyWith(list: list, errorMessage: ''));
      return id;
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
      return -1;
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
      //remove bookmark
      bookmark.delete(apyar);
      
      emit(state.copyWith(list: list, errorMessage: ''));
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  // sort
  void setSort(int id, bool isAsc) {
    emit(state.copyWith(sortId: id, sortAsc: isAsc));
    TRecentDB.getInstance.put('apyar_list_sort_id', id);
    TRecentDB.getInstance.put('apyar_list_sort_isAsc', isAsc);
  }

  void sort() {
    if (state.sortId == TSort.getDateId) {
      state.list.sortDate(isNewest: !state.sortAsc);
    }
    if (state.sortId == TSort.getTitleId) {
      state.list.sortTitle(isAToZ: state.sortAsc);
    }
    emit(state);
  }
}

class ApyarListCubitState {
  final List<Apyar> list;
  final bool isLoading;
  final String errorMessage;
  final int sortId;
  final bool sortAsc;
  final List<TSort> sortList;

  const ApyarListCubitState({
    required this.list,
    required this.isLoading,
    required this.errorMessage,
    required this.sortId,
    required this.sortAsc,
    required this.sortList,
  });

  factory ApyarListCubitState.empty({bool isLoading = false}) {
    return ApyarListCubitState(
      list: const [],
      isLoading: isLoading,
      errorMessage: '',
      sortList: TSort.getDefaultList,
      sortAsc: TRecentDB.getInstance.getBool(
        'apyar_list_sort_isAsc',
        def: false,
      ),
      sortId: TRecentDB.getInstance.getInt(
        'apyar_list_sort_id',
        def: TSort.getDateId,
      ),
    );
  }

  ApyarListCubitState copyWith({
    List<Apyar>? list,
    bool? isLoading,
    String? errorMessage,
    int? sortId,
    bool? sortAsc,
    List<TSort>? sortList,
  }) {
    return ApyarListCubitState(
      list: list ?? this.list,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      sortId: sortId ?? this.sortId,
      sortAsc: sortAsc ?? this.sortAsc,
      sortList: sortList ?? this.sortList,
    );
  }
}
