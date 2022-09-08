import 'package:equatable/equatable.dart';

enum PageStatusType {
  none,
  loading,
  loadingMore,
  ready,
  error,
}

class BlocState<T> extends Equatable {
  final T data;
  final PageStatusType status;
  final String? error;

  const BlocState._({
    required this.data,
    this.status = PageStatusType.none,
    this.error,
  });

  factory BlocState.initial(T bootstrapData) =>
      BlocState._(data: bootstrapData);

  bool get isLoading => status == PageStatusType.loading;

  bool get isReady => status == PageStatusType.ready;

  bool get isError => error != null && status == PageStatusType.error;

  bool get isLoadingMore => status == PageStatusType.loadingMore;

  String getError() => error ?? "";

  BlocState<T> copyWith({
    T? data,
    String? error,
    PageStatusType? status,
  }) {
    return BlocState<T>._(
      data: data ?? this.data,
      error: error ?? this.error,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [
        data,
        error,
        status,
      ];
}
