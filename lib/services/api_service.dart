import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/book.dart';

class ApiService {
  static const String _baseUrl = 'https://www.googleapis.com/books/v1/volumes';
  static const String _apiKey = 'AIzaSyB8h8oe7JhgGlI32kzoGmciZypcz3wRMLY'; 
  // Buscar libros por título / query general
  static Future<List<Book>> searchBooks(String query) async {
    try {
      if (query.trim().isEmpty) return [];

      // Codificamos el query para evitar errores con espacios/símbolos
      final encodedQuery = Uri.encodeQueryComponent(query.trim());

      final uri = Uri.parse(
        '$_baseUrl?q=$encodedQuery&maxResults=40&key=$_apiKey',
      );

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final jsonBody = jsonDecode(response.body);
        final items = jsonBody['items'] ?? [];

        return (items as List<dynamic>)
            .map((item) => Book.fromJson(item))
            .toList();
      } else {
        throw Exception('Error al buscar libros: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error en búsqueda de API: $e');
    }
  }

  // Buscar por autor
  static Future<List<Book>> searchByAuthor(String author) async {
    return searchBooks('inauthor:$author');
  }

  // Buscar por editorial
  static Future<List<Book>> searchByPublisher(String publisher) async {
    return searchBooks('inpublisher:$publisher');
  }

  // Buscar por ISBN
  static Future<List<Book>> searchByIsbn(String isbn) async {
    return searchBooks('isbn:$isbn');
  }

  // Obtener detalles por ID de libro
  static Future<Book?> getBookDetails(String bookId) async {
    try {
      final uri = Uri.parse('$_baseUrl/$bookId?key=$_apiKey');
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final jsonBody = jsonDecode(response.body);
        return Book.fromJson(jsonBody);
      }
      return null;
    } catch (e) {
      throw Exception('Error al obtener detalles: $e');
    }
  }
}
