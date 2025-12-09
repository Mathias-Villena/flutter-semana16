import 'package:flutter/material.dart';
import '../models/book.dart';

class BookCard extends StatefulWidget {
  final Book book;
  final VoidCallback onTap;
  final VoidCallback onFavoriteTap;
  final bool isFavorite;

  const BookCard({
    super.key,
    required this.book,
    required this.onTap,
    required this.onFavoriteTap,
    this.isFavorite = false,
  });

  @override
  State<BookCard> createState() => _BookCardState();
}

class _BookCardState extends State<BookCard> {
  double _scale = 1.0;
  bool _favBlocked = false;

  void _onTapDown(TapDownDetails details) {
    setState(() => _scale = 0.97);
  }

  void _onTapCancel() {
    setState(() => _scale = 1.0);
  }

  void _onTapUp(TapUpDetails details) {
    setState(() => _scale = 1.0);
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: _scale,
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeOut,
      child: Material(
        elevation: 4,
        borderRadius: BorderRadius.circular(18),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTapDown: _onTapDown,
          onTapCancel: _onTapCancel,
          onTapUp: _onTapUp,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primaryContainer,
                  Theme.of(context).colorScheme.surface,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Imagen + Hero animation
                Expanded(
                  child: Hero(
                    tag: widget.book.id ?? widget.book.title,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(18),
                      ),
                      child: widget.book.imageUrl != null
                          ? Image.network(
                              widget.book.imageUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => _buildPlaceholder(),
                            )
                          : _buildPlaceholder(),
                    ),
                  ),
                ),

                // Información del libro
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // TÍTULO
                      Text(
                        widget.book.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 4),

                      // AUTOR
                      Text(
                        widget.book.author,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[700],
                          fontStyle: FontStyle.italic,
                        ),
                      ),

                      const SizedBox(height: 6),

                      // Si tiene notas: iconito
                      if (widget.book.userNotes != null &&
                          widget.book.userNotes!.trim().isNotEmpty)
                        Row(
                          children: const [
                            Icon(Icons.notes_rounded,
                                size: 14, color: Colors.deepPurple),
                            SizedBox(width: 4),
                            Text(
                              'Tiene notas',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.deepPurple,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),

                      const SizedBox(height: 8),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // RATING
                          widget.book.rating != null
                              ? Row(
                                  children: [
                                    const Icon(Icons.star_rounded,
                                        size: 16, color: Colors.amber),
                                    const SizedBox(width: 2),
                                    Text(
                                      widget.book.rating!.toStringAsFixed(1),
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                )
                              : Text(
                                  'Sin rating',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey[500],
                                  ),
                                ),

                          // FAVORITO
                          InkWell(
                            borderRadius: BorderRadius.circular(50),
                            onTap: () {
                              if (_favBlocked) return;
                              _favBlocked = true;

                              widget.onFavoriteTap();

                              Future.delayed(const Duration(milliseconds: 300),
                                  () => _favBlocked = false);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(3),
                              child: Icon(
                                widget.isFavorite
                                    ? Icons.favorite_rounded
                                    : Icons.favorite_border_rounded,
                                color: widget.isFavorite
                                    ? Colors.redAccent
                                    : Colors.grey[500],
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: Colors.grey[300],
      child: Icon(
        Icons.library_books_rounded,
        size: 60,
        color: Colors.grey[700],
      ),
    );
  }
}
