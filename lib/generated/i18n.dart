// DO NOT EDIT. This is code generated via package:gen_lang/generate.dart

import 'dart:async';

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

import 'messages_all.dart';

class S {
 
  static const GeneratedLocalizationsDelegate delegate = GeneratedLocalizationsDelegate();

  static S of(BuildContext context) {
    return Localizations.of<S>(context, S);
  }
  
  static Future<S> load(Locale locale) {
    final String name = locale.countryCode == null ? locale.languageCode : locale.toString();

    final String localeName = Intl.canonicalizedLocale(name);

    return initializeMessages(localeName).then((bool _) {
      Intl.defaultLocale = localeName;
      return new S();
    });
  }
  
  String get APP_NAME {
    return Intl.message("Covid-19 PH Tracker", name: 'APP_NAME');
  }

  String get LABEL_DEBUG {
    return Intl.message(" - Debug1", name: 'LABEL_DEBUG');
  }

  String get LABEL_ACCOUNT_EMAIL {
    return Intl.message("jayfrostgarcia@gmail.com", name: 'LABEL_ACCOUNT_EMAIL');
  }

  String get LABEL_ABOUT {
    return Intl.message("About", name: 'LABEL_ABOUT');
  }

  String LABEL_VERSION(version) {
    return Intl.message("Version ${version}", name: 'LABEL_VERSION', args: [version]);
  }

  String get LABEL_FLUTTER {
    return Intl.message("Flutter", name: 'LABEL_FLUTTER');
  }

  String get LABEL_DEVELOPED_USING {
    return Intl.message("Developed using ", name: 'LABEL_DEVELOPED_USING');
  }

  String get LABEL_DATA_FROM {
    return Intl.message(" Data from: ", name: 'LABEL_DATA_FROM');
  }

  String get LABEL_RAPID_API {
    return Intl.message("RapidAPI", name: 'LABEL_RAPID_API');
  }

  String get LABEL_COPYRIGHTS {
    return Intl.message("Copyright 2020. All rights reseved.", name: 'LABEL_COPYRIGHTS');
  }

  String get URL_FLUTTER {
    return Intl.message("https://flutter.dev", name: 'URL_FLUTTER');
  }

  String get URL_RAPID_API {
    return Intl.message("https://rapidapi.com/astsiatsko/api/coronavirus-monitor", name: 'URL_RAPID_API');
  }

  String get LABEL_HEROKU_API {
    return Intl.message("Coronavirus-PH", name: 'LABEL_HEROKU_API');
  }

  String get URL_HEROKU_API {
    return Intl.message("https://coronavirus-ph-api.herokuapp.com/", name: 'URL_HEROKU_API');
  }

  String get LABEL_PULL_SERVER_DATA {
    return Intl.message("Pulling Data from Server...", name: 'LABEL_PULL_SERVER_DATA');
  }

  String LABEL_ERROR_FETCHING_DATA(error) {
    return Intl.message("Error fetching data... [${error}]", name: 'LABEL_ERROR_FETCHING_DATA', args: [error]);
  }

  String get LABEL_TOTAL_CONFIRMED {
    return Intl.message("Total Confirmed", name: 'LABEL_TOTAL_CONFIRMED');
  }

  String get LABEL_TOTAL_ACTIVE_CASES {
    return Intl.message("Active Cases", name: 'LABEL_TOTAL_ACTIVE_CASES');
  }

  String get LABEL_TOTAL_DEATHS {
    return Intl.message("Total Deaths", name: 'LABEL_TOTAL_DEATHS');
  }

  String get LABEL_TOTAL_RECOVERED {
    return Intl.message("Total Recovered", name: 'LABEL_TOTAL_RECOVERED');
  }

  String get LABEL_RECORD_DATE {
    return Intl.message("Date", name: 'LABEL_RECORD_DATE');
  }

  String LABEL_RECORD_DATE_VALUE(recordDate) {
    return Intl.message("Record Date: ${recordDate}", name: 'LABEL_RECORD_DATE_VALUE', args: [recordDate]);
  }

  String LABEL_LOCATION(location) {
    return Intl.message("Location: ${location}", name: 'LABEL_LOCATION', args: [location]);
  }

  String LABEL_NEW_RECORD(count) {
    return Intl.message("+${count} new", name: 'LABEL_NEW_RECORD', args: [count]);
  }

  String get LABEL_LINKS_TRACKER {
    return Intl.message("Tracker", name: 'LABEL_LINKS_TRACKER');
  }

  String get LABEL_LINKS_PH_HISTORY {
    return Intl.message("PH History", name: 'LABEL_LINKS_PH_HISTORY');
  }

  String get LABEL_LINKS_WORLD_STATS {
    return Intl.message("World Statistics", name: 'LABEL_LINKS_WORLD_STATS');
  }

  String get LABEL_LINKS_CLOSE {
    return Intl.message("Close", name: 'LABEL_LINKS_CLOSE');
  }

  String get LABEL_NO_AVAILABLE_DATA {
    return Intl.message("No available data to be displayed.", name: 'LABEL_NO_AVAILABLE_DATA');
  }

  String get LABEL_LOAD_MORE {
    return Intl.message("Load More...", name: 'LABEL_LOAD_MORE');
  }

  String get LABEL_CONFIRMED {
    return Intl.message("Confirmed", name: 'LABEL_CONFIRMED');
  }

  String get LABEL_RECOVERED {
    return Intl.message("Recovered", name: 'LABEL_RECOVERED');
  }

  String get LABEL_DEATHS {
    return Intl.message("Deaths", name: 'LABEL_DEATHS');
  }

  String get LABEL_ACTIVE_CASES {
    return Intl.message("Active Cases", name: 'LABEL_ACTIVE_CASES');
  }

  String LABEL_RANK_TEMPLATE(rank, name) {
    return Intl.message("${rank}. ${name}", name: 'LABEL_RANK_TEMPLATE', args: [rank, name]);
  }

  String get LABEL_NEW_CASES {
    return Intl.message("New Cases", name: 'LABEL_NEW_CASES');
  }

  String get LABEL_NEW_DEATHS {
    return Intl.message("New Deaths", name: 'LABEL_NEW_DEATHS');
  }

  String get LABEL_COVID_HISTORY {
    return Intl.message("Covid History", name: 'LABEL_COVID_HISTORY');
  }

  String LABEL_COUNTRY_COVID_HISTORY(country) {
    return Intl.message("Statistics for Covid-19 (${country})", name: 'LABEL_COUNTRY_COVID_HISTORY', args: [country]);
  }

  String get LABEL_BUTTON_CONFIRMED {
    return Intl.message("Confirmed", name: 'LABEL_BUTTON_CONFIRMED');
  }

  String get LABEL_BUTTON_RECOVERED {
    return Intl.message("Recovered", name: 'LABEL_BUTTON_RECOVERED');
  }

  String get LABEL_BUTTON_DEATHS {
    return Intl.message("Deaths", name: 'LABEL_BUTTON_DEATHS');
  }

  String get LABEL_BUTTON_NEW_CASES {
    return Intl.message("New Cases", name: 'LABEL_BUTTON_NEW_CASES');
  }

  String get LABEL_PH_PATIENT_LIST {
    return Intl.message("PH Patient List", name: 'LABEL_PH_PATIENT_LIST');
  }

  String get LABEL_COUNTRY {
    return Intl.message("Country", name: 'LABEL_COUNTRY');
  }

  String get DROPDOWN_ALL_REGIONS {
    return Intl.message("All Regions", name: 'DROPDOWN_ALL_REGIONS');
  }

  String get DROPDOWN_ALL_STATUS {
    return Intl.message("All Status", name: 'DROPDOWN_ALL_STATUS');
  }

  String LABEL_CASE_NUMER(number) {
    return Intl.message("PH ${number}", name: 'LABEL_CASE_NUMER', args: [number]);
  }

  String LABEL_DATE_ADMITTED(date) {
    return Intl.message("Date Admitted: ${date}", name: 'LABEL_DATE_ADMITTED', args: [date]);
  }

  String LABEL_HOSPITAL(s) {
    return Intl.message("Hospital: ${s}", name: 'LABEL_HOSPITAL', args: [s]);
  }

  String LABEL_AGE(s) {
    return Intl.message("Age: ${s}", name: 'LABEL_AGE', args: [s]);
  }

  String LABEL_NATIONALITY(s) {
    return Intl.message("Nationality: ${s}", name: 'LABEL_NATIONALITY', args: [s]);
  }

  String LABEL_STATUS(s) {
    return Intl.message("Status: ${s}", name: 'LABEL_STATUS', args: [s]);
  }

  String LABEL_REGION_VALUE(s) {
    return Intl.message("Region: ${s}", name: 'LABEL_REGION_VALUE', args: [s]);
  }

  String get LABEL_TOTAL_PATIENTS {
    return Intl.message("Total: ", name: 'LABEL_TOTAL_PATIENTS');
  }


}

class GeneratedLocalizationsDelegate extends LocalizationsDelegate<S> {
  const GeneratedLocalizationsDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
			Locale("en", ""),

    ];
  }

  LocaleListResolutionCallback listResolution({Locale fallback}) {
    return (List<Locale> locales, Iterable<Locale> supported) {
      if (locales == null || locales.isEmpty) {
        return fallback ?? supported.first;
      } else {
        return _resolve(locales.first, fallback, supported);
      }
    };
  }

  LocaleResolutionCallback resolution({Locale fallback}) {
    return (Locale locale, Iterable<Locale> supported) {
      return _resolve(locale, fallback, supported);
    };
  }

  Locale _resolve(Locale locale, Locale fallback, Iterable<Locale> supported) {
    if (locale == null || !isSupported(locale)) {
      return fallback ?? supported.first;
    }

    final Locale languageLocale = Locale(locale.languageCode, "");
    if (supported.contains(locale)) {
      return locale;
    } else if (supported.contains(languageLocale)) {
      return languageLocale;
    } else {
      final Locale fallbackLocale = fallback ?? supported.first;
      return fallbackLocale;
    }
  }

  @override
  Future<S> load(Locale locale) {
    return S.load(locale);
  }

  @override
  bool isSupported(Locale locale) =>
    locale != null && supportedLocales.contains(locale);

  @override
  bool shouldReload(GeneratedLocalizationsDelegate old) => false;
}
