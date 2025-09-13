
import 'package:openapi/openapi.dart';

class ApiConfig {
  static Openapi client({String? basePath}) {
    return Openapi(basePathOverride:  basePath ?? 'http://localhost:3000');
  }
}
