// ignore_for_file: use_string_in_part_of_directives, constant_identifier_names

part of clean_arch_network_manager;

class CleanArchNetworkManager {
  static final CleanArchNetworkManager instance =
      CleanArchNetworkManager._internal();
  late Dio _dio;
  BaseOptions? _options;
  VoidCallback Function(CleanArchNetworkManagerError)? _onError;
  CleanArchNetworkManager._internal();

  Future<void> init({
    BaseOptions? options,
    VoidCallback Function(CleanArchNetworkManagerError)? onError,
  }) async {
    _options = options;
    _onError = onError;
  }

  Future<Response?> send({
    BaseOptions? options,
    required String path,
    required RequestType type,
    bool cache = false,
    Map<String, dynamic>? queryParameters,
    dynamic body,
    bool skipSslCertificate = false,
    VoidCallback Function(CleanArchNetworkManagerError)? onError,
  }) async {
    if (options != null) {
      _dio = Dio(options);
    } else if (_options != null) {
      _dio = Dio(_options);
    } else {
      _dio = Dio();
    }

    if (CleanArchConfig.get("DEBUG_NETWORK") == "true") {
      _dio.interceptors.add(InterceptorsWrapper(
        onRequest: (options, handler) {
          CleanArchLog.instance.logSuccess(
              '\x1B[34m🚀 REQUEST: \n Method: ${options.method.toUpperCase()} \n URI: ${options.uri}\x1B[0m\n'
              '\x1B[36m📋 HEADERS: \n${_formatHeaders(options.headers)}\x1B[0m\n');
        },
        onResponse: (response, handler) {
          CleanArchLog.instance.logSuccess(
            '\x1B[33m📦 DATA: \n${_formatData(response.data)}\x1B[0m',
          );
        },
        onError: (DioException error, handler) {
          CleanArchLog.instance.logError(
            '\x1B[31m❌ ERROR ${error.response?.statusCode} ${error.requestOptions.method.toUpperCase()} ${error.requestOptions.uri}\x1B[0m\n'
            '\x1B[35m🔍 Message: ${error.message}\x1B[0m\n'
            '\x1B[33m📦 Response Data: ${_formatData(error.response?.data)}\x1B[0m',
          );
        },
      ));
    }
    try {
 
      Response? response;
      if (cache) {
        var cachedData = await CleanArchStorage.instance.get(path);
        if (cachedData != null) {
          return Response(
            data: jsonDecode(cachedData),
            statusCode: 200,
            requestOptions: RequestOptions(path: path),
          );
        }
      }

      switch (type) {
        case RequestType.GET:
          response = await _dio.get(path, queryParameters: queryParameters);
          break;
        case RequestType.POST:
 
          response = await _dio.post(path, data: body, options: Options());
          break;
        case RequestType.PUT:
          response = await _dio.put(path, data: body);
          break;
        case RequestType.DELETE:
          response = await _dio.delete(path);
          break;
      }

      if (cache) {
        await CleanArchStorage.instance.set(path, jsonEncode(response.data));
      }

      return response;
    } on DioException catch (e) {
      if (onError != null) {
        onError.call(
          _handleDioError(
            e,
          ),
        );
      } else if (_onError != null) {
        _onError?.call(
          _handleDioError(
            e,
          ),
        );
      }
      return null;
    }
  }

  String _formatHeaders(Map<String, dynamic>? headers) {
    if (headers == null) return 'No headers';
    return headers.entries.map((e) => '  ${e.key}: ${e.value}').join('\n');
  }

  String _formatData(dynamic data) {
    if (data == null) return 'No data';
    if (data is Map || data is List) {
      return const JsonEncoder.withIndent('  ').convert(data);
    }
    return data.toString();
  }

}

CleanArchNetworkManagerError _handleDioError(
  DioException e,
) {
  return CleanArchNetworkManagerError(
    e: e,
  );
}

enum RequestType { GET, POST, PUT, DELETE }

class CleanArchNetworkManagerError {
  final DioException e;

  const CleanArchNetworkManagerError({
    required this.e,
  });
}
