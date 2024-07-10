import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';
import 'package:mobilefinalhcmus/feature/auth/providers/auth_provider.dart';
import 'package:mobilefinalhcmus/feature/book/provider/booking_provider.dart';
import 'package:mobilefinalhcmus/feature/profie/views/booking/profile_booking_detail.dart';
import 'package:mobilefinalhcmus/feature/profie/views/constants/booking_status.dart';
import 'package:mobilefinalhcmus/helper/app_localization.dart';
import 'package:provider/provider.dart';

class ProfileBooking extends StatefulWidget {
  const ProfileBooking({super.key});

  @override
  State<ProfileBooking> createState() => _ProfileBookingState();
}

class _ProfileBookingState extends State<ProfileBooking> {
  final controller = ScrollController();
  late BookingProvider bookingProvider;
  List<Map<String, dynamic>>? services = [];
  List<String> selectedServiceFilter = [];
  List<String> selectedStatusFilter = [];
  PagingController<int, dynamic>? pagingController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bookingProvider = context.read<BookingProvider>();
    bookingProvider.bookingList = [];
    bookingProvider.page = 1;
    pagingController =
        PagingController(firstPageKey: 1, invisibleItemsThreshold: 3);
  }

  Future<void> fetchServices() async {
    final rs = await bookingProvider.getAllService(
      domain: context.read<AuthenticateProvider>().domain!,
    );
    services = List<Map<String, dynamic>>.from(rs.result?['services']);
  }

  @override
  void dispose() {
    pagingController?.dispose();
    print("dispose booking profile");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Future.wait([fetchServices()]),
        builder: (context, snapshot) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            endDrawer: EndDrawer(
                pagingController: pagingController!,
                selectedServiceFilter: selectedServiceFilter,
                selectedStatusFilter: selectedStatusFilter,
                services: services),
            body: snapshot.connectionState == ConnectionState.waiting
                ? const Center(
                    child: CircularProgressIndicator(
                      color: Colors.black,
                    ),
                  )
                : Builder(builder: (context) {
                    return CustomScrollView(
                      controller: controller,
                      slivers: [
                        SliverAppBar(
                          automaticallyImplyLeading: false,
                          pinned: true,
                          actions: [
                            IconButton(
                                onPressed: () async {
                                  Scaffold.of(context).openEndDrawer();
                                },
                                icon: const Icon(Icons.filter_alt_outlined))
                          ],
                          title: Container(
                            height: 90,
                            alignment: Alignment.bottomLeft,
                            decoration: const BoxDecoration(),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                IconButton(
                                    alignment: Alignment.centerLeft,
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    icon: const Icon(Icons.arrow_back)),
                                Text(
                                  ((AppLocalizations.of(context)!.translate('userBookings')!)['header']),
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                ),
                              ],
                            ),
                          ),
                          bottom: PreferredSize(
                              preferredSize: const Size.fromHeight(80),
                              child: Container(
                                decoration: const BoxDecoration(),
                                padding: const EdgeInsets.all(20),
                                child: TextField(
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(fontSize: 18),
                                  decoration: InputDecoration(
                                    prefixIconConstraints: const BoxConstraints(
                                        minWidth: 32, minHeight: 32),
                                    prefixIcon: const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Icon(
                                        Icons.search,
                                        size: 24,
                                      ),
                                    ),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide.none),
                                    fillColor: Colors.white,
                                    filled: true,
                                    isDense: true,
                                    contentPadding: const EdgeInsets.fromLTRB(
                                        10, 10, 10, 0),
                                  ),
                                ),
                              )),
                        ),
                        showBookingHistory(
                          pagingController: pagingController!,
                          selectedServiceFilter: selectedServiceFilter,
                          selectedStatusFilter: selectedStatusFilter,
                        )
                      ],
                    );
                  }),
          );
        });
  }
}

class EndDrawer extends StatefulWidget {
  EndDrawer(
      {super.key,
      required this.services,
      required this.selectedServiceFilter,
      required this.selectedStatusFilter,
      required this.pagingController});
  List<String> selectedServiceFilter;
  List<String> selectedStatusFilter;
  final List<Map<String, dynamic>>? services;
  PagingController<int, dynamic> pagingController;
  @override
  State<EndDrawer> createState() => _EndDrawerState();
}

class _EndDrawerState extends State<EndDrawer> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        child: Container(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  child: Text(
                    (AppLocalizations.of(context)!.translate('filter')!),
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                            // alignment: Alignment.bottomLeft,
                            child: Text(
                          (AppLocalizations.of(context)!.translate('service')!),
                          style: Theme.of(context).textTheme.titleMedium,
                        )),
                        Expanded(
                          child: Container(
                            child: Align(
                              // alignment: Alignment.topLeft,
                              child: AlignedGridView.count(
                                padding: const EdgeInsets.all(0),
                                crossAxisCount: 2,
                                crossAxisSpacing: 4,
                                mainAxisSpacing: 4,
                                itemCount: widget.services?.length,
                                itemBuilder: (context, index) {
                                  final service = widget.services?[index];
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        if (widget.selectedServiceFilter
                                            .contains(service?['id'])) {
                                          widget.selectedServiceFilter
                                              .removeWhere((element) =>
                                                  element == service?['id']);
                                        } else {
                                          widget.selectedServiceFilter
                                              .add(service?['id']);
                                        }
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(2),
                                      decoration: BoxDecoration(
                                          color: widget.selectedServiceFilter
                                                  .contains(service?['id'])
                                              ? Colors.grey
                                              : Colors.transparent,
                                          border:
                                              Border.all(color: Colors.black)),
                                      child: Center(
                                        child: Row(
                                          children: [
                                            Expanded(
                                                child: Text(
                                              service?['name'],
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium,
                                              maxLines: 1,
                                              overflow: TextOverflow.fade,
                                            )),
                                            if (widget.selectedServiceFilter
                                                .contains(service?['id']))
                                              const Expanded(
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: Icon(
                                                      size: 12, Icons.check),
                                                ),
                                              )
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                //filter by status
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                            // alignment: Alignment.bottomLeft,
                            child: Text(
                          ((AppLocalizations.of(context)!.translate('status')!)),
                          style: Theme.of(context).textTheme.titleMedium,
                        )),
                        Expanded(
                          child: Align(
                            // alignment: Alignment.topLeft,
                            child: AlignedGridView.count(
                              padding: const EdgeInsets.all(0),
                              crossAxisCount: 2,
                              crossAxisSpacing: 4,
                              mainAxisSpacing: 4,
                              itemCount: StatusBooking.length,
                              itemBuilder: (context, index) {
                                final bookingStatus =
                                    StatusBooking.keys.elementAt(index);

                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      if (widget.selectedStatusFilter
                                          .contains(bookingStatus)) {
                                        widget.selectedStatusFilter.removeWhere(
                                            (element) =>
                                                element == bookingStatus);
                                      } else {
                                        widget.selectedStatusFilter
                                            .add(bookingStatus);
                                      }
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                        color: widget.selectedStatusFilter
                                                .contains(bookingStatus)
                                            ? Colors.grey
                                            : Colors.transparent,
                                        border:
                                            Border.all(color: Colors.black)),
                                    child: Row(
                                      children: [
                                        Expanded(child: Text('${((AppLocalizations.of(context)!.translate('userBookings')!)['status'])[bookingStatus.toLowerCase()]} ')),
                                        if (widget.selectedStatusFilter
                                            .contains(bookingStatus))
                                          const Expanded(
                                            child: Align(
                                              alignment: Alignment.centerRight,
                                              child:
                                                  Icon(size: 12, Icons.check),
                                            ),
                                          )
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            setState(() {
                              widget.selectedServiceFilter.clear();
                              widget.selectedStatusFilter.clear();
                              widget.pagingController.refresh();

                              Navigator.of(context).pop();
                            });
                          },
                          child: Text(
                            "Reset",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(),
                          )),
                      const SizedBox(
                        width: 10,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            widget.pagingController.refresh();
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            "Apply",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(),
                          )),
                    ],
                  ),
                )
              ],
            )),
      ),
    );
  }
}

class showBookingHistory extends StatefulWidget {
  showBookingHistory(
      {super.key,
      this.selectedServiceFilter,
      this.selectedStatusFilter,
      required this.pagingController});
  List<String>? selectedServiceFilter;
  List<String>? selectedStatusFilter;
  PagingController<int, dynamic> pagingController;

  @override
  State<showBookingHistory> createState() => _showBookingHistoryState();
}

class _showBookingHistoryState extends State<showBookingHistory> {
  late BookingProvider bookingProvider;
  List<Map<String, dynamic>>? dateTitle = [];

  final int _pageSize = 5;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (mounted) {
      bookingProvider = context.read<BookingProvider>();
      widget.pagingController.addPageRequestListener(_fetchData);
    }
  }

  Future<void> _fetchData(int pageKey) async {
    try {
      await bookingProvider.getAllBooking(
          token: context.read<AuthenticateProvider>().token!,
          services: widget.selectedServiceFilter,
          status: widget.selectedStatusFilter,
          limit: 5,
          page: pageKey);
      final bookings = bookingProvider.bookingList;

      final isLastPage = bookings.length < _pageSize;
      if (isLastPage) {
        widget.pagingController.appendLastPage(bookings);
      } else {
        final nextPageKey = pageKey + 1;
        widget.pagingController.appendPage(bookings, nextPageKey);
      }
    } catch (e) {
      if (mounted) {
        widget.pagingController.error = e;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    print(context.read<AuthenticateProvider>().token!);
    return SliverPadding(
      padding: const EdgeInsets.all(16),
      sliver: PagedSliverList(
          pagingController: widget.pagingController,
          builderDelegate: PagedChildBuilderDelegate(
            noItemsFoundIndicatorBuilder: (context) {
              return Container(
                child: Center(
                  child: Text(
                    "No items",
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
              );
            },
            firstPageErrorIndicatorBuilder: (context) {
              return const Center(
                child: Text("Somethings went wrong!"),
              );
            },
            newPageErrorIndicatorBuilder: (context) {
              return const Center(
                child: Text("Somethings went wrong!"),
              );
            },
            firstPageProgressIndicatorBuilder: (context) {
              dateTitle = [];
              return Text("");
            },
            newPageProgressIndicatorBuilder: (context) {
              return Container(
                child: const Center(
                  child: CircularProgressIndicator(
                    color: Colors.black,
                  ),
                ),
              );
            },
            animateTransitions: true,
            // [transitionDuration] has a default value of 250 milliseconds.
            transitionDuration: const Duration(milliseconds: 250),
            itemBuilder: (context, item, index) {
              final booking = item as Map<String, dynamic>;
              final date = DateFormat("EEEE,MMM d")
                  .format(DateTime.parse(booking['startTime']));
              final startTime = DateFormat("HH:mm")
                  .format(DateTime.parse(booking['startTime']));
              final createdAt = DateFormat("EEEE,MMM d")
                  .format(DateTime.parse(booking['createdAt']));

              if (dateTitle!.isEmpty) {
                print("date tiltle is null");
                print(dateTitle);
                print(createdAt);
                dateTitle?.add({createdAt: index});
              } else {
                print("data title $createdAt");
                print(
                    dateTitle!.where((element) => element[createdAt] != null));
                if (dateTitle!
                    .where((element) => element[createdAt] != null)
                    .isEmpty) {
                  dateTitle?.add({createdAt: index});
                }
              }
              print(booking['status'].toString().toLowerCase());
              return GestureDetector(
                onTap: () => {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) {
                      return BookingDetailPage(
                        bookingDetail: booking,
                      );
                    },
                  )).then((value) {
                    print("refresh: $value");
                    if (value != null) {
                      if (value == true) {
                        widget.pagingController.refresh();
                      }
                    }
                  })
                },
                child: Column(
                  children: [
                    if (dateTitle!
                        .where((element) => element[createdAt] == index)
                        .isNotEmpty)
                      Container(
                        child: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.secondary,
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(15)),
                          child: Text(
                            createdAt,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15)),
                      height: 300,
                      child: Material(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                          bottomLeft: Radius.circular(15),
                          bottomRight: Radius.circular(15),
                        ),
                        elevation: 1,
                        child: Column(
                          children: [
                            Expanded(
                                flex: 4,
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.amber,
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(15),
                                        topRight: Radius.circular(15),
                                      ),
                                      image: DecorationImage(
                                          image: NetworkImage(
                                            booking['service']['images'][0],
                                          ),
                                          fit: BoxFit.fill)),
                                )),
                            Expanded(
                              flex: 6,
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(15),
                                    bottomRight: Radius.circular(15),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                        flex: 3,
                                        child: Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              color: Colors.grey.shade200),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                date,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyLarge
                                                    ?.copyWith(
                                                        fontWeight:
                                                            FontWeight.bold),
                                              ),
                                              Text(startTime),
                                            ],
                                          ),
                                        )),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Expanded(
                                        flex: 7,
                                        child: Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                          child: Column(
                                            children: [
                                              Expanded(
                                                  child: Row(
                                                children: [
                                                  const Icon(
                                                      Icons.article_outlined),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        "${((AppLocalizations.of(context)!.translate('userBookings')!)['id'])}: ",
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodyMedium
                                                            ?.copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                      ),
                                                      Text(booking['id']
                                                          .toString()
                                                          .split("-")[4]),
                                                    ],
                                                  )
                                                ],
                                              )),
                                              Expanded(
                                                  child: Row(
                                                children: [
                                                  const Icon(
                                                      Icons.info_outline),
                                                  Container(
                                                    child: Text(
                                                      "${((AppLocalizations.of(context)!.translate('service')!))}: ",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyMedium
                                                          ?.copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 100,
                                                    child: Text(
                                                      booking['service']
                                                          ['name'],
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 1,
                                                      softWrap: true,
                                                    ),
                                                  ),
                                                ],
                                              )),
                                              Expanded(
                                                  child: Row(
                                                children: [
                                                  const Image(
                                                    image: AssetImage(
                                                        "assets/images/social-media.png"),
                                                    height: 24,
                                                    width: 24,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        "${((AppLocalizations.of(context)!.translate('status')!))}: ",
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodyMedium
                                                            ?.copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                      ),
                                                      Text( ((AppLocalizations.of(context)!.translate('userBookings')!)['status'])[booking['status'].toString().toLowerCase()] ),
                                                    ],
                                                  )
                                                ],
                                              )),
                                              Expanded(
                                                  child: Row(
                                                children: [
                                                  const Icon(
                                                      Icons.people_outline),
                                                  Expanded(
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          "${((AppLocalizations.of(context)!.translate('employee')!))}: ",
                                                          style: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .bodyMedium
                                                              ?.copyWith(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                        ),
                                                        Expanded(
                                                          child: Text(booking[
                                                                      'employee']
                                                                  [
                                                                  'firstName'] +
                                                              " " +
                                                              booking['employee']
                                                                  ['lastName']),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              )),
                                            ],
                                          ),
                                        ))
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          )),
    );
  }
}
