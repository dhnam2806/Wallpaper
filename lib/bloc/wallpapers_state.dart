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

class WallpaperAppliedSuccess extends WallpapersActionState {
}


class WallpaperClickedState extends WallpapersActionState {
  final Photos photo;
  WallpaperClickedState({
    required this.photo,
  });
}

class WallpaperDownloadedState extends WallpapersActionState {

}


