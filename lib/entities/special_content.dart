enum SpecialContentType { localMovie, networkMovie, webLink, playlist }

class SpecialContent {
  const SpecialContent(
      {this.title, this.contentURL, this.thumbnailURL, this.contentType});

  final String title;
  final String contentURL;
  final String thumbnailURL;
  final SpecialContentType contentType;
}
