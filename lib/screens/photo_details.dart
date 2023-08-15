import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  @override
  Widget build(BuildContext context) {
    final safePadding = MediaQuery.of(context).padding.top;
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
        body: BlocConsumer<WallpapersBloc, WallpapersState>(
      bloc: _wallpapersBloc,
      listener: (context, state) {
        if (state is WallpaperDownloadedState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Wallpaper downloaded successfully!'),
              duration: Duration(seconds: 2),
            ),
          );
        }
        if (state is WallpaperAppliedSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Wallpaper applied successfully!'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      },
      listenWhen: (previous, current) => current is WallpapersActionState,
      buildWhen: (previous, current) => current is! WallpapersActionState,
      builder: (context, state) {
        return Stack(children: [
          Image.network(
            widget.photo.src!.large2x!,
            fit: BoxFit.cover,
            height: height,
            width: width,
          ),
          Positioned(
            top: safePadding + 4,
            left: 4,
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
              width: width * 0.95,
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
                      _wallpapersBloc.add(AsyncWallpaperEvent(
                        url: widget.photo.src!.portrait!,
                      ));
                    },
                    child:
                        Text("Set Wallpaper", style: TextStyle(fontSize: 14)),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(170, 48),
                      backgroundColor: Colors.black,
                    ),
                    onPressed: () {
                      _wallpapersBloc.add(WallpaperDownloadedEvent(
                        url: widget.photo.src!.portrait!,
                      ));
                    },
                    child: Text("Download", style: TextStyle(fontSize: 14)),
                  ),
                ],
              ),
            ),
          )
        ]);
      },
    ));
  }
}
