import 'package:http_interceptor/http_interceptor.dart';

class LoggingInterceptor implements InterceptorContract {
  @override
  Future<RequestData> interceptRequest({RequestData data}) async {
    print('Interceptor - Request');
    print('Interceptor - url: ${data.url}');
    print('Interceptor - headers: ${data.headers}');
    print('Interceptor - body: ${data.body}');
    return data;
  }

  @override
  Future<ResponseData> interceptResponse({ResponseData data}) async {
    print('Interceptor - Response');
    print('Interceptor - status code: ${data.statusCode}');
    print('Interceptor - headers: ${data.headers}');
    print('Interceptor - body: ${data.body}');
    return data;
  }
}
