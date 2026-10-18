import 'package:brewery_explorer/core/errors/brewery_exception.dart';

class NetworkException extends BreweryException {
  const NetworkException([
    super.message = 'No se pudo conectar con el servidor.',
  ]);
}
