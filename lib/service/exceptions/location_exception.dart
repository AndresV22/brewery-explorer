import 'package:brewery_explorer/service/exceptions/brewery_exception.dart';

class LocationException extends BreweryException {
  const LocationException([
    super.message = 'No se pudo obtener la ubicación.',
  ]);
}
