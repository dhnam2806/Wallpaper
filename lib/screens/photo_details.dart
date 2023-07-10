import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_wallpaper_manager/flutter_wallpaper_manager.dart';

import '../bloc/wallpapers_bloc.dart';
import '../models/photo_model.dart';

class PhotoDetails extends StatefulWidget {
  final Photos photo;
  const PhotoDetails({
    required this.photo,
  });

  @override
  State<PhotoDetails> createState() => _PhotoDetailsState();
}

class _PhotoDetailsState extends State<PhotoDetails> {
  final WallpapersBloc _wallpapersBloc = WallpapersBloc();

  Future<void> setWallpaper() async {
    int location = WallpaperManager.HOME_SCREEN;
    final file = await DefaultCacheManager().getSingleFile(widget.photo.src!.large2x!);

    try {
      final bool result =
          await WallpaperManager.setWallpaperFromFile(file.path, location);
      print(result);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
      BlocBuilder<WallpapersBloc, WallpapersState>(
        bloc: _wallpapersBloc,
        builder: (context, state) {
          return Image.network(
            widget.photo.src!.large2x!,
            fit: BoxFit.cover,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
          );
        },
      ),
      Positioned(
        top: 60,
        left: 8,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            minimumSize: Size(44, 44),
            backgroundColor: Colors.black.withOpacity(0.5),
            shape: CircleBorder(),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.close,
            size: 32,
          ),
        ),
      ),
      Align(
        alignment: Alignment.bottomCenter - Alignment(0, 0.1),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.95,
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.6),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(170, 48),
                  backgroundColor: Colors.black,
                ),
                onPressed: () {
                  setWallpaper();
                },
                child: Text("Set Wallpaper", style: TextStyle(fontSize: 16)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(170, 48),
                  backgroundColor: Colors.black,
                ),
                onPressed: () async {
                },
                child:
                    Text("Download Wallpaper", style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      )
    ]));
  }
}
