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
  final String? userNotes;

  Book({
    this.id,
    required this.title,
    required this.author,
    this.description,
    this.imageUrl,
    this.publishedDate,
    this.pages,
    this.rating,
    this.isbn,
    this.isFavorite = false,
    this.addedDate,
    this.userNotes,
  });

  /// Desde API de Google Books
  factory Book.fromJson(Map<String, dynamic> json) {
    final info = json['volumeInfo'] ?? {};
    final identifiers = info['industryIdentifiers'] as List<dynamic>?;

    String? isbnValue;
    if (identifiers != null && identifiers.isNotEmpty) {
      try {
        final isbn13 = identifiers.firstWhere(
          (e) => e['type'] == 'ISBN_13',
          orElse: () => identifiers.first,
        );
        isbnValue = isbn13['identifier'];
      } catch (_) {
        isbnValue = null;
      }
    }

    return Book(
      id: json['id'],
      title: info['title'] ?? 'Sin título',
      author: (info['authors'] as List?)?.join(', ') ?? 'Autor desconocido',
      description: info['description'],
      imageUrl: info['imageLinks']?['thumbnail'],
      publishedDate: info['publishedDate'],
      pages: info['pageCount'],
      rating: (info['averageRating'] as num?)?.toDouble(),
      isbn: isbnValue,
    );
  }

  /// Para guardar en SQLite
  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'author': author,
        'description': description,
        'imageUrl': imageUrl,
        'publishedDate': publishedDate,
        'pages': pages,
        'rating': rating,
        'isbn': isbn,
        'isFavorite': isFavorite ? 1 : 0,
        'addedDate': addedDate?.toIso8601String(),
        'userNotes': userNotes,
      };

  /// Desde SQLite
  factory Book.fromDatabase(Map<String, dynamic> json) {
    return Book(
      id: json['id'],
      title: json['title'],
      author: json['author'],
      description: json['description'],
      imageUrl: json['imageUrl'],
      publishedDate: json['publishedDate'],
      pages: json['pages'],
      rating: json['rating'],
      isbn: json['isbn'],
      isFavorite: json['isFavorite'] == 1,
      addedDate:
          json['addedDate'] != null ? DateTime.parse(json['addedDate']) : null,
      userNotes: json['userNotes'],
    );
  }

  Book copyWith({
    String? id,
    String? title,
    String? author,
    String? description,
    String? imageUrl,
    String? publishedDate,
    int? pages,
    double? rating,
    String? isbn,
    bool? isFavorite,
    DateTime? addedDate,
    String? userNotes,
  }) {
    return Book(
      id: id ?? this.id,
      title: title ?? this.title,
      author: author ?? this.author,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      publishedDate: publishedDate ?? this.publishedDate,
      pages: pages ?? this.pages,
      rating: rating ?? this.rating,
      isbn: isbn ?? this.isbn,
      isFavorite: isFavorite ?? this.isFavorite,
      addedDate: addedDate ?? this.addedDate,
      userNotes: userNotes ?? this.userNotes,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Book && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
