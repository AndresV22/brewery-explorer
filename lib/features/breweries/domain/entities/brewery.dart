import 'package:equatable/equatable.dart';

class Brewery extends Equatable {
  const Brewery({
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
    this.distanceKm,
  });

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
  final double? distanceKm;

  bool get hasCoordinates => latitude != null && longitude != null;

  String get formattedAddress {
    final parts = <String>[
      if (address1 != null && address1!.isNotEmpty) address1!,
      if (city != null && city!.isNotEmpty) city!,
      if (state != null && state!.isNotEmpty) state!,
      if (postalCode != null && postalCode!.isNotEmpty) postalCode!,
      if (country != null && country!.isNotEmpty) country!,
    ];
    return parts.join(', ');
  }

  Brewery copyWith({
    String? id,
    String? name,
    String? breweryType,
    String? address1,
    String? city,
    String? state,
    String? postalCode,
    String? country,
    String? phone,
    String? websiteUrl,
    double? longitude,
    double? latitude,
    double? distanceKm,
  }) {
    return Brewery(
      id: id ?? this.id,
      name: name ?? this.name,
      breweryType: breweryType ?? this.breweryType,
      address1: address1 ?? this.address1,
      city: city ?? this.city,
      state: state ?? this.state,
      postalCode: postalCode ?? this.postalCode,
      country: country ?? this.country,
      phone: phone ?? this.phone,
      websiteUrl: websiteUrl ?? this.websiteUrl,
      longitude: longitude ?? this.longitude,
      latitude: latitude ?? this.latitude,
      distanceKm: distanceKm ?? this.distanceKm,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        breweryType,
        address1,
        city,
        state,
        postalCode,
        country,
        phone,
        websiteUrl,
        longitude,
        latitude,
        distanceKm,
      ];
}
