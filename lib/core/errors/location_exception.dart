import 'package:brewery_explorer/core/errors/brewery_exception.dart';

class LocationException extends BreweryException {
  const LocationException([
    super.message = 'No se pudo obtener la ubicación.',
  ]);
}
