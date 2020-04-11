import 'package:phcovid19tracker/repository/CovidRepository.dart';

class DependencyInjectors {
  static final DependencyInjectors _singleton = DependencyInjectors._internal();

  factory DependencyInjectors(){
    return _singleton;
  }

  DependencyInjectors._internal();

  CovidRepository get covidRepository{
    return CovidRepository();
  }
}