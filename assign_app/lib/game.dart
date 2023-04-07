class Game {
  final String title;
  final String thumbnailUrl;
  final String genre;
  final String platform;
  // ignore: non_constant_identifier_names
  final String release_date;

  Game({
    required this.title,
    required this.thumbnailUrl,
    required this.genre,
    required this.platform,
    // ignore: non_constant_identifier_names
    required this.release_date,
  });

  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
      title: json['title'],
      thumbnailUrl: json['thumbnail'],
      genre: json['genre'],
      platform: json['platform'],
      release_date: json['release_date'],
    );
  }
}
