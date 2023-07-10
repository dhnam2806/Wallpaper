
part of 'wallpapers_bloc.dart';

@immutable
abstract class WallpapersState {}

abstract class WallpapersActionState extends WallpapersState {}

class WallpapersInitial extends WallpapersState {}

class WallpapersLoading extends WallpapersState {}

class WallpapersLoaded extends WallpapersState {
  final List<Photos> wallpapers;

  WallpapersLoaded({required this.wallpapers});
}

class WallpapersError extends WallpapersState {
  final String message;

  WallpapersError({required this.message});
}

class WallpaperLoadedMoreButtonClickedState extends WallpapersState {
  final List<Photos> wallpapers;

  WallpaperLoadedMoreButtonClickedState({required this.wallpapers});
}

class WallpaperAppliedSuccess extends WallpapersState {}

class WallpaperAppliedError extends WallpapersState {}

class WallpaperClickedState extends WallpapersActionState {
  final Photos photo;
  WallpaperClickedState({
    required this.photo,
  });
}

class WallpaperAppliedState extends WallpapersActionState {
  final String url;
  WallpaperAppliedState({
    required this.url,
  });
}
