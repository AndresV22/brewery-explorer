import 'package:brewery_explorer/core/errors/brewery_exception.dart';

class NotFoundException extends BreweryException {
  const NotFoundException([
    super.message = 'No se encontró la cervecería.',
  ]);
}
