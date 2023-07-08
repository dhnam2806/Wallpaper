import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:wallpappers/models/photo_model.dart';

import '../repositories/wallpapers_repo.dart';

part 'wallpapers_event.dart';
part 'wallpapers_state.dart';

class WallpapersBloc extends Bloc<WallpapersEvent, WallpapersState> {
  WallpapersBloc() : super(WallpapersInitial()) {
      on<FetchWallpapers>((event, emit) async {
        emit(WallpapersLoading());
        try {
          List<Photos> wallpapers = await WallpaperRepository().getWallpapers();
          emit(WallpapersLoaded(wallpapers: wallpapers));
        } catch (e) {
          emit(WallpapersError(message: e.toString()));
        }
      });
  }
}
