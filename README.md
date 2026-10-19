# Brewery Explorer

App Flutter con la API pública de [Open Brewery DB](https://www.openbrewerydb.org/).

## Cómo correrla

```bash
flutter pub get
dart run build_runner build
flutter run
```

## Qué hay hasta ahora

- Capa de datos (Dio, DTO, repositorio, use cases) con DI (`get_it` + `injectable`)
- Lista paginada con loading / error / empty
- Detalle (dirección, teléfono, sitio web)
- Navegación lista → detalle
- Búsqueda con debounce (`bloc_concurrency`)

Arquitectura por features: `core/` + `features/breweries/` (data / domain / presentation).

## Pendiente

- Ordenar por distancia
- Mapa
- Tests y pulido del README
