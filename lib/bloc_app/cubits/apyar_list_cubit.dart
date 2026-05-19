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

  Future<void> init({bool usedCache = true}) async {
    try {
      if (state.isLoading) return;

      emit(state.copyWith(list: [], isLoading: true, errorMessage: ''));
      if (!usedCache) {
        await _service.close();
      }
      final store = await _service.getDualStore();
      final list = await store.apyarBox.getAll();

      emit(state.copyWith(isLoading: false, list: list));
      sort();
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString(), isLoading: false));
    }
  }

  Future<Apyar?> add(Apyar apyar) async {
    try {
      final list = state.list;
      // remove db
      final store = await _service.getDualStore();
      final newId = await store.apyarBox.add(apyar);

      final val = apyar.copyWith(id: newId);
      list.insert(0, val);

      emit(state.copyWith(list: list, errorMessage: ''));
      return val;
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
      return null;
    }
  }

  Future<void> delete(Apyar apyar) async {
    try {
      final list = state.list;
      final index = list.indexWhere((e) => e.autoId == apyar.autoId);
      if (index == -1) return;
      list.removeAt(index);
      // remove db
      final store = await _service.getDualStore();
      await store.apyarBox.deleteById(apyar.id);
      //remove bookmark
      bookmark.delete(apyar);
      // parent content delete
      final deleteContentIdList = <int>[];
      for (var content in await store.contentBox.find(
        (value) => value.apyarId == apyar.id,
      )) {
        deleteContentIdList.add(content.id);
      }
      await store.contentBox.deleteByIdList(deleteContentIdList);

      emit(state.copyWith(list: list, errorMessage: ''));
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  Future<void> update(Apyar apyar) async {
    try {
      final index = state.list.indexWhere((e) => e.id == apyar.id);
      if (index == -1) return;
      final store = await _service.getDualStore();
      await store.apyarBox.updateById(apyar.id, apyar);
      state.list[index] = apyar;

      emit(state.copyWith(list: state.list, errorMessage: ''));
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  bool exists(Apyar apyar) {
    final index = state.list.indexWhere(
      (e) => e.id == apyar.id || e.autoId == apyar.autoId,
    );
    // print('${apyar.title} : $index');
    return index != -1;
  }

  // sort
  void setSort(int id, bool isAsc) {
    emit(state.copyWith(sortId: id, sortAsc: isAsc));
    TRecentDB.getInstance.put('apyar_list_sort_id', id);
    TRecentDB.getInstance.put('apyar_list_sort_isAsc', isAsc);
  }

  void sort() {
    if (state.sortId == TSort.getDateId) {
      state.list.sortDate(isNewest: state.sortAsc);
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
        def: true,
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
