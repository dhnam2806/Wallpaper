import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wallpappers/bloc/wallpapers_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final WallpapersBloc _wallpapersBloc = WallpapersBloc();
  TextEditingController _controller = TextEditingController();
  @override
  void initState() {
    _wallpapersBloc.add(FetchWallpapers());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WallpapersBloc, WallpapersState>(
      bloc: _wallpapersBloc,
      listener: (context, state) {},
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
            final successState = state as WallpapersLoaded;
            return Scaffold(
                body: SafeArea(
              child: Column(
                children: [
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
                    margin:
                        EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
                    decoration: BoxDecoration(
                        color: Colors.grey[800],
                        borderRadius: BorderRadius.circular(12.0)),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 12.0),
                      child: TextField(
                        controller: _controller,
                        onSubmitted: (value) => print(value),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Search',
                          suffixIcon: ElevatedButton(
                            onPressed: () {
                              print(_controller.text);
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
                  Expanded(
                      child: MasonryGridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 4,
                    crossAxisSpacing: 4,
                    itemBuilder: (context, index) {
                      return Container(
                        height: 100,
                        color: Colors.red,
                      );
                    },
                  ))
                ],
              ),
            ));

          default:
            return Container();
        }
      },
    );
  }
}
