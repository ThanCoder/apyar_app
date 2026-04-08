import 'package:apyar_app/bloc_app/ui/fetcher/fetch_item_response_bookmark_services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:apyar_app/bloc_app/ui/fetcher/fetcher_types.dart';

class FetchItemResponseCubit extends Cubit<FetchItemResponseCubitState> {
  final _service = FetchItemResponseBookmarkServices.instance;
  FetchItemResponseCubit() : super(FetchItemResponseCubitState.empty());

  Future<void> init() async {
    try {
      emit(state.copyWith(list: [], isLoading: true, errorMessage: ''));

      final list = await _service.getList();

      emit(state.copyWith(isLoading: false, list: list));
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString(), isLoading: false));
    }
  }

  Future<void> add(FetchItemResponse resp) async {
    final list = state.list;
    list.insert(0, resp);
    await _service.setList(list);
    emit(state.copyWith(list: list));
  }

  Future<void> remove(FetchItemResponse resp) async {
    final list = state.list;
    final index = list.indexWhere((e) => e.item.title == resp.item.title);
    if (index == -1) return;
    // remove
    list.removeAt(index);
    //save
    await _service.setList(list);
    emit(state.copyWith(list: list));
  }

  bool isExists(FetchItemResponse resp) {
    final index = state.list.indexWhere((e) => e.item.title == resp.item.title);
    return index != -1;
  }
}

class FetchItemResponseCubitState {
  final List<FetchItemResponse> list;
  final bool isLoading;
  final String errorMessage;

  const FetchItemResponseCubitState({
    required this.list,
    required this.isLoading,
    required this.errorMessage,
  });

  factory FetchItemResponseCubitState.empty({bool isLoading = false}) {
    return FetchItemResponseCubitState(
      list: [],
      isLoading: isLoading,
      errorMessage: '',
    );
  }

  FetchItemResponseCubitState copyWith({
    List<FetchItemResponse>? list,
    bool? isLoading,
    String? errorMessage,
  }) {
    return FetchItemResponseCubitState(
      list: list ?? this.list,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
