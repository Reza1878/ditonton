import 'package:dicoding_ditonton/common/state_enum.dart';
import 'package:dicoding_ditonton/presentation/provider/top_rated_tv_series_notifier.dart';
import 'package:dicoding_ditonton/presentation/widgets/tv_series_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TopRatedTVSeriesPage extends StatefulWidget {
  static const ROUTE_NAME = '/tv-series/top-rated';

  @override
  _TopRatedTVSeriesPageState createState() => _TopRatedTVSeriesPageState();
}

class _TopRatedTVSeriesPageState extends State<TopRatedTVSeriesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<TopRatedTVSeriesNotifier>(context, listen: false)
            .fetchTopRatedTVSeries());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Top Rated (TV Series)'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<TopRatedTVSeriesNotifier>(
          builder: (context, data, child) {
            if (data.state == RequestState.Loading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (data.state == RequestState.Loaded) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final tvSeries = data.tvSeries[index];
                  return TVSeriesCard(tvSeries);
                },
                itemCount: data.tvSeries.length,
              );
            } else {
              return Center(
                key: Key('error_message'),
                child: Text(data.message),
              );
            }
          },
        ),
      ),
    );
  }
}
