class NewsDto {
  String title, description, imageUrl, date, content, url, author;
  int id;

  NewsDto(this.title, this.description, this.imageUrl, this.date, this.content,
      this.url, this.author)
      : id = (title + date).hashCode;

  @override
  bool operator ==(Object other) {
    return other is NewsDto &&
        other.date == date &&
        other.title == title &&
        other.id == id &&
        other.url == url &&
        other.imageUrl == imageUrl &&
        other.description == description &&
        other.content == content &&
        other.author == author;
  }

  factory NewsDto.fromJson(Map<String, dynamic> json) {
    return NewsDto(
      json['title'] ?? 'No title',
      json['description'] ?? 'No description',
      json['urlToImage'] ?? 'NoImage',
      json['publishedAt'] ?? '',
      json['content'] ?? 'No content',
      json['url'] ?? '',
      json['author'] ?? 'Author unknown',
    );
  }

  @override
  int get hashCode => id;
}
