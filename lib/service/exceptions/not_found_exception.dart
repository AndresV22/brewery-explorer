import 'package:brewery_explorer/service/exceptions/brewery_exception.dart';

class NotFoundException extends BreweryException {
  const NotFoundException([
    super.message = 'No se encontró la cervecería.',
  ]);
}
