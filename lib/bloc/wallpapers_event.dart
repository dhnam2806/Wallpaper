part of 'wallpapers_bloc.dart';

@immutable
abstract class WallpapersEvent {}

class FetchWallpapers extends WallpapersEvent {}

class SearchWallpapers extends WallpapersEvent {
  final String query;

  SearchWallpapers(this.query);
}

class WallpaperClickedEvent extends WallpapersEvent {
  final Photos photo;

  WallpaperClickedEvent({required this.photo});
}

class WallpaperAppliedEvent extends WallpapersEvent {
  final String url;

  WallpaperAppliedEvent({required this.url});
}

class WallpaperDownloadedEvent extends WallpapersEvent {
  final String url;

  WallpaperDownloadedEvent({required this.url});
}

class AsyncWallpaperEvent extends WallpapersEvent {
  final String url;

  AsyncWallpaperEvent({required this.url});
}
