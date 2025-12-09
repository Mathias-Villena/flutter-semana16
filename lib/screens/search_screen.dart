import 'dart:async';
import 'package:flutter/material.dart';
import '../models/book.dart';
import '../services/api_service.dart';
import '../services/database_service.dart';
import '../widgets/book_card.dart';
import 'detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final DatabaseService _dbService = DatabaseService();
  final TextEditingController _searchController = TextEditingController();

  List<Book> _searchResults = [];
  List<Book> _savedBooks = [];

  bool _isLoading = false;
  String? _errorMessage;

  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _loadSavedBooks();
  }

  Future<void> _loadSavedBooks() async {
    final books = await _dbService.getAllBooks();
    if (!mounted) return;
    setState(() => _savedBooks = books);
  }

  bool _isFavorite(Book book) {
  try {
    final saved = _savedBooks.firstWhere((b) => b.id == book.id);
    return saved.isFavorite;
  } catch (_) {
    return false;
  }
}


  bool _isSaved(String? id) {
    return _savedBooks.any((b) => b.id == id);
  }

  void _onSearchChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 450), () {
      _performSearch(value);
    });
  }

  Future<void> _performSearch(String query) async {
    if (query.trim().isEmpty) {
      setState(() {
        _searchResults = [];
        _errorMessage = null;
        _isLoading = false;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final results = await ApiService.searchBooks(query);

      // filtrar libros sin ID (Google Books a veces manda items dañados)
      final cleanResults = results.where((b) => b.id != null).toList();

      if (!mounted) return;

      setState(() {
        _searchResults = cleanResults;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = "Error en la búsqueda: $e";
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Buscar Libros"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              colors.primaryContainer.withOpacity(0.8),
              colors.background,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildSearchBar(),
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: _buildSearchContent(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  //                       SEARCH BAR
  // ============================================================
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Material(
            elevation: 3,
            borderRadius: BorderRadius.circular(24),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: "Título, autor, ISBN...",
                prefixIcon: const Icon(Icons.search_rounded),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _searchResults = [];
                            _errorMessage = null;
                          });
                        },
                      )
                    : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          _buildChipRow(),
        ],
      ),
    );
  }

  Widget _buildChipRow() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildQuickChip("Harry Potter"),
          _buildQuickChip("Flutter"),
          _buildQuickChip("Manga"),
          _buildQuickChip("Programación"),
          _buildQuickChip("Ciencia ficción"),
        ],
      ),
    );
  }

  Widget _buildQuickChip(String label) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ActionChip(
        avatar: const Icon(Icons.local_library, size: 16),
        label: Text(label),
        onPressed: () {
          _searchController.text = label;
          _onSearchChanged(label);
          setState(() {});
        },
      ),
    );
  }

  // ============================================================
  //                    CONTENIDO PRINCIPAL
  // ============================================================
  Widget _buildSearchContent() {
    if (_errorMessage != null) {
      return Center(
        key: const ValueKey("error"),
        child: Text(_errorMessage!, textAlign: TextAlign.center),
      );
    }

    if (_isLoading) {
      return const Center(
        key: ValueKey("loading"),
        child: CircularProgressIndicator(),
      );
    }

    if (_searchResults.isEmpty) {
      return _buildEmptyState();
    }

    return _buildResultsList();
  }

  Widget _buildEmptyState() {
    return Center(
      key: const ValueKey("empty"),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.menu_book_rounded, size: 70, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            _searchController.text.isEmpty
                ? "Empieza buscando tu próximo libro"
                : "No se encontraron resultados",
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildResultsList() {
    return Padding(
      key: const ValueKey("results"),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              "Resultados: ${_searchResults.length}",
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),

          // GRID DE LIBROS
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.66,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: _searchResults.length,
            itemBuilder: (context, i) {
              final book = _searchResults[i];

              return BookCard(
                book: book,
                isFavorite: _isFavorite(book),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DetailScreen(
                        book: book,
                        onSave: () => _loadSavedBooks(),
                      ),
                    ),
                  ).then((_) => _loadSavedBooks());
                },
                onFavoriteTap: () async {
                  final saved = _isSaved(book.id);

                  if (saved) {
                    await _dbService.deleteBook(book.id!);
                  } else {
                    await _dbService.addBook(book);
                  }

                  await _loadSavedBooks();

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(saved
                          ? "Libro eliminado"
                          : "Libro guardado en tu biblioteca"),
                      duration: const Duration(seconds: 1),
                    ),
                  );

                  setState(() {});
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
