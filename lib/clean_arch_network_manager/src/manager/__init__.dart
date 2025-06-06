// ignore_for_file: use_string_in_part_of_directives, constant_identifier_names

part of clean_arch_network_manager;

class CleanArchNetworkManager {
  static final CleanArchNetworkManager instance =
      CleanArchNetworkManager._internal();

  late final String _baseUrl;
  late Map<String, String> _defaultHeaders;
  void setHeaders({required Map<String,String> headers}){
    _defaultHeaders = headers;
  }
  http.Client _client = http.Client();
  VoidCallback Function(CleanArchNetworkManagerError)? _onError;

  CleanArchNetworkManager._internal();

  Future<void> init({
    required String baseUrl,
    Map<String, String>? defaultHeaders,
    http.Client? client,
    VoidCallback Function(CleanArchNetworkManagerError)? onError,
  }) async {
    _baseUrl = baseUrl;
    _defaultHeaders = defaultHeaders ?? {'Content-Type': 'application/json'};
    _client = client ?? http.Client();
    _onError = onError;
  }

  Future<http.Response?> send({
    required String path,
    required RequestType type,
    bool cache = false,
    Map<String, dynamic>? queryParameters,
    dynamic body,
    Map<String, dynamic>? headers,
    VoidCallback Function(CleanArchNetworkManagerError)? onError,
  }) async {
    try {
      final uri = Uri.parse(_baseUrl + path).replace(
        queryParameters:
            queryParameters?.map((k, v) => MapEntry(k, v.toString())),
      );

      http.Response response;

      if (cache) {
        final cached = await CleanArchStorage.instance.get(uri.toString());
        if (cached != null) {
          return http.Response(cached, 200);
        }
      }

      switch (type) {
        case RequestType.GET:
          response = await _client.get(uri, headers: _defaultHeaders);
          break;
        case RequestType.POST:
          response = await _client.post(
            uri,
            headers: _defaultHeaders,
            body: jsonEncode(body),
          );
          break;
        case RequestType.PUT:
          response = await _client.put(
            uri,
            headers: _defaultHeaders,
            body: jsonEncode(body),
          );
          break;
        case RequestType.DELETE:
          response = await _client.delete(uri, headers: _defaultHeaders);
          break;
      }

      if (CleanArchConfig.get("DEBUG_NETWORK") == "true") {
        _logRequest(type.name, uri.toString(), body);
        _logResponse(response);
      }

      if (cache) {
        await CleanArchStorage.instance.set(uri.toString(), response.body);
      }

      return response;
    } catch (e) {
      final error = CleanArchNetworkManagerError(e: e);
      if (onError != null) {
        onError.call(error);
      } else {
        _onError?.call(error);
      }
      return null;
    }
  }

  void _logRequest(String method, String url, dynamic body) {
    print('\x1B[34m🚀 REQUEST [$method]: $url\x1B[0m');
    if (body != null) {
      print(
          '\x1B[36m📋 BODY: ${const JsonEncoder.withIndent('  ').convert(body)}\x1B[0m');
    }
  }

  void _logResponse(http.Response response) {
    print('\x1B[33m📦 RESPONSE [${response.statusCode}]:\x1B[0m');
    try {
      print(
          '\x1B[33m${const JsonEncoder.withIndent('  ').convert(jsonDecode(response.body))}\x1B[0m');
    } catch (_) {
      print(response.body);
    }
  }
}

enum RequestType { GET, POST, PUT, DELETE }

class CleanArchNetworkManagerError {
  final dynamic e;
  const CleanArchNetworkManagerError({required this.e});
}
