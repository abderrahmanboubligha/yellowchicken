import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/common/widgets/custom_app_bar_widget.dart';
import 'package:flutter_restaurant/common/widgets/custom_button_widget.dart';
import 'package:flutter_restaurant/common/widgets/custom_pop_scope_widget.dart';
import 'package:flutter_restaurant/common/widgets/footer_widget.dart';
import 'package:flutter_restaurant/common/widgets/web_app_bar_widget.dart';
import 'package:flutter_restaurant/features/branch/providers/branch_provider.dart';
import 'package:flutter_restaurant/features/branch/widgets/branch_card_widget.dart';
import 'package:flutter_restaurant/features/branch/widgets/branch_close_widget.dart';
import 'package:flutter_restaurant/features/branch/widgets/branch_item_card_widget.dart';
import 'package:flutter_restaurant/features/branch/widgets/branch_shimmer_widget.dart';
import 'package:flutter_restaurant/features/cart/providers/cart_provider.dart';
import 'package:flutter_restaurant/features/splash/providers/splash_provider.dart';
import 'package:flutter_restaurant/helper/branch_helper.dart';
import 'package:flutter_restaurant/helper/custom_snackbar_helper.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/main.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class BranchListScreen extends StatefulWidget {
  const BranchListScreen({super.key});

  @override
  State<BranchListScreen> createState() => _BranchListScreenState();
}

class _BranchListScreenState extends State<BranchListScreen> {
  // List<BranchValue> _branchesValue = [];
  Set<Marker> _markers = HashSet<Marker>();
  late GoogleMapController _mapController;
  LatLng? _currentLocationLatLng;
  AutoScrollController? scrollController;

  @override
  void initState() {
    super.initState();

    _onInit();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final CartProvider cartProvider =
        Provider.of<CartProvider>(context, listen: false);

    final double height = MediaQuery.sizeOf(context).height;
    final bool isDesktop = ResponsiveHelper.isDesktop(context);

    return Consumer<SplashProvider>(builder: (ctx, splashProvider, _) {
      return Consumer<BranchProvider>(builder: (context, branchProvider, _) {
        return CustomPopScopeWidget(
          onPopInvoked: () {
            if (branchProvider.branchTabIndex != 0) {
              branchProvider.updateTabIndex(0);
            }
          },
          child: Scaffold(
            appBar: (isDesktop
                ? const PreferredSize(
                    preferredSize: Size.fromHeight(100),
                    child: WebAppBarWidget())
                : CustomAppBarWidget(
                    context: context,
                    title: getTranslated('select_branch', context),
                    centerTitle: !Navigator.canPop(context),
                    isBackButtonExist:
                        branchProvider.branchTabIndex == 1 || context.canPop(),
                    onBackPressed: () => branchProvider.branchTabIndex == 1
                        ? branchProvider.updateTabIndex(0)
                        : context.canPop()
                            ? context.pop()
                            : null,
                  )) as PreferredSizeWidget?,
            body: splashProvider.getActiveBranch() == 0
                ? const BranchCloseWidget()
                : Column(children: [
                    Expanded(
                        child: SingleChildScrollView(
                      child: Column(children: [
                        Container(
                          width: isDesktop
                              ? Dimensions.webScreenWidth
                              : double.infinity,
                          margin: isDesktop
                              ? EdgeInsets.symmetric(
                                  horizontal:
                                      (MediaQuery.of(context).size.width -
                                              Dimensions.webScreenWidth) /
                                          2)
                              : null,
                          constraints: BoxConstraints(
                              minHeight: !isDesktop && height < 600
                                  ? height
                                  : height - (isDesktop ? 400 : 200)),
                          child: Column(children: [
                            if (branchProvider.branchTabIndex == 1) ...[
                              SizedBox(
                                  height: ResponsiveHelper.isMobile()
                                      ? Dimensions.paddingSizeSmall
                                      : Dimensions.paddingSizeDefault)
                            ],

                            branchProvider.branchTabIndex == 1
                                ? isDesktop
                                    ? Container(
                                        color: Theme.of(context)
                                            .hintColor
                                            .withValues(alpha: 0.02),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal:
                                              Dimensions.paddingSizeLarge,
                                          vertical: Dimensions.paddingSizeLarge,
                                        ),
                                        height: height - 400,
                                        child: Row(children: [
                                          Expanded(
                                              flex: ResponsiveHelper
                                                      .isLargeDesktop(context)
                                                  ? 3
                                                  : 4,
                                              child: ScrollConfiguration(
                                                behavior:
                                                    ScrollConfiguration.of(
                                                            context)
                                                        .copyWith(
                                                            scrollbars: false),
                                                child: ListView.separated(
                                                  separatorBuilder:
                                                      (context, index) {
                                                    return const SizedBox(
                                                        height: Dimensions
                                                            .paddingSizeDefault);
                                                  },
                                                  itemCount: branchProvider
                                                          .branchValueList
                                                          ?.length ??
                                                      0,
                                                  physics:
                                                      const BouncingScrollPhysics(),
                                                  itemBuilder:
                                                      (context, index) =>
                                                          BranchCardWidget(
                                                    branchModel: branchProvider
                                                            .branchValueList?[
                                                        index],
                                                    branchModelList:
                                                        branchProvider
                                                            .branchValueList,
                                                    onTap: () => _setMarkers(
                                                        index, branchProvider,
                                                        fromBranchSelect: true),
                                                  ),
                                                ),
                                              )),
                                          SizedBox(
                                              width: ResponsiveHelper
                                                      .isLargeDesktop(context)
                                                  ? Dimensions.paddingSizeLarge
                                                  : Dimensions
                                                      .paddingSizeDefault),
                                          Expanded(
                                              flex: ResponsiveHelper
                                                      .isLargeDesktop(context)
                                                  ? 7
                                                  : 6,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: Dimensions
                                                        .paddingSizeLarge),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          Dimensions
                                                              .radiusDefault),
                                                  child: GoogleMap(
                                                    mapType: MapType.normal,
                                                    initialCameraPosition:
                                                        CameraPosition(
                                                      target: LatLng(
                                                        branchProvider
                                                                .branchValueList?[
                                                                    0]
                                                                .branches
                                                                ?.latitude ??
                                                            0,
                                                        branchProvider
                                                                .branchValueList?[
                                                                    0]
                                                                .branches
                                                                ?.longitude ??
                                                            0,
                                                      ),
                                                      zoom: 5,
                                                    ),
                                                    minMaxZoomPreference:
                                                        const MinMaxZoomPreference(
                                                            0, 16),
                                                    zoomControlsEnabled: true,
                                                    markers: _markers,
                                                    onMapCreated:
                                                        (GoogleMapController
                                                            controller) async {
                                                      _mapController =
                                                          controller;
                                                      // _loading = false;
                                                      _setMarkers(
                                                          1, branchProvider);
                                                    },
                                                  ),
                                                ),
                                              )),
                                        ]),
                                      )
                                    : ResponsiveHelper.isTab(context)
                                        ? Container(
                                            height: height - 200,
                                            padding: const EdgeInsets.all(
                                                Dimensions.paddingSizeDefault),
                                            child: Column(children: [
                                              Expanded(
                                                flex: 6,
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          Dimensions
                                                              .radiusDefault),
                                                  child: GoogleMap(
                                                    mapType: MapType.normal,
                                                    initialCameraPosition:
                                                        CameraPosition(
                                                      target: LatLng(
                                                        branchProvider
                                                                .branchValueList?[
                                                                    0]
                                                                .branches
                                                                ?.latitude ??
                                                            0,
                                                        branchProvider
                                                                .branchValueList?[
                                                                    0]
                                                                .branches
                                                                ?.longitude ??
                                                            0,
                                                      ),
                                                      zoom: 5,
                                                    ),
                                                    minMaxZoomPreference:
                                                        const MinMaxZoomPreference(
                                                            0, 16),
                                                    zoomControlsEnabled: true,
                                                    markers: _markers,
                                                    onMapCreated:
                                                        (GoogleMapController
                                                            controller) async {
                                                      _mapController =
                                                          controller;
                                                      _setMarkers(
                                                          1, branchProvider);
                                                    },
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                  height: Dimensions
                                                      .paddingSizeDefault),
                                              Expanded(
                                                flex: 4,
                                                child: ListView.builder(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  itemCount: branchProvider
                                                      .branchValueList?.length,
                                                  physics:
                                                      const BouncingScrollPhysics(),
                                                  itemBuilder:
                                                      (context, index) =>
                                                          Padding(
                                                    padding: EdgeInsets.only(
                                                      left: index == 0
                                                          ? 0
                                                          : Dimensions
                                                              .paddingSizeSmall,
                                                      right: Dimensions
                                                          .paddingSizeSmall,
                                                    ),
                                                    child: SizedBox(
                                                      width: 280,
                                                      child: BranchCardWidget(
                                                        branchModel: branchProvider
                                                                .branchValueList?[
                                                            index],
                                                        branchModelList:
                                                            branchProvider
                                                                .branchValueList,
                                                        onTap: () => _setMarkers(
                                                            index,
                                                            branchProvider,
                                                            fromBranchSelect:
                                                                true),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ]),
                                          )
                                        : SizedBox(
                                            height: height - 170,
                                            child: Stack(children: [
                                              GoogleMap(
                                                mapType: MapType.normal,
                                                initialCameraPosition:
                                                    CameraPosition(
                                                  target: LatLng(
                                                    branchProvider
                                                            .branchValueList?[0]
                                                            .branches
                                                            ?.latitude ??
                                                        0,
                                                    branchProvider
                                                            .branchValueList?[0]
                                                            .branches
                                                            ?.longitude ??
                                                        0,
                                                  ),
                                                  zoom: 5,
                                                ),
                                                minMaxZoomPreference:
                                                    const MinMaxZoomPreference(
                                                        0, 16),
                                                zoomControlsEnabled: true,
                                                markers: _markers,
                                                onMapCreated:
                                                    (GoogleMapController
                                                        controller) async {
                                                  await Geolocator
                                                      .requestPermission();
                                                  _mapController = controller;
                                                  // _loading = false;
                                                  _setMarkers(
                                                      1, branchProvider);
                                                },
                                              ),
                                              Positioned.fill(
                                                  child: Align(
                                                      alignment: Alignment
                                                          .bottomCenter,
                                                      child: SizedBox(
                                                        height: 170,
                                                        child: ListView.builder(
                                                          scrollDirection:
                                                              Axis.horizontal,
                                                          itemCount:
                                                              branchProvider
                                                                  .branchValueList
                                                                  ?.length,
                                                          physics:
                                                              const BouncingScrollPhysics(),
                                                          itemBuilder: (context,
                                                                  index) =>
                                                              Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                              left: Dimensions
                                                                  .paddingSizeLarge,
                                                              bottom: Dimensions
                                                                  .paddingSizeLarge,
                                                              right: index ==
                                                                      (branchProvider.branchValueList?.length ??
                                                                              0) -
                                                                          1
                                                                  ? Dimensions
                                                                      .paddingSizeLarge
                                                                  : 0,
                                                            ),
                                                            child:
                                                                BranchCardWidget(
                                                              branchModel:
                                                                  branchProvider
                                                                          .branchValueList?[
                                                                      index],
                                                              branchModelList:
                                                                  branchProvider
                                                                      .branchValueList,
                                                              onTap: () => _setMarkers(
                                                                  index,
                                                                  branchProvider,
                                                                  fromBranchSelect:
                                                                      true),
                                                            ),
                                                          ),
                                                        ),
                                                      ))),
                                            ]),
                                          )
                                : Container(
                                    padding: EdgeInsets.symmetric(
                                      vertical: ResponsiveHelper.isMobile()
                                          ? Dimensions.paddingSizeSmall
                                          : Dimensions.paddingSizeDefault,
                                      horizontal: ResponsiveHelper.isMobile()
                                          ? Dimensions.paddingSizeDefault
                                          : Dimensions.paddingSizeLarge,
                                    ),
                                    child: Column(children: [
                                      /// for Nearest Branch top bar
                                      Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                '${getTranslated('nearest_branch', context)} (${branchProvider.branchValueList?.length ?? 0})',
                                                style: rubikBold.copyWith(
                                                  fontSize: ResponsiveHelper
                                                          .isMobile()
                                                      ? Dimensions
                                                          .fontSizeDefault
                                                      : ResponsiveHelper.isTab(
                                                              context)
                                                          ? Dimensions
                                                              .fontSizeLarge
                                                          : Dimensions
                                                              .fontSizeExtraLarge,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            if (splashProvider.configModel
                                                    ?.googleMapStatus ==
                                                1)
                                              GestureDetector(
                                                onTap: () => branchProvider
                                                    .updateTabIndex(1),
                                                child: Container(
                                                  constraints: BoxConstraints(
                                                    minHeight: ResponsiveHelper
                                                            .isMobile()
                                                        ? 30
                                                        : 35,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            Dimensions
                                                                .radiusDefault),
                                                    border: Border.all(
                                                        color: Theme.of(context)
                                                            .primaryColor),
                                                  ),
                                                  clipBehavior: Clip.hardEdge,
                                                  child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Container(
                                                          height:
                                                              ResponsiveHelper
                                                                      .isMobile()
                                                                  ? 30
                                                                  : 35,
                                                          width: ResponsiveHelper
                                                                  .isMobile()
                                                              ? 32
                                                              : 38,
                                                          decoration: BoxDecoration(
                                                              color: Theme.of(
                                                                      context)
                                                                  .primaryColor),
                                                          child: Icon(
                                                            Icons.location_on,
                                                            color: Colors.white,
                                                            size: ResponsiveHelper
                                                                    .isMobile()
                                                                ? Dimensions
                                                                    .fontSizeDefault
                                                                : Dimensions
                                                                    .paddingSizeDefault,
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                            horizontal: ResponsiveHelper
                                                                    .isMobile()
                                                                ? Dimensions
                                                                    .paddingSizeExtraSmall
                                                                : Dimensions
                                                                    .paddingSizeSmall,
                                                          ),
                                                          child: Text(
                                                            getTranslated(
                                                                'view_map',
                                                                context)!,
                                                            style:
                                                                poppinsRegular
                                                                    .copyWith(
                                                              color: Theme.of(
                                                                      context)
                                                                  .primaryColor,
                                                              fontSize: ResponsiveHelper
                                                                      .isMobile()
                                                                  ? Dimensions
                                                                      .fontSizeExtraSmall
                                                                  : Dimensions
                                                                      .fontSizeSmall,
                                                            ),
                                                          ),
                                                        ),
                                                      ]),
                                                ),
                                              ),
                                          ]),
                                      SizedBox(
                                          height: ResponsiveHelper.isMobile()
                                              ? Dimensions.paddingSizeDefault
                                              : Dimensions.paddingSizeLarge),

                                      (branchProvider.branchValueList
                                                  ?.isNotEmpty ??
                                              false)
                                          ? LayoutBuilder(
                                              builder: (context, constraints) {
                                                int crossAxisCount;

                                                if (ResponsiveHelper
                                                    .isMobile()) {
                                                  crossAxisCount = 1;
                                                } else if (ResponsiveHelper
                                                    .isTab(context)) {
                                                  crossAxisCount =
                                                      constraints.maxWidth > 600
                                                          ? 2
                                                          : 1;
                                                } else {
                                                  // Desktop
                                                  if (constraints.maxWidth >
                                                      1400) {
                                                    crossAxisCount = 4;
                                                  } else if (constraints
                                                          .maxWidth >
                                                      1000) {
                                                    crossAxisCount = 3;
                                                  } else {
                                                    crossAxisCount = 2;
                                                  }
                                                }

                                                return GridView.builder(
                                                  gridDelegate:
                                                      SliverGridDelegateWithFixedCrossAxisCount(
                                                    crossAxisSpacing: ResponsiveHelper
                                                            .isMobile()
                                                        ? Dimensions
                                                            .paddingSizeSmall
                                                        : ResponsiveHelper
                                                                .isTab(context)
                                                            ? Dimensions
                                                                .paddingSizeDefault
                                                            : Dimensions
                                                                .paddingSizeLarge,
                                                    mainAxisSpacing: ResponsiveHelper
                                                            .isMobile()
                                                        ? Dimensions
                                                            .paddingSizeDefault
                                                        : ResponsiveHelper
                                                                .isTab(context)
                                                            ? Dimensions
                                                                .paddingSizeLarge
                                                            : Dimensions
                                                                .paddingSizeExtraLarge,
                                                    mainAxisExtent:
                                                        ResponsiveHelper
                                                                .isMobile()
                                                            ? 170
                                                            : ResponsiveHelper
                                                                    .isTab(
                                                                        context)
                                                                ? 185
                                                                : 200,
                                                    crossAxisCount:
                                                        crossAxisCount,
                                                  ),
                                                  shrinkWrap: true,
                                                  physics:
                                                      const NeverScrollableScrollPhysics(),
                                                  itemCount: branchProvider
                                                      .branchValueList?.length,
                                                  itemBuilder:
                                                      (context, index) =>
                                                          BranchItemCardWidget(
                                                    branchesValue: branchProvider
                                                            .branchValueList?[
                                                        index],
                                                  ),
                                                );
                                              },
                                            )
                                          : LayoutBuilder(
                                              builder: (context, constraints) {
                                                int crossAxisCount;

                                                if (ResponsiveHelper
                                                    .isMobile()) {
                                                  crossAxisCount = 1;
                                                } else if (ResponsiveHelper
                                                    .isTab(context)) {
                                                  crossAxisCount =
                                                      constraints.maxWidth > 600
                                                          ? 2
                                                          : 1;
                                                } else {
                                                  // Desktop
                                                  if (constraints.maxWidth >
                                                      1400) {
                                                    crossAxisCount = 4;
                                                  } else if (constraints
                                                          .maxWidth >
                                                      1000) {
                                                    crossAxisCount = 3;
                                                  } else {
                                                    crossAxisCount = 2;
                                                  }
                                                }

                                                return GridView.builder(
                                                  gridDelegate:
                                                      SliverGridDelegateWithFixedCrossAxisCount(
                                                    crossAxisSpacing: ResponsiveHelper
                                                            .isMobile()
                                                        ? Dimensions
                                                            .paddingSizeSmall
                                                        : ResponsiveHelper
                                                                .isTab(context)
                                                            ? Dimensions
                                                                .paddingSizeDefault
                                                            : Dimensions
                                                                .paddingSizeLarge,
                                                    mainAxisSpacing: ResponsiveHelper
                                                            .isMobile()
                                                        ? Dimensions
                                                            .paddingSizeDefault
                                                        : ResponsiveHelper
                                                                .isTab(context)
                                                            ? Dimensions
                                                                .paddingSizeLarge
                                                            : Dimensions
                                                                .paddingSizeExtraLarge,
                                                    mainAxisExtent:
                                                        ResponsiveHelper
                                                                .isMobile()
                                                            ? 170
                                                            : ResponsiveHelper
                                                                    .isTab(
                                                                        context)
                                                                ? 185
                                                                : 200,
                                                    crossAxisCount:
                                                        crossAxisCount,
                                                  ),
                                                  shrinkWrap: true,
                                                  physics:
                                                      const NeverScrollableScrollPhysics(),
                                                  itemCount: 5,
                                                  itemBuilder: (context,
                                                          index) =>
                                                      BranchShimmerCardWidget(
                                                    isEnabled: (branchProvider
                                                            .branchValueList
                                                            ?.isEmpty ??
                                                        true),
                                                  ),
                                                );
                                              },
                                            ),
                                    ]),
                                  ),

                            /// for Branch select button web
                            if (isDesktop)
                              _BranchSelectButtonWidget(
                                  cartProvider: cartProvider),
                          ]),
                        ),
                        if (isDesktop) const FooterWidget(),
                      ]),
                    )),

                    /// for Branch select button
                    if (!isDesktop)
                      _BranchSelectButtonWidget(cartProvider: cartProvider),
                  ]),
          ),
        );
      });
    });
  }

  Future<void> _onInit() async {
    final BranchProvider branchProvider =
        Provider.of<BranchProvider>(Get.context!, listen: false);
    await Geolocator.requestPermission();

    branchProvider.updateTabIndex(0, isUpdate: false);

    ///if need to previous selection
    if (branchProvider.getBranchId() == -1) {
      branchProvider.updateBranchId(null, isUpdate: false);
    } else {
      branchProvider.updateBranchId(branchProvider.getBranchId(),
          isUpdate: false);
    }

    if (branchProvider.branchValueList == null && mounted) {
      await branchProvider.getBranchValueList(context);
    }

    scrollController = AutoScrollController(
      viewportBoundaryGetter: () =>
          Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
      axis: Axis.horizontal,
    );
  }

  void _setMarkers(int selectedIndex, BranchProvider branchProvider,
      {bool fromBranchSelect = false}) async {
    await scrollController!.scrollToIndex(selectedIndex,
        preferPosition: AutoScrollPosition.middle);
    await scrollController!.highlight(selectedIndex);

    late BitmapDescriptor bitmapDescriptor;
    late BitmapDescriptor bitmapDescriptorUnSelect;
    late BitmapDescriptor currentLocationDescriptor;

    await BitmapDescriptor.asset(const ImageConfiguration(size: Size(35, 60)),
            Images.restaurantMarker)
        .then((marker) {
      bitmapDescriptor = marker;
    });

    await BitmapDescriptor.asset(const ImageConfiguration(size: Size(25, 40)),
            Images.restaurantMarkerUnselect)
        .then((marker) {
      bitmapDescriptorUnSelect = marker;
    });

    await BitmapDescriptor.asset(const ImageConfiguration(size: Size(30, 50)),
            Images.currentLocationMarker)
        .then((marker) {
      currentLocationDescriptor = marker;
    });

    // Marker
    _markers = HashSet<Marker>();
    for (int index = 0;
        index < (branchProvider.branchValueList?.length ?? 0);
        index++) {
      _markers.add(Marker(
        onTap: () async {
          if (branchProvider.branchValueList?[index].branches?.status ??
              false) {
            Provider.of<BranchProvider>(context, listen: false).updateBranchId(
                branchProvider.branchValueList?[index].branches!.id);
          }
        },
        markerId: MarkerId('branch_$index'),
        position: LatLng(
          branchProvider.branchValueList?[index].branches?.latitude ?? 0,
          branchProvider.branchValueList?[index].branches?.longitude ?? 0,
        ),
        infoWindow: InfoWindow(
            title: branchProvider.branchValueList?[index].branches?.name,
            snippet: branchProvider.branchValueList?[index].branches?.address),
        visible:
            branchProvider.branchValueList?[index].branches?.status ?? false,
        icon: selectedIndex == index
            ? bitmapDescriptor
            : bitmapDescriptorUnSelect,
      ));
    }
    if (_currentLocationLatLng != null) {
      _markers.add(Marker(
        markerId: const MarkerId('current_location'),
        position: _currentLocationLatLng!,
        infoWindow: InfoWindow(
            title: getTranslated('current_location', Get.context!),
            snippet: ''),
        icon: currentLocationDescriptor,
      ));
    }

    _mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: _currentLocationLatLng != null && !fromBranchSelect
          ? _currentLocationLatLng!
          : LatLng(
              branchProvider
                      .branchValueList?[selectedIndex].branches?.latitude ??
                  0,
              branchProvider
                      .branchValueList?[selectedIndex].branches?.longitude ??
                  0,
            ),
      zoom: ResponsiveHelper.isMobile() ? 12 : 16,
    )));

    if (mounted) {
      setState(() {});
    }
  }
}

class _BranchSelectButtonWidget extends StatelessWidget {
  const _BranchSelectButtonWidget({required this.cartProvider});

  final CartProvider cartProvider;

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = ResponsiveHelper.isDesktop(context);
    final double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: isDesktop ? (screenWidth > 1400 ? 500 : 400) : double.infinity,
      margin: isDesktop
          ? EdgeInsets.symmetric(
              horizontal: (screenWidth - (screenWidth > 1400 ? 500 : 400)) / 2)
          : const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
      padding: EdgeInsets.all(
        ResponsiveHelper.isMobile()
            ? Dimensions.paddingSizeDefault
            : ResponsiveHelper.isTab(context)
                ? Dimensions.paddingSizeLarge
                : Dimensions.paddingSizeExtraLarge,
      ),
      child: Consumer<BranchProvider>(
          builder: (context, branchProvider, _) => CustomButtonWidget(
                btnTxt: getTranslated(
                    branchProvider.selectedBranchId == null
                        ? 'select_branch'
                        : 'next',
                    context),
                borderRadius: ResponsiveHelper.isMobile()
                    ? Dimensions.radiusDefault
                    : ResponsiveHelper.isTab(context)
                        ? Dimensions.radiusLarge
                        : Dimensions.radiusExtraLarge,
                height: ResponsiveHelper.isMobile()
                    ? 45
                    : ResponsiveHelper.isTab(context)
                        ? 50
                        : 55,
                onTap: branchProvider.selectedBranchId == null
                    ? null
                    : () {
                        if (branchProvider.selectedBranchId !=
                                branchProvider.getBranchId() &&
                            cartProvider.cartList.isNotEmpty) {
                          BranchHelper.dialogOrBottomSheet(
                            context,
                            onPressRight: () {
                              BranchHelper.setBranch(context);
                              cartProvider.getCartData(context);
                            },
                            title:
                                getTranslated('you_have_some_food', context)!,
                          );
                        } else {
                          if (branchProvider.getBranchId() == -1) {
                            if (branchProvider.branchTabIndex != 0) {
                              branchProvider.updateTabIndex(0, isUpdate: false);
                            }
                            BranchHelper.setBranch(context);
                            cartProvider.getCartData(context);
                          } else if (branchProvider.selectedBranchId ==
                              branchProvider.getBranchId()) {
                            showCustomSnackBarHelper(getTranslated(
                                'this_is_your_current_branch', context));
                          } else {
                            BranchHelper.dialogOrBottomSheet(
                              context,
                              onPressRight: () {
                                if (branchProvider.branchTabIndex != 0) {
                                  branchProvider.updateTabIndex(0,
                                      isUpdate: false);
                                }
                                BranchHelper.setBranch(context);
                                cartProvider.getCartData(context);
                              },
                              title: getTranslated(
                                  'switch_branch_effect', context)!,
                            );
                          }
                        }
                      },
              )),
    );
  }
}
