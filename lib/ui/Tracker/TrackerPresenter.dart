import 'package:phcovid19tracker/repository/CovidRepository.dart';
import '../../di/DependencyInjectors.dart';
import 'TrackerPageContract.dart';

class TrackerPresenter {
  TrackerPageContract _view;
  CovidRepository _repository;

  TrackerPresenter(this._view){
    _repository = DependencyInjectors().covidRepository;
  }

  void loadCountryStats(String countryName) {
    assert(_view != null);
    
    _repository
      .fetchCountryLatestStats(countryName)
      .then((items) => _view.onLoadStatsComplete(items))
      .catchError((onError){
        _view.onLoadStatsError(onError.toString());
      });
  }
}