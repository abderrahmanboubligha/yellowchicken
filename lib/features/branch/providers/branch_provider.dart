import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/models/config_model.dart';
import 'package:flutter_restaurant/common/providers/data_sync_provider.dart';
import 'package:flutter_restaurant/features/address/providers/location_provider.dart';
import 'package:flutter_restaurant/features/splash/domain/reposotories/splash_repo.dart';
import 'package:flutter_restaurant/main.dart';
import 'package:flutter_restaurant/features/splash/providers/splash_provider.dart';
import 'package:flutter_restaurant/features/home/screens/home_screen.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class BranchProvider extends DataSyncProvider {
  final SplashRepo? splashRepo;

  BranchProvider({required this.splashRepo});

  int? _selectedBranchId;

  int? get selectedBranchId => _selectedBranchId;
  bool _isLoading = false;

  bool get isLoading => _isLoading;
  int _branchTabIndex = 0;

  int get branchTabIndex => _branchTabIndex;
  bool _showSearchBox = false;

  bool get showSearchBox => _showSearchBox;

  List<BranchValue>? _branchValueList;

  List<BranchValue>? get branchValueList => _branchValueList;

  void updateSearchBox(bool status) {
    _showSearchBox = status;
    notifyListeners();
  }

  void updateTabIndex(int index, {bool isUpdate = true}) {
    _branchTabIndex = index;
    if (isUpdate) {
      notifyListeners();
    }
  }

  void updateBranchId(int? value, {bool isUpdate = true}) {
    _selectedBranchId = value;
    if (isUpdate) {
      notifyListeners();
    }
  }

  int getBranchId() => splashRepo?.getBranchId() ?? -1;

  Future<void> setBranch(int id, SplashProvider splashProvider) async {
    await splashRepo!.setBranchId(id);
    await splashProvider.getDeliveryInfo(id);
    await HomeScreen.loadData(true);
    notifyListeners();
  }

  Branches? getBranch({int? id}) {
    int branchId = id ?? getBranchId();
    Branches? branch;
    try {
      ConfigModel config =
          Provider.of<SplashProvider>(Get.context!, listen: false).configModel!;
      if (config.branches != null && config.branches!.isNotEmpty) {
        branch = config.branches!
            .firstWhere((branch) => branch!.id == branchId, orElse: () => null);
        if (branch == null && branchId != -1) {
          splashRepo!.setBranchId(-1);
        }
      }
    } catch (e) {
      // Handle any errors gracefully
      if (branchId != -1) {
        splashRepo?.setBranchId(-1);
      }
    }
    return branch;
  }

  List<BranchValue> branchSort(LatLng? currentLatLng) {
    _isLoading = true;
    List<BranchValue> branchValueList = [];

    for (var branch in Provider.of<SplashProvider>(Get.context!, listen: false)
        .configModel!
        .branches!) {
      double distance = -1;
      if (currentLatLng != null) {
        distance = Geolocator.distanceBetween(
              branch!.latitude!,
              branch.longitude!,
              currentLatLng.latitude,
              currentLatLng.longitude,
            ) /
            1000;
      }

      branchValueList.add(BranchValue(branch, distance));
    }
    branchValueList.sort((a, b) => a.distance.compareTo(b.distance));

    _isLoading = false;

    notifyListeners();

    return branchValueList;
  }

  Future<List<BranchValue>> getBranchValueList(BuildContext context) async {
    final LocationProvider locationProvider =
        Provider.of<LocationProvider>(context, listen: false);
    final SplashProvider splashProvider =
        Provider.of<SplashProvider>(context, listen: false);
    LatLng? currentLocationLatLng;

    await locationProvider.getCurrentLatLong().then((latLong) {
      if (latLong != null) {
        currentLocationLatLng = latLong;
      }
      _branchValueList = branchSort(currentLocationLatLng);

      // Auto-select and set the first (nearest) branch as default if no branch is selected
      if (_branchValueList != null &&
          _branchValueList!.isNotEmpty &&
          getBranchId() == -1) {
        final firstBranch = _branchValueList!.first;
        if (firstBranch.branches != null &&
            firstBranch.branches!.status == true) {
          _selectedBranchId = firstBranch.branches!.id;
          // Automatically set the first branch as active
          setBranch(firstBranch.branches!.id!, splashProvider);
        }
      }
    });

    notifyListeners();

    return _branchValueList ?? [];
  }
}
