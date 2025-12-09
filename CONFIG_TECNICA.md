# 🔧 Configuración Técnica - BookVerse

## 📋 Especificaciones del Proyecto

### Información General
- **Nombre**: BookVerse
- **Descripción**: Gestor inteligente de libros con API y SQLite
- **Versión**: 1.0.0
- **Tipo**: Aplicación Mobile Multi-plataforma

### Requisitos del Sistema
```
Flutter SDK: ^3.9.2
Dart SDK: ^3.9.2
Android: 5.0+ (API 21+)
iOS: 11.0+
Windows: 10+
Web: Chrome, Firefox, Safari, Edge
```

---

## 📦 Dependencias Instaladas

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  http: ^1.2.0              # HTTP Client para API
  sqflite: ^2.3.0           # SQLite Database
  path_provider: ^2.1.0     # File System Access
  intl: ^0.20.0             # Internacionalization

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^5.0.0
```

---

## 🗄️ Arquitectura de Base de Datos

### Tabla: `books`

```sql
CREATE TABLE books(
    id TEXT PRIMARY KEY,
    title TEXT NOT NULL,
    author TEXT NOT NULL,
    description TEXT,
    imageUrl TEXT,
    publishedDate TEXT,
    pages INTEGER,
    rating REAL,
    isbn TEXT,
    isFavorite INTEGER DEFAULT 0,
    addedDate TEXT NOT NULL
)
```

**Campos:**
- `id`: ID único del libro (desde API de Google)
- `title`: Título del libro
- `author`: Autor/Autores (concatenados por comas)
- `description`: Sinopsis del libro
- `imageUrl`: URL de la portada
- `publishedDate`: Fecha de publicación
- `pages`: Número de páginas
- `rating`: Calificación (0-5)
- `isbn`: ISBN-13 del libro
- `isFavorite`: Boolean (0=no, 1=sí)
- `addedDate`: Fecha de agregación a la biblioteca

---

## 🌐 Integración de API

### Google Books API

**Endpoint Base:**
```
https://www.googleapis.com/books/v1/volumes
```

**API Key:**
```
AIzaSyA1tqKrBgZT1ZpZvRFr1h_p1l5Mq-eVqgg
```

**Parámetros de Búsqueda:**
```
q=<query>              - Búsqueda general
inauthor:<author>      - Por autor
inpublisher:<pub>      - Por editorial
isbn:<isbn>            - Por ISBN
maxResults=<num>       - Límite de resultados
key=<apikey>           - API Key
```

**Respuesta JSON:**
```json
{
  "kind": "books#volumes",
  "totalItems": 1000,
  "items": [
    {
      "kind": "books#volume",
      "id": "bookId",
      "volumeInfo": {
        "title": "Book Title",
        "authors": ["Author Name"],
        "publisher": "Publisher",
        "publishedDate": "2024-01-01",
        "description": "Description...",
        "pageCount": 300,
        "averageRating": 4.5,
        "imageLinks": {
          "thumbnail": "http://..."
        },
        "industryIdentifiers": [
          {
            "type": "ISBN_13",
            "identifier": "978..."
          }
        ]
      }
    }
  ]
}
```

---

## 🏗️ Estructura de Modelos

### Clase: `Book`

```dart
class Book {
  final String? id;
  final String title;
  final String author;
  final String? description;
  final String? imageUrl;
  final String? publishedDate;
  final int? pages;
  final double? rating;
  final String? isbn;
  final bool isFavorite;
  final DateTime? addedDate;
}
```

**Métodos:**
- `Book.fromJson()` - Crear desde respuesta API
- `Book.fromDatabase()` - Crear desde SQLite
- `toJson()` - Convertir a JSON para BD
- `copyWith()` - Crear copia modificada

---

## 🔧 Servicios

### ApiService

**Métodos Disponibles:**

```dart
// Búsqueda general
static Future<List<Book>> searchBooks(String query)

// Búsqueda específica
static Future<List<Book>> searchByAuthor(String author)
static Future<List<Book>> searchByPublisher(String publisher)
static Future<List<Book>> searchByIsbn(String isbn)

// Detalles
static Future<Book?> getBookDetails(String bookId)
```

**Manejo de Errores:**
- Excepción si no hay conexión
- Código de estado 200 = éxito
- Otros códigos = error

### DatabaseService (Singleton)

**CRUD Operations:**

```dart
// CREATE
Future<void> addBook(Book book)

// READ
Future<List<Book>> getAllBooks()
Future<List<Book>> getFavoriteBooks()
Future<Book?> getBookById(String id)
Future<List<Book>> searchBooksByTitle(String title)
Future<List<Book>> searchBooksByAuthor(String author)

// UPDATE
Future<void> updateBook(Book book)
Future<void> toggleFavorite(String id, bool isFavorite)

// DELETE
Future<void> deleteBook(String id)
Future<void> deleteAllBooks()

// QUERIES
Future<int> getTotalBooks()
Future<int> getTotalFavorites()
```

---

## 🎨 Diseño y Paleta de Colores

```dart
// Colores Principales
Colors.deepPurple.shade700  // #5E35B1 - Púrpura primario
Colors.blue.shade500         // #2196F3 - Azul secundario

// Gradientes
LinearGradient(
  colors: [Colors.deepPurple.shade700, Colors.blue.shade500]
)

// Estados
Colors.green               // Guardar
Colors.red                 // Eliminar/Favorito
Colors.amber               // Rating
Colors.grey                // Textos secundarios
```

---

## 📐 Estructura de Pantallas

### HomeScreen
- `_HomeScreenState` - Widget raíz
- Dos pestañas: Biblioteca y Favoritos
- GridView de 2 columnas
- FAB para búsqueda

### SearchScreen
- Campo de búsqueda en vivo
- GridView de resultados
- Botones de guardar/eliminar
- Conexión a API

### DetailScreen
- Portada grande
- Información en cards
- Botones de acción
- Descripción completa

### BookCard (Widget)
- Portada con placeholder
- Título y autor
- Rating visual
- Botón favorito

---

## 🔄 Flujo de Datos

```
[API Google Books]
        ↓
   [ApiService]
        ↓
   [Search Results]
        ↓
    [DetailScreen]
        ↓
    [Add to DB]
        ↓
 [DatabaseService]
        ↓
 [SQLite Storage]
        ↓
   [HomeScreen]
        ↓
    [GridView]
```

---

## 🚀 Compilación y Distribución

### Compilar para Android
```bash
flutter build apk              # APK simple
flutter build appbundle        # App Bundle (Play Store)
flutter build apk --release    # Release optimizado
```

### Compilar para iOS
```bash
flutter build ios
flutter build ios --release
```

### Compilar para Windows
```bash
flutter build windows
flutter build windows --release
```

### Compilar para Web
```bash
flutter build web
flutter build web --release
```

---

## 📊 Métricas y Rendimiento

**Optimizaciones Implementadas:**
- FutureBuilder para carga asíncrona
- GridView con physics: NeverScrollableScrollPhysics en listas anidadas
- Material 3 para interfaz moderna
- Caché de imágenes automático

**Características de Rendimiento:**
- SQLite para BD local rápida
- HTTP caching automático
- Lazy loading de imágenes
- Singleton de DatabaseService

---

## 🔐 Seguridad

**Consideraciones:**
- API Key es pública (solo lectura)
- No hay autenticación de usuario
- Datos almacenados localmente de forma segura
- Validación de URLs de imágenes

**Mejoras Futuras:**
- Autenticación con Google
- Sincronización en la nube
- Cifrado de datos sensibles

---

## 📱 Responsive Design

- **Diseño adaptativo** para todos los tamaños
- **GridView flexible** que se ajusta al ancho
- **FAB posicionado** correctamente
- **Padding consistente** en todas las pantallas

---

## 🧪 Testing

Para agregar tests:

```dart
// En test/widget_test.dart
testWidgets('Test description', (WidgetTester tester) async {
  await tester.pumpWidget(const MyApp());
  expect(find.byType(HomeScreen), findsOneWidget);
});
```

Ejecutar tests:
```bash
flutter test
```

---

## 📝 Logging y Debugging

**Para debugging:**
```bash
flutter run -v        # Verbose logging
flutter run --profile # Profile mode
flutter run --release # Release mode
```

**Print debugging:**
```dart
print('Debug info: $variable');
debugPrint('Este es un debug print');
```

---

## 🌍 Internacionalización

**Funciones con soporte:**
- Formato de fechas con `intl`
- Números con locales
- Potencial para múltiples idiomas

---

## 📞 Soporte Técnico

### Comandos Útiles

```bash
flutter clean              # Limpiar caché
flutter pub get            # Instalar dependencias
flutter pub upgrade        # Actualizar dependencias
flutter analyze            # Analizar código
flutter format             # Formatear código
flutter doctor             # Diagnóstico del sistema
```

### Archivos Importantes

- `pubspec.yaml` - Configuración del proyecto
- `analysis_options.yaml` - Análisis de linting
- `lib/main.dart` - Punto de entrada
- `lib/models/` - Modelos de datos
- `lib/services/` - Servicios
- `lib/screens/` - Pantallas
- `lib/widgets/` - Widgets reutilizables

---

¡Tu app está lista para despegar! 🚀📚
