import 'package:http/http.dart';
import 'package:http_interceptor/http/intercepted_client.dart';

import 'interceptors/logging.dart';

/// Loga na aplicação.
Future<String> logar() async {
  Response resposta = await client
      .post(Uri.parse("$baseURL/Login/Autenticar?token=$token"))
      .timeout(const Duration(seconds: 5));

  return pegaCookie(resposta);
}

String pegaCookie(Response response) {
  String? rawCookie = response.headers['set-cookie'];
  if (rawCookie != null) {
    int index = rawCookie.indexOf(';');
    return (index == -1) ? rawCookie : rawCookie.substring(0, index);
  }
  return '';
}

/// Url da API
final Uri baseURL = Uri.parse("http://api.olhovivo.sptrans.com.br/v2.1");

/// Token para login
const String token = "52708040eaca46816d1209138a574cb7cc334abcde5458c28c81e0519acece3b";

/// Client usado para a comunicação, utilizando um interceptador para debug
final Client client = InterceptedClient.build(
  interceptors: [LoggingInterceptor()],
);
