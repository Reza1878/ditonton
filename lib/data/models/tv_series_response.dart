import 'package:dicoding_ditonton/data/models/tv_series_model.dart';
import 'package:equatable/equatable.dart';

class TVSeriesResponse extends Equatable {
  final List<TVSeriesModel> seriesList;

  TVSeriesResponse({required this.seriesList});

  factory TVSeriesResponse.fromJson(Map<String, dynamic> json) =>
      TVSeriesResponse(
        seriesList: List<TVSeriesModel>.from((json["results"] as List).map(
          (x) => TVSeriesModel.fromJson(x),
        )).toList(),
      );

  @override
  List<Object> get props => [seriesList];
}
