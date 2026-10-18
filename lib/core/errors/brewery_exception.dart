abstract class BreweryException implements Exception {
  const BreweryException(this.message);

  final String message;

  @override
  String toString() => message;
}
