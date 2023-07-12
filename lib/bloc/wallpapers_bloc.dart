import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_wallpaper_manager/flutter_wallpaper_manager.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:meta/meta.dart';
import '../models/photo_model.dart';
import '../repositories/wallpapers_repo.dart';
part 'wallpapers_event.dart';
part 'wallpapers_state.dart';

class WallpapersBloc extends Bloc<WallpapersEvent, WallpapersState> {
  WallpapersBloc() : super(WallpapersInitial()) {
    on<FetchWallpapers>(fetchWallpapers);
    on<SearchWallpapers>(searchWallpapers);
    on<WallpaperClickedEvent>(wallpaperClickedEvent);
    on<AsyncWallpaperEvent>(asyncWallpaperEvent);
    on<WallpaperDownloadedEvent>(wallpaperDownloadedEvent);
  }

  FutureOr<void> fetchWallpapers(
      FetchWallpapers event, Emitter<WallpapersState> emit) async {
    emit(WallpapersLoading());
    try {
      List<Photos> wallpapers = await WallpaperRepository().getWallpapers();
      emit(WallpapersLoaded(wallpapers: wallpapers));
    } catch (e) {
      emit(WallpapersError(message: e.toString()));
    }
  }

  FutureOr<void> searchWallpapers(
      SearchWallpapers event, Emitter<WallpapersState> emit) async {
    emit(WallpapersLoading());
    try {
      if(event.query.isEmpty){
        List<Photos> wallpapers = await WallpaperRepository().getWallpapers();
        emit(WallpapersLoaded(wallpapers: wallpapers));
      } else {
        List<Photos> wallpapers =
        await WallpaperRepository().searchWallpapers(event.query);
        emit(WallpapersLoaded(wallpapers: wallpapers));
      }
    } catch (e) {
      emit(WallpapersError(message: e.toString()));
    }
  }

  FutureOr<void> wallpaperClickedEvent(
      WallpaperClickedEvent event, Emitter<WallpapersState> emit) {
    emit(WallpaperClickedState(photo: event.photo));
  }


  FutureOr<void> asyncWallpaperEvent(
      AsyncWallpaperEvent event, Emitter<WallpapersState> emit) async {
    String url = event.url;
    int location = WallpaperManager.HOME_SCREEN;
    final file = await DefaultCacheManager().getSingleFile(url);

    try {
      final bool result =
          await WallpaperManager.setWallpaperFromFile(file.path, location);
      print(result);
    } catch (e) {
      print(e);
    }
    emit(WallpaperAppliedSuccess());
  }

  FutureOr<void> wallpaperDownloadedEvent(
      WallpaperDownloadedEvent event, Emitter<WallpapersState> emit) {
    String path = event.url;
    GallerySaver.saveImage(path);
    emit(WallpaperDownloadedState());
  }
}
