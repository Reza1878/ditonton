import 'package:dicoding_ditonton/common/constants.dart';
import 'package:dicoding_ditonton/presentation/pages/now_playing_tv_series_page.dart';
import 'package:dicoding_ditonton/presentation/pages/popular_movies_page.dart';
import 'package:dicoding_ditonton/presentation/pages/popular_tv_series_page.dart';
import 'package:dicoding_ditonton/presentation/pages/search_page.dart';
import 'package:dicoding_ditonton/presentation/pages/search_tv_series_page.dart';
import 'package:dicoding_ditonton/presentation/pages/top_rated_movies_page.dart';
import 'package:dicoding_ditonton/presentation/pages/top_rated_tv_series_page.dart';
import 'package:dicoding_ditonton/presentation/provider/movie_list_notifier.dart';
import 'package:dicoding_ditonton/common/state_enum.dart';
import 'package:dicoding_ditonton/presentation/provider/tv_series_list_notifier.dart';
import 'package:dicoding_ditonton/presentation/widgets/movie_list.dart';
import 'package:dicoding_ditonton/presentation/widgets/my_drawer.dart';
import 'package:dicoding_ditonton/presentation/widgets/tv_series_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeMoviePage extends StatefulWidget {
  @override
  _HomeMoviePageState createState() => _HomeMoviePageState();
}

class _HomeMoviePageState extends State<HomeMoviePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<MovieListNotifier>(context, listen: false)
        ..fetchNowPlayingMovies()
        ..fetchPopularMovies()
        ..fetchTopRatedMovies();

      Provider.of<TVSeriesListNotifier>(context, listen: false)
        ..fetchNowPlaying()
        ..fetchPopular()
        ..fetchTopRated();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(activeRoute: 'Movies'),
      appBar: AppBar(
        title: Text('Ditonton'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, SearchPage.ROUTE_NAME);
            },
            icon: Icon(Icons.search),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Now Playing',
                style: kHeading6,
              ),
              Consumer<MovieListNotifier>(builder: (context, data, child) {
                final state = data.nowPlayingState;
                if (state == RequestState.Loading) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state == RequestState.Loaded) {
                  return MovieList(data.nowPlayingMovies);
                } else {
                  return Text('Failed');
                }
              }),
              _buildSubHeading(
                title: 'Popular',
                onTap: () =>
                    Navigator.pushNamed(context, PopularMoviesPage.ROUTE_NAME),
              ),
              Consumer<MovieListNotifier>(builder: (context, data, child) {
                final state = data.popularMoviesState;
                if (state == RequestState.Loading) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state == RequestState.Loaded) {
                  return MovieList(data.popularMovies);
                } else {
                  return Text('Failed');
                }
              }),
              _buildSubHeading(
                title: 'Top Rated',
                onTap: () =>
                    Navigator.pushNamed(context, TopRatedMoviesPage.ROUTE_NAME),
              ),
              Consumer<MovieListNotifier>(builder: (context, data, child) {
                final state = data.topRatedMoviesState;
                if (state == RequestState.Loading) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state == RequestState.Loaded) {
                  return MovieList(data.topRatedMovies);
                } else {
                  return Text('Failed');
                }
              }),
              SizedBox(
                height: 48,
              ),
              _buildSubHeading(
                title: 'Now Playing (TV Series)',
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    NowPlayingTVSeriesPage.ROUTE_NAME,
                  );
                },
              ),
              Consumer<TVSeriesListNotifier>(builder: (context, data, child) {
                final state = data.nowPlayingState;
                if (state == RequestState.Loading) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state == RequestState.Loaded) {
                  return TVSeriesList(data.nowPlaying);
                } else {
                  return Text('Failed');
                }
              }),
              _buildSubHeading(
                title: 'Popular (TV Series)',
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    PopularTVSeriesPage.ROUTE_NAME,
                  );
                },
              ),
              Consumer<TVSeriesListNotifier>(builder: (context, data, child) {
                final state = data.popularState;
                if (state == RequestState.Loading) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state == RequestState.Loaded) {
                  return TVSeriesList(data.popular);
                } else {
                  return Text('Failed');
                }
              }),
              _buildSubHeading(
                title: 'Top Rated (TV Series)',
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    TopRatedTVSeriesPage.ROUTE_NAME,
                  );
                },
              ),
              Consumer<TVSeriesListNotifier>(builder: (context, data, child) {
                final state = data.topRatedState;
                if (state == RequestState.Loading) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state == RequestState.Loaded) {
                  return TVSeriesList(data.topRated);
                } else {
                  return Text('Failed');
                }
              }),
              SizedBox(
                height: 24,
              ),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, SearchTVSeriesPage.ROUTE_NAME);
                  },
                  child: Text('Search TV Series'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Row _buildSubHeading({required String title, required Function() onTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: kHeading6,
        ),
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [Text('See More'), Icon(Icons.arrow_forward_ios)],
            ),
          ),
        ),
      ],
    );
  }
}
