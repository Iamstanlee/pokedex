import 'package:bayzat_pokedex/core/error/exception.dart';
import 'package:bayzat_pokedex/core/manager/http_manager.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dio/dio.dart';

class MockDioClient extends Mock implements Dio {}

void main() {
  late HttpManager http;
  late Dio dio;
  setUp(() {
    dio = MockDioClient();
    when(() => dio.options).thenReturn(BaseOptions());

    http = HttpManager(dio: dio);
  });

  group('Http.get', () {
    group(".onSuccess", () {
      test('should return success response when statusCode is 200', () async {
        const json = {
          "message": "success",
          "data": "data",
        };
        when(() => dio.get(any())).thenAnswer((_) async => Response(
              requestOptions: RequestOptions(path: ""),
              data: json,
              statusCode: 200,
            ));

        final response = await http.get("/");
        expect(response, json);
      });
    });
    group(".onError", () {
      test('should throw [ServerException] when statusCode is not 200',
          () async {
        when(() => dio.get(any())).thenAnswer((_) async => Response(
              requestOptions: RequestOptions(path: ""),
              statusCode: 400,
            ));
        expect(
          () => http.get("/"),
          throwsA(isInstanceOf<ServerException>()),
        );
      });
      test('should throw [TimeoutServerException] when request timeout',
          () async {
        when(() => dio.get(any())).thenThrow(
          DioError(
            requestOptions: RequestOptions(path: ""),
            type: DioErrorType.connectTimeout,
          ),
        );
        expect(
          () => http.get("/"),
          throwsA(isInstanceOf<TimeoutServerException>()),
        );
      });

      test(
          'should throw [PokedexServerException] when a parsable response is returned',
          () async {
        when(() => dio.get(any())).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(path: ""),
            data: {
              "message": "error",
              "error": "error",
            },
            statusCode: 400,
          ),
        );
        expect(
          () => http.get("/"),
          throwsA(isInstanceOf<PokedexServerException>()),
        );
      });

      group('.onError.errorResponseMapper', () {
        setUp(() {
          dio = MockDioClient();
          when(() => dio.options).thenReturn(BaseOptions());

          http = HttpManager(
            dio: dio,
            errorResponseMapper: (response) => UnexpectedServerException(),
          );
        });
        test(
            'should throw [UnexpectedServerException] when an unparsable response is returned',
            () async {
          when(() => dio.get(any())).thenAnswer(
            (_) async => Response(
              requestOptions: RequestOptions(path: ""),
              data: "",
              statusCode: 500,
            ),
          );
          expect(
            () => http.get("/"),
            throwsA(isInstanceOf<UnexpectedServerException>()),
          );
        });
      });
    });
  });
}
