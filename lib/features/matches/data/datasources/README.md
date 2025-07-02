# Data Sources Documentation

This directory contains the data source implementations for the matches feature.

## Files

### `matches_remote_data_source.dart`
Handles HTTP API calls to the Tornet API using **Dio** HTTP client.

#### Features:
- **Dio Configuration**: Automatic base URL, headers, and timeout setup
- **Interceptors**: Request/response logging for debugging
- **Error Handling**: Comprehensive error handling with specific error types
- **Bearer Authentication**: Automatic token inclusion in headers

#### Endpoints:
- `GET /todayMatches` - Fetch today's matches
- `GET /yesterdayMatches` - Fetch yesterday's matches  
- `GET /tomorrowMatches` - Fetch tomorrow's matches

#### Configuration:
```dart
dio.options.baseUrl = 'https://staging.torliga.com/api/v1/home';
dio.options.connectTimeout = Duration(seconds: 30);
dio.options.receiveTimeout = Duration(seconds: 30);
dio.options.headers = {
  'Content-Type': 'application/json',
  'Authorization': 'Bearer <token>',
  'Accept': 'application/json',
};
```

### `matches_websocket_data_source.dart`
Handles real-time match updates via WebSocket using **Pusher Channels**.

#### Features:
- **Pusher Integration**: Real-time score updates
- **Event Handling**: Score event processing
- **Connection Management**: Connect/disconnect functionality
- **Error Handling**: WebSocket error management

#### Configuration:
- **URL**: `wss://mqtt.staging.torliga.com/app/4bae652d93c285868d11`
- **Channel**: `thesports-football.matchs`
- **Event**: `score-event`

## Benefits of Dio over HTTP

### 1. **Better Error Handling**
- Typed exceptions (`DioException`)
- Specific error types (timeout, connection, server errors)
- Detailed error information

### 2. **Interceptors**
- Request/response logging
- Authentication header injection
- Error transformation
- Request/response modification

### 3. **Configuration**
- Base URL configuration
- Global headers
- Timeout settings
- Response data parsing

### 4. **Features**
- FormData support
- File upload/download
- Progress tracking
- Request cancellation
- Retry logic

## Usage Example

```dart
// Dependency injection
sl.registerLazySingleton<Dio>(() => Dio());
sl.registerLazySingleton<MatchesRemoteDataSource>(
  () => MatchesRemoteDataSourceImpl(dio: sl()),
);

// API call
final matches = await dataSource.getTodayMatches();
```

## Error Handling

The data source handles various error scenarios:

```dart
try {
  final response = await dio.get(endpoint);
  return response.data;
} on DioException catch (e) {
  if (e.response != null) {
    throw Exception('Server error: ${e.response!.statusCode}');
  } else if (e.type == DioExceptionType.connectionTimeout) {
    throw Exception('Connection timeout');
  } else if (e.type == DioExceptionType.receiveTimeout) {
    throw Exception('Receive timeout');
  } else if (e.type == DioExceptionType.connectionError) {
    throw Exception('Connection error');
  }
  throw Exception('Network error occurred');
}
``` 