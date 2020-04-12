# Covid-19 PH Tracker 

A new Flutter project using Dart Programming Language.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Features
- Tracker/Homepage - Shows the latest Covid-19 stats for Philippines 
- Country History - Shows Covid-19 stats per day given the selected country.
- World Stats - Shows Covid-19 latest stats of the all countries.

## Libraries Used
- [Progress Dialog](https://github.com/fayaz07/progress_dialog)
- [Font Awesome Icons](https://github.com/fluttercommunity/font_awesome_flutter)
- [Fluttertoast](https://github.com/PonnamKarthik/FlutterToast)
- [Awesome Loader](https://pub.dev/packages/awesome_loader)
- [Charts Flutter](https://github.com/google/charts) - for Charts 
- [gen_lang](https://github.com/KingWu/gen_lang) - for String Resources
- [MVP Architecture](https://github.com/fabiomsr/Flutter-StepByStep)


## Data 
Source: [RapidAPI - Coronavirus Monitor](https://rapidapi.com/astsiatsko/api/coronavirus-monitor)

 - Latest Stats by Country
 ```
{
	"country": "Philippines",
	"latest_stat_by_country": [{
		"id": "691369",
		"country_name": "Philippines",
		"total_cases": "4,428",
		"new_cases": "",
		"active_cases": "4,024",
		"total_deaths": "247",
		"new_deaths": "",
		"total_recovered": "157",
		"serious_critical": "1",
		"region": null,
		"total_cases_per1m": "40",
		"record_date": "2020-04-12 05:20:02.326"
	}]
}
 ```
 
  - History by Country
 ```
{
	"country": "Philippines",
	"stat_by_country": [{
		"id": "370",
		"country_name": "Philippines",
		"total_cases": "187",
		"new_cases": "45",
		"active_cases": "170",
		"total_deaths": "12",
		"new_deaths": "",
		"total_recovered": "5",
		"serious_critical": "1",
		"region": null,
		"total_cases_per1m": "1.7",
		"record_date": "2020-03-17 21:00:05.485"
	}, {
		"id": "535",
		"country_name": "Philippines",
		"total_cases": "187",
		"new_cases": "45",
		"active_cases": "170",
		"total_deaths": "12",
		"new_deaths": "",
		"total_recovered": "5",
		"serious_critical": "1",
		"region": null,
		"total_cases_per1m": "1.7",
		"record_date": "2020-03-17 21:10:02.648"
	}, {
    ...
  }]
}
 ```
 
  - World Stats
 ```
{
	"countries_stat": [{
		"country_name": "USA",
		"cases": "533,088",
		"deaths": "20,580",
		"region": "",
		"total_recovered": "30,502",
		"new_deaths": "3",
		"new_cases": "209",
		"serious_critical": "11,471",
		"active_cases": "482,006",
		"total_cases_per_1m_population": "1,611"
	}, {
		"country_name": "Spain",
		"cases": "163,027",
		"deaths": "16,606",
		"region": "",
		"total_recovered": "59,109",
		"new_deaths": "0",
		"new_cases": "0",
		"serious_critical": "7,371",
		"active_cases": "87,312",
		"total_cases_per_1m_population": "3,487"
	}, {
    ...
  }],
	"statistic_taken_at": "2020-04-12 05:28:05"
}
 ```

## Questions or Issues?
Feel free to contact me at jayfrostgarcia@gmail.com
