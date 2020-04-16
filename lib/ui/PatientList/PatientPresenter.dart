import 'package:location_permissions/location_permissions.dart';
import 'package:phcovid19tracker/data/DropdownValue.dart';
import 'package:phcovid19tracker/di/DependencyInjectors.dart';
import 'package:phcovid19tracker/repository/CovidRepository.dart';
import 'package:phcovid19tracker/ui/PatientList/PatientListContract.dart';

class PatientListPresenter implements LocationPermissions {
  PatientListContract _view;
  CovidRepository _repository;

  static const KEY_REGION = "region";
  static const KEY_STATUS = "status";
  static const KEY_KEYWORD = "keyword";
  static const KEY_DATE_ADMITTED = "date_admitted";
  static const KEY_HOSPITAL = "hospital";
  static const KEY_AGE = "age";
  static const KEY_NATIONALITY = "nationality";
  static const KEY_NAME = "name";

  PatientListPresenter(this._view){
    _repository = DependencyInjectors().covidRepository;
  }

  List<DropdownValue> _list = [];

  void loadPatientList(){
    assert(_view != null);
    
    _repository
      .fetchPatientsCases()
      .then((items){

        List<String> regions = [];
        List<String> status = [];

        (items).forEach((element) {
          if( !(regions.contains(element.region)) ){
            regions.add(element.region);
          }
          if( !(status.contains(element.status)) ){
            status.add(element.status);
          }
        });

        _view.onCompleteDropdownRegion(buildDropdownValues(items: regions, key: KEY_REGION));
        _view.onCompleteDropdownStatus(buildDropdownValues(items: status, key: KEY_STATUS));
        _view.onLoadStatsComplete(items);
      }).catchError((onError){
        _view.onLoadStatsError(onError.toString());
      });
  }

  List<DropdownValue> buildDropdownValues({List<String> items, String key}){
    List<DropdownValue> list = [];

    items.sort((a,b) {
      return (a.toLowerCase()).compareTo(b.toLowerCase());
    });
    items.asMap().forEach((index, value) {
      list.add(DropdownValue(key: value, index: index+1, label: value)); // 
    });
    return list;
  }

  void verifyLocationPermission() async {
    PermissionStatus permissionStatus = await checkPermissionStatus();
    print('verifyLocationPermission');
    print(verifyLocationPermission);
    print(permissionStatus);
    print(PermissionStatus.granted);
    if( PermissionStatus.granted != permissionStatus ){
      requestPermissions();
    }
  }
  
  @override
  Future<PermissionStatus> checkPermissionStatus({LocationPermissionLevel level = LocationPermissionLevel.location}) async {
    return await LocationPermissions().checkPermissionStatus();
  }

  @override
  Future<ServiceStatus> checkServiceStatus({LocationPermissionLevel level = LocationPermissionLevel.location}) async {
    return await LocationPermissions().checkServiceStatus();
  }

  @override
  Future<bool> openAppSettings() async {
    return await LocationPermissions().openAppSettings();
  }

  @override
  Future<PermissionStatus> requestPermissions({LocationPermissionLevel permissionLevel = LocationPermissionLevel.location}) async {
    return await LocationPermissions().requestPermissions();
  }

  @override
  // TODO: implement serviceStatus
  Stream<ServiceStatus> get serviceStatus => null;

  @override
  Future<bool> shouldShowRequestPermissionRationale({LocationPermissionLevel permissionLevel = LocationPermissionLevel.location}) async {
    return await LocationPermissions().shouldShowRequestPermissionRationale();
  }
}