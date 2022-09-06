import 'package:http/http.dart';
import 'package:http_interceptor/http/intercepted_client.dart';

import 'interceptors/logging.dart';

/// Client usado para a comunicação, utilizando um interceptador para debug
final Client client = InterceptedClient.build(
  interceptors: [LoggingInterceptor()],
);
