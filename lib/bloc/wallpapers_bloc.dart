import 'dart:async';

import 'package:bloc/bloc.dart';
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
      List<Photos> wallpapers =
          await WallpaperRepository().searchWallpapers(event.query);
      emit(WallpapersLoaded(wallpapers: wallpapers));
    } catch (e) {
      emit(WallpapersError(message: e.toString()));
    }
  }

  FutureOr<void> wallpaperClickedEvent(
      WallpaperClickedEvent event, Emitter<WallpapersState> emit) {
    emit(WallpaperClickedState(photo: event.photo));
  }

  FutureOr<void> wallpaperDownloadedEvent(
      WallpaperDownloadedEvent event, Emitter<WallpapersState> emit) async {
    try {
      // await WallpaperRepository().downloadImage(event.url);
      emit(WallpaperAppliedSuccess());
    } catch (e) {
      emit(WallpaperAppliedError());
    }
  }
}
