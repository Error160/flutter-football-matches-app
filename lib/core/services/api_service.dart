import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../constants/api_constants.dart';
import '../errors/failures.dart';

abstract class ApiService {
  Future<Map<String, dynamic>> get(String endpoint);
  Future<Map<String, dynamic>> post(String endpoint, {Map<String, dynamic>? data});
  Future<Map<String, dynamic>> put(String endpoint, {Map<String, dynamic>? data});
  Future<Map<String, dynamic>> delete(String endpoint);
}

class ApiServiceImpl implements ApiService {
  final Dio _dio;
  
  ApiServiceImpl({Dio? dio}) : _dio = dio ?? Dio() {
    _configureDio();
  }

  void _configureDio() {
    _dio.options.baseUrl = ApiConstants.baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 30);
    _dio.options.receiveTimeout = const Duration(seconds: 30);
    _dio.options.sendTimeout = const Duration(seconds: 30);
    _dio.options.headers = ApiConstants.headers;

    // Add request/response interceptors for logging and error handling
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          debugPrint('🚀 API Request: ${options.method} ${options.uri}');
          if (options.data != null) {
            debugPrint('📤 Request Data: ${options.data}');
          }
          handler.next(options);
        },
        onResponse: (response, handler) {
          debugPrint('✅ API Response: ${response.statusCode} ${response.requestOptions.uri}');
          debugPrint('📥 Response Data Type: ${response.data.runtimeType}');
          handler.next(response);
        },
        onError: (error, handler) {
          debugPrint('❌ API Error: ${error.message}');
          debugPrint('🔗 Error URL: ${error.requestOptions.uri}');
          debugPrint('📊 Status Code: ${error.response?.statusCode}');
          if (error.response?.data != null) {
            debugPrint('💔 Error Data: ${error.response?.data}');
          }
          handler.next(error);
        },
      ),
    );

    // Add retry interceptor for network failures
    _dio.interceptors.add(
      InterceptorsWrapper(
        onError: (error, handler) async {
          if (_shouldRetry(error)) {
            debugPrint('🔄 Retrying request...');
            try {
              final response = await _dio.fetch(error.requestOptions);
              handler.resolve(response);
              return;
            } catch (e) {
              debugPrint('❌ Retry failed: $e');
            }
          }
          handler.next(error);
        },
      ),
    );
  }

  bool _shouldRetry(DioException error) {
    return error.type == DioExceptionType.connectionTimeout ||
           error.type == DioExceptionType.receiveTimeout ||
           error.type == DioExceptionType.sendTimeout ||
           (error.response?.statusCode != null && 
            error.response!.statusCode! >= 500);
  }

  @override
  Future<Map<String, dynamic>> get(String endpoint) async {
    try {
      debugPrint('📡 GET Request: $endpoint');
      final response = await _dio.get(endpoint);
      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e, 'GET', endpoint);
    }
  }

  @override
  Future<Map<String, dynamic>> post(String endpoint, {Map<String, dynamic>? data}) async {
    try {
      debugPrint('📡 POST Request: $endpoint');
      final response = await _dio.post(endpoint, data: data);
      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e, 'POST', endpoint);
    }
  }

  @override
  Future<Map<String, dynamic>> put(String endpoint, {Map<String, dynamic>? data}) async {
    try {
      debugPrint('📡 PUT Request: $endpoint');
      final response = await _dio.put(endpoint, data: data);
      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e, 'PUT', endpoint);
    }
  }

  @override
  Future<Map<String, dynamic>> delete(String endpoint) async {
    try {
      debugPrint('📡 DELETE Request: $endpoint');
      final response = await _dio.delete(endpoint);
      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e, 'DELETE', endpoint);
    }
  }

  Map<String, dynamic> _handleResponse(Response response) {
    if (response.statusCode != null && response.statusCode! >= 200 && response.statusCode! < 300) {
      if (response.data is Map<String, dynamic>) {
        return response.data as Map<String, dynamic>;
      } else if (response.data is List) {
        return {'data': response.data};
      } else if (response.data is String) {
        return {'message': response.data};
      } else {
        return {'success': true, 'data': response.data};
      }
    } else {
      throw ServerFailure('HTTP ${response.statusCode}: ${response.statusMessage}');
    }
  }

  Failure _handleError(dynamic error, String method, String endpoint) {
    debugPrint('💥 API Service Error [$method $endpoint]: $error');
    
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return NetworkFailure('Request timeout. Please check your internet connection.');
        
        case DioExceptionType.badResponse:
          final statusCode = error.response?.statusCode;
          final message = error.response?.data?['message'] ?? error.message;
          
          switch (statusCode) {
            case 400:
              return ServerFailure('Bad request: $message');
            case 401:
              return AuthFailure('Authentication failed. Please check your credentials.');
            case 403:
              return AuthFailure('Access forbidden. You don\'t have permission to access this resource.');
            case 404:
              return ServerFailure('Resource not found.');
            case 422:
              return ValidationFailure(message ?? 'Validation failed.');
            case 500:
              return ServerFailure('Internal server error. Please try again later.');
            case 502:
            case 503:
            case 504:
              return ServerFailure('Server temporarily unavailable. Please try again later.');
            default:
              return ServerFailure('Server error ($statusCode): $message');
          }
        
        case DioExceptionType.cancel:
          return NetworkFailure('Request was cancelled.');
        
        case DioExceptionType.connectionError:
          return NetworkFailure('Connection failed. Please check your internet connection.');
        
        case DioExceptionType.badCertificate:
          return NetworkFailure('SSL certificate error.');
        
        case DioExceptionType.unknown:
          return NetworkFailure('Network error: ${error.message}');
      }
    }
    
    return ServerFailure('Unexpected error occurred: $error');
  }

  // Utility methods for common API patterns
  Future<List<T>> getList<T>(
    String endpoint,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    final response = await get(endpoint);
    final List<dynamic> dataList = response['data'] ?? response['items'] ?? [];
    return dataList.map((item) => fromJson(item as Map<String, dynamic>)).toList();
  }

  Future<T> getObject<T>(
    String endpoint,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    final response = await get(endpoint);
    return fromJson(response['data'] ?? response);
  }

  Future<Map<String, dynamic>> postWithFiles(
    String endpoint,
    Map<String, dynamic> data,
    Map<String, String> filePaths,
  ) async {
    try {
      final formData = FormData();
      
      // Add regular fields
      data.forEach((key, value) {
        formData.fields.add(MapEntry(key, value.toString()));
      });
      
      // Add files
      for (final entry in filePaths.entries) {
        formData.files.add(MapEntry(
          entry.key,
          await MultipartFile.fromFile(entry.value),
        ));
      }
      
      final response = await _dio.post(endpoint, data: formData);
      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e, 'POST (with files)', endpoint);
    }
  }
} 