import 'package:flutter/material.dart';
import '../models/book.dart';
import '../services/database_service.dart';
import '../widgets/book_card.dart';
import 'search_screen.dart';
import 'detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DatabaseService _dbService = DatabaseService();

  int _selectedTab = 0; // 0 = biblioteca, 1 = favoritos

  late Future<List<Book>> _booksFuture;
  late Future<List<Book>> _favoritesFuture;

  @override
  void initState() {
    super.initState();
    _loadBooks();
  }

  /// Recarga las listas desde la base de datos
  void _loadBooks() {
    _booksFuture = _dbService.getAllBooks();
    _favoritesFuture = _dbService.getFavoriteBooks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),

      body: _selectedTab == 0
          ? _buildAllBooksTab()
          : _buildFavoritesTab(),

      floatingActionButton: _buildSearchButton(),

      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  // ---------------------------------------------------------
  //  APPBAR
  // ---------------------------------------------------------
  AppBar _buildAppBar() {
    return AppBar(
      elevation: 0,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.deepPurple.shade700,
              Colors.blue.shade500,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
      title: const Text(
        '📚 BookVerse',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.info_outline),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('BookVerse v1.0 - Tu gestor de libros favoritos'),
                duration: Duration(seconds: 2),
              ),
            );
          },
        ),
      ],
    );
  }

  // ---------------------------------------------------------
  //  BOTÓN BUSCAR (SearchScreen)
  // ---------------------------------------------------------
  Widget _buildSearchButton() {
    return FloatingActionButton.extended(
      onPressed: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (_) => const SearchScreen()))
            .then((_) {
          setState(() => _loadBooks());
        });
      },
      backgroundColor: Colors.deepPurple.shade700,
      icon: const Icon(Icons.search),
      label: const Text('Buscar Libros'),
    );
  }

  // ---------------------------------------------------------
  //  BOTTOM NAVIGATION
  // ---------------------------------------------------------
  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _selectedTab,
      onTap: (index) {
        setState(() {
          _selectedTab = index;
          _loadBooks(); // recarga ambas listas al cambiar pestaña
        });
      },
      items: [
        BottomNavigationBarItem(
          icon: const Icon(Icons.library_books),
          label: 'Biblioteca',
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.favorite),
          label: 'Favoritos',
        ),
      ],
    );
  }

  // ---------------------------------------------------------
  //  TAB 1 → BIBLIOTECA
  // ---------------------------------------------------------
  Widget _buildAllBooksTab() {
    return FutureBuilder<List<Book>>(
      future: _booksFuture,
      builder: (context, snapshot) {
        // Loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // Error
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final books = snapshot.data ?? [];

        // Sin libros
        if (books.isEmpty) {
          return _buildEmptyState(
            icon: Icons.library_books,
            title: 'No hay libros guardados',
            message: 'Toca el botón flotante para buscar libros',
          );
        }

        // Mostrar lista
        return ListView(
          padding: const EdgeInsets.all(12),
          children: [
            Text(
              'Total: ${books.length} libros',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 12),

            _buildBooksGrid(books),
          ],
        );
      },
    );
  }

  // ---------------------------------------------------------
  //  TAB 2 → FAVORITOS
  // ---------------------------------------------------------
  Widget _buildFavoritesTab() {
    return FutureBuilder<List<Book>>(
      future: _favoritesFuture,
      builder: (context, snapshot) {
        // Loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // Error
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final books = snapshot.data ?? [];

        // Sin favoritos
        if (books.isEmpty) {
          return _buildEmptyState(
            icon: Icons.favorite_border,
            title: 'No hay favoritos',
            message: 'Marca libros como favoritos',
          );
        }

        // Mostrar favoritos
        return ListView(
          padding: const EdgeInsets.all(12),
          children: [
            Text(
              'Favoritos: ${books.length}',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            _buildBooksGrid(books),
          ],
        );
      },
    );
  }

  // ---------------------------------------------------------
  //  GRID DE LIBROS
  // ---------------------------------------------------------
  Widget _buildBooksGrid(List<Book> books) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.65,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: books.length,
      itemBuilder: (context, index) {
        final book = books[index];

        return BookCard(
          book: book,
          isFavorite: book.isFavorite,
          onTap: () {
            Navigator.of(context)
                .push(MaterialPageRoute(
                  builder: (_) => DetailScreen(book: book),
                ))
                .then((_) {
              setState(() => _loadBooks());
            });
          },
          onFavoriteTap: () async {
            await _dbService.toggleFavorite(book.id!, !book.isFavorite);
            setState(() => _loadBooks());
          },
        );
      },
    );
  }

  // ---------------------------------------------------------
  //  WIDGET PARA ESTADOS VACÍOS
  // ---------------------------------------------------------
  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String message,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(title, style: TextStyle(fontSize: 18, color: Colors.grey[700])),
          const SizedBox(height: 8),
          Text(message, style: TextStyle(fontSize: 14, color: Colors.grey[500])),
        ],
      ),
    );
  }
}
