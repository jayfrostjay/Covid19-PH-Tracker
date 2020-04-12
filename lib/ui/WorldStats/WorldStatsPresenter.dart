
import 'package:phcovid19tracker/di/DependencyInjectors.dart';
import 'package:phcovid19tracker/repository/CovidRepository.dart';
import 'WorldStatsPageContract.dart';

class WorldStatsPresenter {
  WorldStatsPageContract _view;
  CovidRepository _repository;

  WorldStatsPresenter(this._view){
    _repository = DependencyInjectors().covidRepository;
  }

  void loadWorldStats() {
    assert(_view != null);
    
    _repository
      .fetchWorldLatestStats()
      .then((items) => _view.onLoadStatsComplete(items))
      .catchError((onError){
        _view.onLoadStatsError(onError.toString());
      });
  }
}