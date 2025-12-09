import 'package:flutter/material.dart';
import '../models/book.dart';
import '../services/database_service.dart';

class DetailScreen extends StatefulWidget {
  final Book book;
  final VoidCallback? onSave;

  const DetailScreen({
    super.key,
    required this.book,
    this.onSave,
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late Book _currentBook;
  final DatabaseService _dbService = DatabaseService();

  bool _isFavorite = false;
  bool _isSaved = false;

  @override
  void initState() {
    super.initState();
    _currentBook = widget.book;
    _loadBookState();
  }

  Future<void> _loadBookState() async {
    final saved = await _dbService.getBookById(widget.book.id ?? '');

    if (!mounted) return;

    if (saved != null) {
      setState(() {
        _currentBook = saved;
        _isFavorite = saved.isFavorite;
        _isSaved = true;
      });
    } else {
      setState(() {
        _isFavorite = widget.book.isFavorite;
        _isSaved = false;
      });
    }
  }

  // ============================================================
  //                EDITAR NOTAS (UPDATE)
  // ============================================================
  Future<void> _editNotes() async {
    final controller =
        TextEditingController(text: _currentBook.userNotes ?? "");

    final newNotes = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Notas personales"),
          content: TextField(
            controller: controller,
            maxLines: 6,
            decoration: const InputDecoration(
              hintText: "Escribe tus notas aquí...",
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              child: const Text("Cancelar"),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              child: const Text("Guardar"),
              onPressed: () => Navigator.pop(context, controller.text),
            ),
          ],
        );
      },
    );

    if (newNotes != null) {
      final updated = _currentBook.copyWith(userNotes: newNotes);
      await _dbService.updateBook(updated);

      setState(() => _currentBook = updated);

      widget.onSave?.call();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Notas actualizadas")),
      );
    }
  }

  // ============================================================
  //                          UI
  // ============================================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
        title: const Text("Detalles del Libro"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // PORTADA + HERO
            Hero(
              tag: _currentBook.id ?? _currentBook.title,
              child: Container(
                width: double.infinity,
                height: 300,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.deepPurple.shade50,
                      Colors.blue.shade50,
                    ],
                  ),
                ),
                child: _currentBook.imageUrl != null
                    ? Image.network(
                        _currentBook.imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _buildImagePlaceholder(),
                      )
                    : _buildImagePlaceholder(),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // TÍTULO
                  Text(
                    _currentBook.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // AUTOR
                  Text(
                    _currentBook.author,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                      fontStyle: FontStyle.italic,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // RATING
                  if (_currentBook.rating != null)
                    _buildRatingBadge(),

                  const SizedBox(height: 20),

                  // OTHER INFO
                  _buildInfoCard(
                    icon: Icons.calendar_today,
                    label: "Fecha de publicación",
                    value: _currentBook.publishedDate ?? "No disponible",
                  ),
                  const SizedBox(height: 10),

                  if (_currentBook.pages != null)
                    _buildInfoCard(
                      icon: Icons.menu_book,
                      label: "Páginas",
                      value: _currentBook.pages.toString(),
                    ),

                  if (_currentBook.isbn != null) ...[
                    const SizedBox(height: 10),
                    _buildInfoCard(
                      icon: Icons.numbers,
                      label: "ISBN",
                      value: _currentBook.isbn!,
                    ),
                  ],

                  const SizedBox(height: 30),

                  // DESCRIPCIÓN
                  if (_currentBook.description != null) ...[
                    const Text(
                      "Descripción",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _sanitizeText(_currentBook.description!),
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                        height: 1.6,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                  ],

                  const SizedBox(height: 30),

                  // NOTAS
                  const Text(
                    "Notas personales",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _currentBook.userNotes?.isNotEmpty == true
                          ? _currentBook.userNotes!
                          : "No has agregado notas todavía.",
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),

                  const SizedBox(height: 12),

                  ElevatedButton.icon(
                    onPressed: _editNotes,
                    icon: const Icon(Icons.edit),
                    label: const Text("Agregar / editar notas"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // BOTONES CRUD
                  _buildActionButtons(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  //                     COMPONENTES UI
  // ============================================================

  Widget _buildRatingBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.amber[100],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star, color: Colors.amber, size: 20),
          const SizedBox(width: 4),
          Text(
            _currentBook.rating!.toStringAsFixed(1),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        // GUARDAR / ELIMINAR
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () async {
              if (_isSaved) {
                await _dbService.deleteBook(_currentBook.id!);
                setState(() => _isSaved = false);
                ScaffoldMessenger.of(context)
                    .showSnackBar(const SnackBar(content: Text("Libro eliminado")));
              } else {
                await _dbService.addBook(_currentBook);
                setState(() => _isSaved = true);
                widget.onSave?.call();
                ScaffoldMessenger.of(context)
                    .showSnackBar(const SnackBar(content: Text("Libro guardado")));
              }
            },
            icon: Icon(_isSaved ? Icons.delete : Icons.download),
            label: Text(_isSaved ? "Eliminar" : "Guardar"),
            style: ElevatedButton.styleFrom(
              backgroundColor: _isSaved ? Colors.red : Colors.green,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),

        const SizedBox(width: 12),

        // FAVORITO
        Expanded(
          child: ElevatedButton.icon(
            onPressed: !_isSaved
                ? () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Primero debes guardar el libro"),
                      ),
                    )
                : () async {
                    await _dbService.toggleFavorite(
                      _currentBook.id!,
                      !_isFavorite,
                    );

                    setState(() => _isFavorite = !_isFavorite);

                    widget.onSave?.call();

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(_isFavorite
                            ? "Agregado a favoritos"
                            : "Quitado de favoritos"),
                      ),
                    );
                  },
            icon: Icon(
              _isFavorite ? Icons.favorite : Icons.favorite_border,
            ),
            label: const Text("Favorito"),
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  _isFavorite ? Colors.red.shade600 : Colors.blue.shade600,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
        border: Border(
          left: BorderSide(
            color: Colors.deepPurple.shade400,
            width: 4,
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.deepPurple.shade400),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _sanitizeText(String text) {
    return text
        .replaceAll("<br>", "\n")
        .replaceAll("<b>", "")
        .replaceAll("</b>", "")
        .replaceAll("<p>", "")
        .replaceAll("</p>", "");
  }

  Widget _buildImagePlaceholder() {
    return Container(
      color: Colors.grey[300],
      child: Icon(
        Icons.library_books,
        size: 100,
        color: Colors.grey[600],
      ),
    );
  }
}
