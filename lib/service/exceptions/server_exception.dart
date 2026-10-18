import 'package:brewery_explorer/service/exceptions/brewery_exception.dart';

class ServerException extends BreweryException {
  const ServerException([
    super.message = 'El servidor respondió con un error.',
  ]);
}
