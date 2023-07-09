part of 'wallpapers_bloc.dart';

@immutable
abstract class WallpapersEvent {}

class FetchWallpapers extends WallpapersEvent {

}

class SearchWallpapers extends WallpapersEvent {
  final String query;

  SearchWallpapers(this.query);
}
