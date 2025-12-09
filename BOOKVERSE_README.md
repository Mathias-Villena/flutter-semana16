# 📚 BookVerse - Gestor de Libros Inteligente

Una aplicación Flutter moderna y bien diseñada para gestionar tu biblioteca personal. Combina la potencia de la API de Google Books con almacenamiento local en SQLite.

## ✨ Características

- **🔍 Búsqueda Inteligente**: Busca millones de libros desde la API de Google Books
- **📱 Interfaz Moderna**: Diseño Material 3 con gradientes y animaciones fluidas
- **💾 Almacenamiento Local**: SQLite para guardar libros sin necesidad de internet
- **❤️ Sistema de Favoritos**: Marca tus libros favoritos
- **📊 Información Completa**: Accede a portadas, ratings, ISBN, páginas y más
- **🎨 Tema Personalizado**: Colores vibrantes con púrpura y azul
- **📚 Biblioteca Personal**: Gestiona tu colección de libros

## 🏗️ Estructura del Proyecto

```
lib/
├── main.dart                 # Punto de entrada
├── models/
│   └── book.dart            # Modelo de datos de libros
├── services/
│   ├── api_service.dart     # Consumo de Google Books API
│   └── database_service.dart # Operaciones SQLite
├── screens/
│   ├── home_screen.dart     # Pantalla principal
│   ├── search_screen.dart   # Búsqueda de libros
│   └── detail_screen.dart   # Detalles del libro
└── widgets/
    └── book_card.dart       # Widget de tarjeta de libro
```

## 🚀 Funcionalidades Principales

### 1. **Página Principal**
- Ver todos los libros guardados
- Pestaña de favoritos
- Contador de libros totales
- Navegación con Bottom Navigation Bar

### 2. **Búsqueda**
- Buscar libros por título
- Buscar por autor
- Buscar por editorial
- Buscar por ISBN
- Resultados en tiempo real

### 3. **Detalle del Libro**
- Ver portada grande
- Información completa (título, autor, descripción)
- Rating y número de páginas
- ISBN y fecha de publicación
- Botón guardar/eliminar
- Marcar como favorito

### 4. **Gestión de Base de Datos**
- Guardar libros localmente
- Marcar favoritos
- Eliminar libros
- Búsqueda en la biblioteca personal

## 📦 Dependencias

```yaml
http: ^1.2.0              # Para consumir la API REST
sqflite: ^2.3.0           # Base de datos SQLite
path_provider: ^2.1.0     # Acceso a rutas del sistema
intl: ^0.20.0             # Formato de fechas e internacionalización
```

## 🔧 Instalación

1. **Clonar el repositorio** (si aplica)
```bash
git clone <tu-repo>
cd app_final
```

2. **Instalar dependencias**
```bash
flutter pub get
```

3. **Ejecutar la app**
```bash
flutter run
```

## 🌐 API Utilizada

### Google Books API
- **Endpoint**: `https://www.googleapis.com/books/v1/volumes`
- **API Key**: Incluida en el proyecto (Pública)
- **Rate Limit**: 100 requests por minuto

**Tipos de búsqueda soportados:**
- `q=<query>` - Búsqueda general
- `inauthor:<author>` - Por autor
- `inpublisher:<publisher>` - Por editorial
- `isbn:<isbn>` - Por ISBN

## 💾 Base de Datos SQLite

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

## 🎯 Casos de Uso

1. **Descubrimiento de Libros**: Busca libros nuevos y agrega los que te interesen
2. **Biblioteca Personal**: Mantén un registro de todos tus libros
3. **Lista de Lectura**: Marca favoritos para leer más tarde
4. **Consulta Rápida**: Accede a información completa de libros sin conexión

## 🛠️ Servicios Disponibles

### ApiService
```dart
// Búsqueda general
await ApiService.searchBooks("Flutter");

// Búsqueda por autor
await ApiService.searchByAuthor("J.K. Rowling");

// Búsqueda por editorial
await ApiService.searchByPublisher("Penguin");

// Búsqueda por ISBN
await ApiService.searchByIsbn("978-0-06-112008-4");

// Detalles específicos
await ApiService.getBookDetails("bookId");
```

### DatabaseService
```dart
final db = DatabaseService();

// CRUD Operations
await db.addBook(book);                    // Crear
final books = await db.getAllBooks();      // Leer todo
final favorites = await db.getFavoriteBooks(); // Leer favoritos
await db.updateBook(book);                 // Actualizar
await db.deleteBook(id);                   // Eliminar

// Búsquedas
await db.searchBooksByTitle("Flutter");
await db.searchBooksByAuthor("Rowling");
```

## 🎨 Diseño UI/UX

- **Colores principales**: Púrpura (#7C3AED) y Azul (#3B82F6)
- **Tipografía**: Material Design 3
- **Componentes**: Cards, Bottom Navigation, FAB, GridView
- **Animaciones**: Transiciones suaves entre pantallas

## 📱 Requisitos Mínimos

- Flutter: 3.9.2 o superior
- Dart: 3.9.2 o superior
- Android: 5.0+
- iOS: 11.0+

## 🚧 Mejoras Futuras

- [ ] Síncrona con cuenta en la nube
- [ ] Reseñas personales en libros
- [ ] Múltiples listas de lectura
- [ ] Estadísticas de lectura
- [ ] Modo oscuro
- [ ] Integración con redes sociales
- [ ] Recomendaciones basadas en IA
- [ ] Escaneo de códigos QR/ISBN

## 📝 Licencia

Este proyecto es de código abierto y está disponible bajo la licencia MIT.

## 👨‍💻 Autor

Desarrollado con ❤️ usando Flutter

---

**¡Feliz lectura!** 📚✨
