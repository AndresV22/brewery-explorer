# Brewery Explorer

Aplicación Flutter para explorar cervecerías usando la API pública de [Open Brewery DB](https://www.openbrewerydb.org/).

## Ejecución

Instalar las dependencias y generar los archivos necesarios:

```bash
flutter pub get
dart run build_runner build
```

Ejecutar la aplicación:

```bash
flutter run
```

Ejecutar los tests:

```bash
flutter test
```

## Implementación

La aplicación cuenta con dos pantallas: un listado de cervecerías y una vista con el detalle de cada una.

- Listado paginado con nombre, tipo y ciudad.
- Estados de carga, error y lista vacía.
- Detalle con nombre, dirección, teléfono y sitio web.
- Manejo de errores de la API.
- Separación por capas en `core/` y `features/breweries/`, con `data`, `domain` y `presentation`.
- Inyección de dependencias con `get_it` e `injectable`.
- Estados de UI gestionados con Bloc/Cubit.
- Búsqueda con debounce para evitar solicitudes innecesarias.
- Tests del `BreweryListBloc` para carga inicial, errores, resultados vacíos y búsqueda.

## Decisiones técnicas

Elegí `flutter_bloc` para manejar el estado y `bloc_concurrency` para controlar las búsquedas. La idea fue mantener la lógica fuera de los widgets y dejar que el Bloc se encargue de transformar los resultados y errores en estados que la UI pueda representar.

Organicé el código por feature y separé las capas de datos, dominio y presentación. Para una aplicación de este tamaño puede parecer algo más de estructura de la necesaria, pero permite mantener las responsabilidades separadas y facilita agregar funcionalidades después.

Para el desarrollo usé Gitflow: cada funcionalidad (lista, búsqueda, tests, etc.) vivió en su propia rama `feature/*` a partir de `develop`. Me ayudó a mantener el trabajo ordenado y a revisar los cambios por partes antes de integrarlos.

La inyección de dependencias se configura al iniciar la aplicación. Las páginas reciben sus Blocs y Cubits mediante `BlocProvider`, sin acceder directamente al service locator.

También agregué tests para los principales escenarios del listado, incluida la búsqueda con debounce.

## Pendiente

Dejé fuera algunas funcionalidades que podrían agregarse después:

- Mapa con Mapbox.
- Ordenamiento por distancia usando Geolocator.
- Caché local para consultar los últimos resultados disponibles sin conexión.
- Tests adicionales para el detalle y la paginación.
- Mejoras en la experiencia de búsqueda. Quizás debounce podría aumentar unos milisegundos.

Priorizé completar el flujo principal y dejar una base organizada, con manejo de estados y errores, y con búsqueda de cervecerías antes de agregar funcionalidades adicionales.