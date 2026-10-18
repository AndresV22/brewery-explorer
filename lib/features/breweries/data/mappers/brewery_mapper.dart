import 'package:brewery_explorer/features/breweries/data/models/brewery_dto.dart';
import 'package:brewery_explorer/features/breweries/domain/entities/brewery.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class BreweryMapper {
  Brewery toEntity(BreweryDto dto) {
    return Brewery(
      id: dto.id,
      name: dto.name,
      breweryType: dto.breweryType,
      address1: dto.address1,
      city: dto.city,
      state: dto.state,
      postalCode: dto.postalCode,
      country: dto.country,
      phone: dto.phone,
      websiteUrl: dto.websiteUrl,
      longitude: dto.longitude,
      latitude: dto.latitude,
    );
  }

  List<Brewery> toEntityList(List<BreweryDto> dtos) {
    return dtos.map(toEntity).toList(growable: false);
  }
}
