import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dicoding_ditonton/common/exception.dart';
import 'package:dicoding_ditonton/common/failure.dart';
import 'package:dicoding_ditonton/data/datasources/tv_series_local_data_source.dart';
import 'package:dicoding_ditonton/data/datasources/tv_series_remote_data_source.dart';
import 'package:dicoding_ditonton/data/models/tv_series_table.dart';
import 'package:dicoding_ditonton/domain/entities/tv_series.dart';
import 'package:dicoding_ditonton/domain/entities/tv_series_detail.dart';
import 'package:dicoding_ditonton/domain/repositories/tv_series_repository.dart';

class TVSeriesRepositoryImpl extends TVSeriesRepository {
  final TVSeriesRemoteDataSource remoteDataSource;
  final TVSeriesLocalDataSource localDataSource;

  TVSeriesRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<TVSeries>>> getNowPlayingTVSeries() async {
    try {
      final result = await remoteDataSource.getNowPlayingTVSeries();
      return Right(result.map((e) => e.toEntity()).toList());
    } on ServerException {
      return Left(ServerFailure(''));
    } on SocketException {
      return Left(
        ConnectionFailure('Failed to connect to the network'),
      );
    }
  }

  @override
  Future<Either<Failure, List<TVSeries>>> getPopularTVSeries() async {
    try {
      final result = await remoteDataSource.getPopularTVSeries();
      return Right(result.map((e) => e.toEntity()).toList());
    } on ServerException {
      return Left(ServerFailure(''));
    } on SocketException {
      return Left(
        ConnectionFailure('Failed to connect to the network'),
      );
    }
  }

  @override
  Future<Either<Failure, List<TVSeries>>> getTVSeriesRecommendations(
    int id,
  ) async {
    try {
      final result = await remoteDataSource.getTVSeriesRecommendations(id);
      return Right(result
          .map((e) => e.toEntity())
          .where((element) => element.posterPath != null)
          .toList());
    } on ServerException {
      return Left(ServerFailure(''));
    } on SocketException {
      return Left(
        ConnectionFailure('Failed to connect to the network'),
      );
    }
  }

  @override
  Future<Either<Failure, List<TVSeries>>> getTopRatedTVSeries() async {
    try {
      final result = await remoteDataSource.getTopRatedTVSeries();
      return Right(result.map((e) => e.toEntity()).toList());
    } on ServerException {
      return Left(ServerFailure(''));
    } on SocketException {
      return Left(
        ConnectionFailure('Failed to connect to the network'),
      );
    }
  }

  @override
  Future<Either<Failure, TVSeriesDetail>> getTVSeriesDetail(int id) async {
    try {
      final result = await remoteDataSource.getTVSeriesDetail(id);
      return Right(result.toEntity());
    } on ServerException {
      return Left(ServerFailure(''));
    } on SocketException {
      return Left(
        ConnectionFailure('Failed to connect to the network'),
      );
    }
  }

  @override
  Future<Either<Failure, List<TVSeries>>> getWatchlistTVSeries() async {
    final result = await localDataSource.getWatchlistTVSeries();
    return Right(result.map((r) => r.toEntity()).toList());
  }

  @override
  Future<bool> isAddedToWatchlist(int id) async {
    final result = await localDataSource.getTVSeriesById(id);
    return result != null;
  }

  @override
  Future<Either<Failure, String>> removeWatchlist(
    TVSeriesDetail tvSeriesDetail,
  ) async {
    try {
      final result = await localDataSource.removeWatchlist(
        TVSeriesTable.fromEntity(tvSeriesDetail),
      );
      return Right(result);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, String>> saveWatchlist(
      TVSeriesDetail tvSeriesDetail) async {
    try {
      final result = await localDataSource.insertWatchlist(
        TVSeriesTable.fromEntity(tvSeriesDetail),
      );
      return Right(result);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      throw e;
    }
  }

  @override
  Future<Either<Failure, List<TVSeries>>> searchTVSeries(String query) async {
    try {
      final result = await remoteDataSource.searchTVSeries(query);
      return Right(result.map((e) => e.toEntity()).toList());
    } on ServerException {
      return Left(ServerFailure(''));
    } on SocketException {
      return Left(
        ConnectionFailure('Failed to connect to the network'),
      );
    }
  }
}
