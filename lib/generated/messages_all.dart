// DO NOT EDIT. This is code generated via package:gen_lang/generate.dart

import 'dart:async';

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';
// ignore: implementation_imports
import 'package:intl/src/intl_helpers.dart';

final _$en = $en();

class $en extends MessageLookupByLibrary {
  get localeName => 'en';
  
  final messages = {
		"APP_NAME" : MessageLookupByLibrary.simpleMessage("Covid-19 PH Tracker"),
		"LABEL_DEBUG" : MessageLookupByLibrary.simpleMessage(" - Debug1"),
		"LABEL_ACCOUNT_EMAIL" : MessageLookupByLibrary.simpleMessage("jayfrostgarcia@gmail.com"),
		"LABEL_ABOUT" : MessageLookupByLibrary.simpleMessage("About"),
		"LABEL_VERSION" : (version) => "Version ${version}",
		"LABEL_FLUTTER" : MessageLookupByLibrary.simpleMessage("Flutter"),
		"LABEL_DEVELOPED_USING" : MessageLookupByLibrary.simpleMessage("Developed using "),
		"LABEL_DATA_FROM" : MessageLookupByLibrary.simpleMessage(" Data from: "),
		"LABEL_RAPID_API" : MessageLookupByLibrary.simpleMessage("RapidAPI"),
		"LABEL_COPYRIGHTS" : MessageLookupByLibrary.simpleMessage("Copyright 2020. All rights reseved."),
		"URL_FLUTTER" : MessageLookupByLibrary.simpleMessage("https://flutter.dev"),
		"URL_RAPID_API" : MessageLookupByLibrary.simpleMessage("https://rapidapi.com/astsiatsko/api/coronavirus-monitor"),
		"LABEL_HEROKU_API" : MessageLookupByLibrary.simpleMessage("Coronavirus-PH"),
		"URL_HEROKU_API" : MessageLookupByLibrary.simpleMessage("https://coronavirus-ph-api.herokuapp.com/"),
		"LABEL_PULL_SERVER_DATA" : MessageLookupByLibrary.simpleMessage("Pulling Data from Server..."),
		"LABEL_ERROR_FETCHING_DATA" : (error) => "Error fetching data... [${error}]",
		"LABEL_TOTAL_CONFIRMED" : MessageLookupByLibrary.simpleMessage("Total Confirmed"),
		"LABEL_TOTAL_ACTIVE_CASES" : MessageLookupByLibrary.simpleMessage("Active Cases"),
		"LABEL_TOTAL_DEATHS" : MessageLookupByLibrary.simpleMessage("Total Deaths"),
		"LABEL_TOTAL_RECOVERED" : MessageLookupByLibrary.simpleMessage("Total Recovered"),
		"LABEL_RECORD_DATE" : MessageLookupByLibrary.simpleMessage("Date"),
		"LABEL_RECORD_DATE_VALUE" : (recordDate) => "Record Date: ${recordDate}",
		"LABEL_LOCATION" : (location) => "Location: ${location}",
		"LABEL_NEW_RECORD" : (count) => "+${count} new",
		"LABEL_LINKS_TRACKER" : MessageLookupByLibrary.simpleMessage("Tracker"),
		"LABEL_LINKS_PH_HISTORY" : MessageLookupByLibrary.simpleMessage("PH History"),
		"LABEL_LINKS_WORLD_STATS" : MessageLookupByLibrary.simpleMessage("World Statistics"),
		"LABEL_LINKS_CLOSE" : MessageLookupByLibrary.simpleMessage("Close"),
		"LABEL_NO_AVAILABLE_DATA" : MessageLookupByLibrary.simpleMessage("No available data to be displayed."),
		"LABEL_LOAD_MORE" : MessageLookupByLibrary.simpleMessage("Load More..."),
		"LABEL_CONFIRMED" : MessageLookupByLibrary.simpleMessage("Confirmed"),
		"LABEL_RECOVERED" : MessageLookupByLibrary.simpleMessage("Recovered"),
		"LABEL_DEATHS" : MessageLookupByLibrary.simpleMessage("Deaths"),
		"LABEL_ACTIVE_CASES" : MessageLookupByLibrary.simpleMessage("Active Cases"),
		"LABEL_RANK_TEMPLATE" : (rank, name) => "${rank}. ${name}",
		"LABEL_NEW_CASES" : MessageLookupByLibrary.simpleMessage("New Cases"),
		"LABEL_NEW_DEATHS" : MessageLookupByLibrary.simpleMessage("New Deaths"),
		"LABEL_COVID_HISTORY" : MessageLookupByLibrary.simpleMessage("Covid History"),
		"LABEL_COUNTRY_COVID_HISTORY" : (country) => "Statistics for Covid-19 (${country})",
		"LABEL_BUTTON_CONFIRMED" : MessageLookupByLibrary.simpleMessage("Confirmed"),
		"LABEL_BUTTON_RECOVERED" : MessageLookupByLibrary.simpleMessage("Recovered"),
		"LABEL_BUTTON_DEATHS" : MessageLookupByLibrary.simpleMessage("Deaths"),
		"LABEL_BUTTON_NEW_CASES" : MessageLookupByLibrary.simpleMessage("New Cases"),
		"LABEL_PH_PATIENT_LIST" : MessageLookupByLibrary.simpleMessage("PH Patient List"),
		"LABEL_COUNTRY" : MessageLookupByLibrary.simpleMessage("Country"),
		"DROPDOWN_ALL_REGIONS" : MessageLookupByLibrary.simpleMessage("All Regions"),
		"DROPDOWN_ALL_STATUS" : MessageLookupByLibrary.simpleMessage("All Status"),
		"LABEL_CASE_NUMER" : (number) => "PH ${number}",
		"LABEL_DATE_ADMITTED" : (date) => "Date Admitted: ${date}",
		"LABEL_HOSPITAL" : (s) => "Hospital: ${s}",
		"LABEL_AGE" : (s) => "Age: ${s}",
		"LABEL_NATIONALITY" : (s) => "Nationality: ${s}",
		"LABEL_STATUS" : (s) => "Status: ${s}",
		"LABEL_REGION_VALUE" : (s) => "Region: ${s}",
		"LABEL_TOTAL_PATIENTS" : MessageLookupByLibrary.simpleMessage("Total: "),

  };
}



typedef Future<dynamic> LibraryLoader();
Map<String, LibraryLoader> _deferredLibraries = {
	"en": () => Future.value(null),

};

MessageLookupByLibrary _findExact(localeName) {
  switch (localeName) {
    case "en":
        return _$en;

    default:
      return null;
  }
}

/// User programs should call this before using [localeName] for messages.
Future<bool> initializeMessages(String localeName) async {
  var availableLocale = Intl.verifiedLocale(
      localeName,
          (locale) => _deferredLibraries[locale] != null,
      onFailure: (_) => null);
  if (availableLocale == null) {
    return Future.value(false);
  }
  var lib = _deferredLibraries[availableLocale];
  await (lib == null ? Future.value(false) : lib());

  initializeInternalMessageLookup(() => CompositeMessageLookup());
  messageLookup.addLocale(availableLocale, _findGeneratedMessagesFor);

  return Future.value(true);
}

bool _messagesExistFor(String locale) {
  try {
    return _findExact(locale) != null;
  } catch (e) {
    return false;
  }
}

MessageLookupByLibrary _findGeneratedMessagesFor(locale) {
  var actualLocale = Intl.verifiedLocale(locale, _messagesExistFor,
      onFailure: (_) => null);
  if (actualLocale == null) return null;
  return _findExact(actualLocale);
}
