import "package:dio/dio.dart";
import 'package:bayzat_pokedex/core/error/exception.dart';

enum RequestType { get }
const successCodes = [200, 201];

class HttpManager {
  final Dio dio;
  final ServerException Function(Response<dynamic>? data)? errorResponseMapper;
  HttpManager({
    required this.dio,
    this.errorResponseMapper,
  }) {
    dio.options.connectTimeout = 15000;
    dio.options.receiveTimeout = 15000;
  }

  Future get(String endpoint) =>
      _futureNetworkRequest(RequestType.get, endpoint, {});

  Future _futureNetworkRequest(
    RequestType type,
    String endpoint,
    Map<String, dynamic> data,
  ) async {
    try {
      late Response response;
      switch (type) {
        case RequestType.get:
          response = await dio.get(endpoint);
          break;
        default:
          throw InvalidArgOrDataException();
      }
      if (successCodes.contains(response.statusCode)) {
        return response.data;
      }
      throw errorResponseMapper?.call(response) ??
          serverErrorResponseMapper(response);
    } catch (e) {
      if (e is ServerException) {
        rethrow;
      }
      if (e is DioError) {
        if (e.type == DioErrorType.connectTimeout ||
            e.type == DioErrorType.receiveTimeout) {
          throw TimeoutServerException();
        }
        if (e is FormatException) {
          throw InvalidArgOrDataException();
        }
        if (e.response?.data != null) {
          throw errorResponseMapper?.call(e.response) ??
              serverErrorResponseMapper(e.response);
        }
      }
      throw UnexpectedServerException();
    }
  }
}

ServerException serverErrorResponseMapper(Response<dynamic>? response) {
  final data = response?.data;
  if (data is Map) {
    if (data['message'] != null) return PokedexServerException(data['message']);
    if (data['error'] != null) return PokedexServerException(data['error']);
  }
  return UnexpectedServerException();
}
