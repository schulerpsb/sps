import 'package:http_interceptor/http_interceptor.dart';

class JsonInterceptor implements InterceptorContract {
  int debug;

  // constructor
  JsonInterceptor({int debug = 0}) {
    this.debug = debug;
  }

  @override
  Future<RequestData> interceptRequest({RequestData data}) async {
    if(this.debug == 1){
      print('Interceptor - Request');
      print('Interceptor - url: ${data.url}');
      print('Interceptor - headers: ${data.headers}');
      print('Interceptor - body: ${data.body}');
    }
    return data;
  }

  @override
  Future<ResponseData> interceptResponse({ResponseData data}) async {
    if(this.debug == 1){
      print('Interceptor - Response');
      print('Interceptor - status code: ${data.statusCode}');
      print('Interceptor - headers: ${data.headers}');
      print('Interceptor - body: ${data.body}');
    }
    return data;
  }
}
