import 'package:dio/dio.dart';
import 'package:openapi/openapi.dart';

class ApiConfig {
  /// Builds an OpenAPI client backed by Dio with logging enabled by default.
  ///
  /// Logs request method, URL, headers, and body; logs response status and body;
  /// logs errors with stack traces. You can also pass an optional extra
  /// interceptor (e.g. auth header injector) if needed.
  static Openapi client({String? basePath, Interceptor? extraInterceptor}) {
    final dio = Dio(
        BaseOptions(baseUrl: basePath ?? 'https://dev.kaha.com.np/job-portal'));

    // Logging interceptor: request + response + errors
    dio.interceptors.add(LogInterceptor(
      request: true,
      requestHeader: true,
      requestBody: true,
      responseHeader: false,
      responseBody: true,
      error: true,
      logPrint: (obj) {
        // Route logs through debugPrint-friendly sink if needed
        // For now, standard print is sufficient.
        // ignore: avoid_print
        print(obj);
      },
    ));

    if (extraInterceptor != null) {
      dio.interceptors.add(extraInterceptor);
    }

    return Openapi(
        dio: dio,
        basePathOverride: basePath ?? 'https://dev.kaha.com.np/job-portal');
  }

  /// Builds an OpenAPI client with a Dio interceptor that injects candidateId
  /// into any path placeholders like `{id}`.
  /// This avoids passing candidateId through every repo/usecase.
  // static Openapi clientWithStorage({String? basePath, required TokenStorage storage}) {
  //   final dio = Dio(BaseOptions(baseUrl: basePath ?? 'http://localhost:3000'));

  //   dio.interceptors.add(InterceptorsWrapper(
  //     onRequest: (options, handler) async {
  //       try {
  //         final candidateId = await storage.getCandidateId();
  //         if (candidateId != null && candidateId.isNotEmpty) {
  //           // Replace common path placeholders
  //           var path = options.path;
  //           path = path.replaceAll('{id}', candidateId);
  //           // Optionally handle other placeholders if needed
  //           options.path = path;
  //         }
  //       } catch (_) {
  //         // Swallow errors to avoid breaking requests; backend may still handle missing id
  //       }
  //       handler.next(options);
  //     },
  //   ));

  //   return Openapi(dio: dio, basePathOverride: basePath ?? 'http://localhost:3000');
  // }
}
