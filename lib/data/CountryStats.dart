class CountryStats {
  String countryName;
  String confirmed;
  String deaths;
  String recovered;
  String activeCases;
  String newCases;
  String newDeaths;

  CountryStats({this.countryName, this.confirmed, this.deaths, this.recovered, this.activeCases, this.newCases, this.newDeaths});

  CountryStats.fromMap(Map<String, dynamic> map) :
    countryName = map["country_name"],
    confirmed = map["cases"],
    deaths = map["deaths"],
    recovered = map["total_recovered"],
    activeCases = map["active_cases"],
    newCases = map["new_cases"],
    newDeaths = map["new_deaths"];

  CountryStats copyWith({countryName, confirmed, deaths, recovered, activeCases, recordDate, newCases, newDeaths}){
    return CountryStats(
      confirmed: confirmed ?? this.confirmed,
      deaths: deaths ?? this.confirmed,
      recovered: recovered ?? this.recovered,
      activeCases: activeCases ?? this.activeCases,
      countryName: recordDate ?? this.countryName,
      newDeaths: newDeaths ?? this.newDeaths,
      newCases: newCases ?? this.newCases
    );
  }
}