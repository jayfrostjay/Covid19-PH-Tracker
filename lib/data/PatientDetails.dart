import 'package:phcovid19tracker/utils/StringUtil.dart';

class PatientDetails {
  int caseNo;
  String date;
  String age;
  String gender;
  String nationality;
  String hospitalAdmitted;
  bool hasTravelHistory;
  String status;
  String region;
  String locationLatitude;
  String locationLongitude;

  PatientDetails({this.caseNo, this.date, this.age, this.gender, this.nationality, this.hospitalAdmitted, this.hasTravelHistory, this.status, this.region, this.locationLatitude, this.locationLongitude});

  PatientDetails.fromMap(Map<String, dynamic> map) :
    caseNo = map["case_no"],
    date = map["date"],
    age = map["age"].toString(),
    gender = map["gender"],
    nationality = map["nationality"],
    hospitalAdmitted = map["hospital_admitted_to"],
    hasTravelHistory = (((map["travel_history"] as String).trim().toLowerCase()) == 'yes'),
    status = map["status"],
    region = map["resident_of"],
    locationLatitude = map["latitude"].toString(),
    locationLongitude = map["longitude"].toString();
}