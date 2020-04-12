import 'package:phcovid19tracker/di/DependencyInjectors.dart';
import 'package:phcovid19tracker/repository/CovidRepository.dart';
import 'package:phcovid19tracker/ui/History/HistoryPageContract.dart';

class HistoryPresenter {
  HistoryPageContract _view;
  CovidRepository _repository;

  HistoryPresenter(this._view){
    _repository = DependencyInjectors().covidRepository;
  }

  void loadCountryHistory(String countryName) {
    assert(_view != null);
    
    _repository
      .fetchCountryHistory(countryName)
      .then((items) => _view.onLoadStatsComplete(items))
      .catchError((onError){
        _view.onLoadStatsError(onError.toString());
      });
  }
}