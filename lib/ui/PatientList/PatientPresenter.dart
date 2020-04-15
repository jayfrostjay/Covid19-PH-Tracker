import 'package:geolocator/geolocator.dart';
import 'package:location_permissions/location_permissions.dart';
import 'package:phcovid19tracker/di/DependencyInjectors.dart';
import 'package:phcovid19tracker/repository/CovidRepository.dart';
import 'package:phcovid19tracker/ui/PatientList/PatientListContract.dart';

class PatientListPresenter implements LocationPermissions {
  PatientListContract _view;
  CovidRepository _repository;

  PatientListPresenter(this._view){
    _repository = DependencyInjectors().covidRepository;
  }

  void loadPatientList(){
    assert(_view != null);

    _repository
      .fetchPatientsCases()
      .then((items){
        // _view.onLoadStatsComplete(items);
      }).catchError((onError){
        // _view.onLoadStatsError(onError.toString());
      });
  }

  void verifyLocationPermission() async {
    PermissionStatus permissionStatus = await checkPermissionStatus();
    print(verifyLocationPermission);
    print(permissionStatus);
    print(PermissionStatus.granted);
    if( PermissionStatus.granted == permissionStatus ){
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