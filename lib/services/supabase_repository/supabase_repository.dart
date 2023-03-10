
import 'local_data_source.dart';
import 'remote_data_source.dart';

abstract class SupabaseRepository {
  Future<List<String>> getTutteLeImmaginiComePath();
  Future<int> getPuntiLac();
}

class SupabaseRepositoryImpl extends SupabaseRepository {
  final LocalDataSource localDataSource;
  final RemoteDataSource remoteDataSource;

  SupabaseRepositoryImpl(this.localDataSource, this.remoteDataSource);

  @override
  Future<int> getPuntiLac() {
    return remoteDataSource.getPuntiLac();
  }

  @override
  Future<List<String>> getTutteLeImmaginiComePath() {
    return remoteDataSource.getTutteLeImmaginiComePath();
  }
}
