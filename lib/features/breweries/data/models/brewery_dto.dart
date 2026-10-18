class BreweryDto {
  const BreweryDto({
    required this.id,
    required this.name,
    required this.breweryType,
    this.address1,
    this.city,
    this.state,
    this.postalCode,
    this.country,
    this.phone,
    this.websiteUrl,
    this.longitude,
    this.latitude,
  });

  factory BreweryDto.fromJson(Map<String, dynamic> json) {
    return BreweryDto(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      breweryType: json['brewery_type'] as String? ?? '',
      address1: json['address_1'] as String?,
      city: json['city'] as String?,
      state: json['state'] as String?,
      postalCode: json['postal_code'] as String?,
      country: json['country'] as String?,
      phone: json['phone'] as String?,
      websiteUrl: json['website_url'] as String?,
      longitude: _parseDouble(json['longitude']),
      latitude: _parseDouble(json['latitude']),
    );
  }

  final String id;
  final String name;
  final String breweryType;
  final String? address1;
  final String? city;
  final String? state;
  final String? postalCode;
  final String? country;
  final String? phone;
  final String? websiteUrl;
  final double? longitude;
  final double? latitude;

  static double? _parseDouble(Object? value) {
    if (value == null) {
      return null;
    }
    if (value is num) {
      return value.toDouble();
    }
    return double.tryParse(value.toString());
  }
}
