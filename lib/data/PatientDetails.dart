class PatientDetails {
  String caseNo;
  String date;
  String age;
  String gender;
  String nationality;
  String hospitalAdmitted;
  String hasTravelHistory;
  String status;
  String region;
  String locationLatitude;
  String locationLongitude;
  String healthStatus;

  PatientDetails({this.caseNo, this.date, this.age, this.gender, this.nationality, this.hospitalAdmitted, this.hasTravelHistory, this.status, this.region, this.locationLatitude, this.locationLongitude, this.healthStatus});

  PatientDetails.fromMap(Map<String, dynamic> map) :
    caseNo = map["case_no"].toString(),
    date = map["date_of_announcement_to_public"].toString(),
    age = map["age"].toString(),
    gender = map["sex"].toString(),
    nationality = map["nationality"].toString(),
    hospitalAdmitted = map["hospital_admitted_to"].toString(),
    hasTravelHistory = map["travel_history"].toString(),
    status = map["status"].toString(),
    region = map["location"] .toString(),
    locationLatitude = map["latitude"].toString(),
    locationLongitude = map["longitude"].toString(),
    healthStatus = map["health_status"].toString();
}