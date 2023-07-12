import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import '../bloc/wallpapers_bloc.dart';
import '../models/photo_model.dart';
import 'photo_details.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final WallpapersBloc _wallpapersBloc = WallpapersBloc();
  TextEditingController _controller = TextEditingController();
  int page = 1;

  @override
  void initState() {
    _wallpapersBloc.add(FetchWallpapers());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Column(
        children: [
          SizedBox(
            height: 16,
          ),
          Center(
            child: Text(
              "Wallpapers",
              style: GoogleFonts.lobster(
                fontSize: 48,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
            decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(12.0)),
            child: Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: TextField(
                controller: _controller,
                onSubmitted: (value) {
                  _wallpapersBloc.add(SearchWallpapers(_controller.text));
                },
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Search',
                  suffixIcon: ElevatedButton(
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      _wallpapersBloc.add(SearchWallpapers(_controller.text));
                    },
                    child: Icon(Icons.search),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(12.0),
                          bottomRight: Radius.circular(12.0),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          BlocConsumer<WallpapersBloc, WallpapersState>(
            bloc: _wallpapersBloc,
            listener: (context, state) {
              if (state is WallpaperClickedState) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            PhotoDetails(photo: state.photo)));
              }
            },
            listenWhen: (previous, current) => current is WallpapersActionState,
            buildWhen: (previous, current) => current is! WallpapersActionState,
            builder: (context, state) {
              switch (state.runtimeType) {
                case WallpapersLoading:
                  return Center(
                    child: CircularProgressIndicator(),
                  );

                case WallpapersError:
                  return Center(
                    child: Text(
                      (state as WallpapersError).message,
                      style: TextStyle(color: Colors.red),
                    ),
                  );

                case WallpapersLoaded:
                  final List<Photos> wallpapers =
                      (state as WallpapersLoaded).wallpapers;
                  return Expanded(
                      child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    child: MasonryGridView.count(
                      itemCount: wallpapers.length,
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            _wallpapersBloc.add(WallpaperClickedEvent(
                                photo: wallpapers[index]));
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12.0),
                            child: Image.network(
                              wallpapers[index].src!.portrait!,
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    ),
                  ));
                default:
                  return Container();
              }
            },
          )
        ],
      ),
    ));
  }
}
