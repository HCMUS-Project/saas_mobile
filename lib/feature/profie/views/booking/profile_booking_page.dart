import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';
import 'package:mobilefinalhcmus/feature/auth/providers/auth_provider.dart';
import 'package:mobilefinalhcmus/feature/book/provider/booking_provider.dart';
import 'package:mobilefinalhcmus/feature/profie/views/booking/profile_booking_detail.dart';
import 'package:mobilefinalhcmus/feature/profie/views/constants/booking_status.dart';
import 'package:provider/provider.dart';

class ProfileBooking extends StatefulWidget {
  @override
  State<ProfileBooking> createState() => _ProfileBookingState();
}

class _ProfileBookingState extends State<ProfileBooking> {
  final controller = ScrollController();
  late BookingProvider bookingProvider;
  List<Map<String, dynamic>>? services = [];
  List<String> selectedServiceFilter = [];
  List<String> selectedStatusFilter = [];
  final PagingController<int, dynamic> pagingController =
      PagingController(firstPageKey: 1, invisibleItemsThreshold: 3);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bookingProvider = context.read<BookingProvider>();
    bookingProvider.bookingList = [];
    bookingProvider.page = 1;
  }

  Future<void> fetchServices() async {
    final rs = await bookingProvider.getAllService(
      domain: context.read<AuthenticateProvider>().domain!,
    );
    services = List<Map<String, dynamic>>.from(rs.result?['services']);
  }

  @override
  void dispose() {
    super.dispose();
    pagingController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Future.wait([fetchServices()]),
        builder: (context, snapshot) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            endDrawer: EndDrawer(
                pagingController: pagingController,
                selectedServiceFilter: selectedServiceFilter,
                selectedStatusFilter: selectedStatusFilter,
                services: services),
            body: snapshot.connectionState == ConnectionState.waiting
                ? Center(
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
                                icon: Icon(Icons.filter_alt_outlined))
                          ],
                          title: Container(
                            height: 90,
                            alignment: Alignment.bottomLeft,
                            decoration: BoxDecoration(),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                IconButton(
                                    alignment: Alignment.centerLeft,
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    icon: Icon(Icons.arrow_back)),
                                Text(
                                  "Let's find your booking!",
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
                              preferredSize: Size.fromHeight(80),
                              child: Container(
                                decoration: BoxDecoration(),
                                padding: EdgeInsets.all(20),
                                child: TextField(
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(fontSize: 18),
                                  decoration: InputDecoration(
                                    prefixIconConstraints: BoxConstraints(
                                        minWidth: 32, minHeight: 32),
                                    prefixIcon: Padding(
                                      padding: const EdgeInsets.all(8.0),
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
                                    contentPadding:
                                        EdgeInsets.fromLTRB(10, 10, 10, 0),
                                  ),
                                ),
                              )),
                        ),
                        showBookingHistory(
                          pagingController: pagingController,
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
            padding: EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  child: Text(
                    "Filter",
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                            // alignment: Alignment.bottomLeft,
                            child: Text(
                          "Services",
                          style: Theme.of(context).textTheme.titleMedium,
                        )),
                        Expanded(
                          child: Container(
                            child: Align(
                              // alignment: Alignment.topLeft,
                              child: AlignedGridView.count(
                                padding: EdgeInsets.all(0),
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
                                      padding: EdgeInsets.all(2),
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
                                                child: Text(service?['name'])),
                                            if (widget.selectedServiceFilter
                                                .contains(service?['id']))
                                              const Align(
                                                alignment:
                                                    Alignment.centerRight,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: CircleAvatar(
                                                    radius: 12,
                                                    child: Icon(Icons.check),
                                                  ),
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
                  
                    decoration: BoxDecoration(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                            // alignment: Alignment.bottomLeft,
                            child: Text(
                          "Status",
                          style: Theme.of(context).textTheme.titleMedium,
                        )),
                        Expanded(
                          child: Align(
                            // alignment: Alignment.topLeft,
                            child: AlignedGridView.count(
                              padding: EdgeInsets.all(0),
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
                                      padding: EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                        color: widget.selectedStatusFilter
                                                .contains(bookingStatus)
                                            ? Colors.grey
                                            : Colors.transparent,
                                        border:
                                            Border.all(color: Colors.black)),
                                    child: Row(
                                      children: [
                                        Expanded(child: Text(bookingStatus)),
                                        if (widget.selectedStatusFilter
                                            .contains(bookingStatus))
                                          const Align(
                                            alignment: Alignment.centerRight,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: CircleAvatar(
                                                radius: 12,
                                                child: Icon(Icons.check),
                                              ),
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
                      SizedBox(
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

  int _pageSize = 5;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bookingProvider = context.read<BookingProvider>();
    widget.pagingController.addPageRequestListener((pageKey) async {
      try {
        print("SELTECTED SERVICE ${widget.selectedServiceFilter}");
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
        widget.pagingController.error = e;
      }
    });
  }



  @override
  Widget build(BuildContext context) {
    print(context.read<AuthenticateProvider>().token!);
    return SliverPadding(
      padding: EdgeInsets.all(16),
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
              return Center(
                child: Text("Somethings went wrong!"),
              );
            },
            newPageErrorIndicatorBuilder: (context) {
              return Center(
                child: Text("Somethings went wrong!"),
              );
            },
            newPageProgressIndicatorBuilder: (context) {
              return Container(
                child: Center(
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
              return GestureDetector(
                onTap: () => {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) {
                      return BookingDetailPage(
                        bookingDetail: booking,
                      );
                    },
                  ))
                },
                child: Container(
                  margin: EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    
                      borderRadius: BorderRadius.circular(15)),
                  height: 300,
                  child: Material(
                    borderRadius: BorderRadius.only(
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
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(15),
                                    topRight: Radius.circular(15),
                                  ),
                                  image: DecorationImage(
                                      image: NetworkImage(
                                        "https://dpbostudfzvnyulolxqg.supabase.co/storage/v1/object/public/datn.serviceBooking/service/ca956d2f-de3b-48e2-8ce2-e8da3a2dfc46?fbclid=IwZXh0bgNhZW0CMTAAAR3nXis-D-fHoCBcAAYdSQEoWnBAFda_fePlO-iBXxWjnmLELhz7wj5Gn4s_aem_ZmFrZWR1bW15MTZieXRlcw",
                                      ),
                                      fit: BoxFit.fill)),
                            )),
                        Expanded(
                          flex: 6,
                          child: Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
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
                                      padding: EdgeInsets.all(8),
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
                                SizedBox(
                                  width: 5,
                                ),
                                Expanded(
                                    flex: 7,
                                    child: Container(
                                      padding: EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Column(
                                        children: [
                                          Expanded(
                                              child: Row(
                                            children: [
                                              Icon(Icons.article_outlined),
                                              Row(
                                                children: [
                                                  Text(
                                                    "id: ",
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
                                              Icon(Icons.info_outline),
                                              Container(
                                                child: Text(
                                                  "service: ",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium
                                                      ?.copyWith(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                ),
                                              ),
                                              Container(
                                                width: 100,
                                                child: Text(
                                                  booking['service']['name'],
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
                                              Image(
                                                image: AssetImage(
                                                    "assets/images/social-media.png"),
                                                height: 24,
                                                width: 24,
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    "status: ",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyMedium
                                                        ?.copyWith(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                  ),
                                                  Text(booking['status']),
                                                ],
                                              )
                                            ],
                                          )),
                                          Expanded(
                                              child: Row(
                                            children: [
                                              Icon(Icons.people_outline),
                                              Row(
                                                children: [
                                                  Text(
                                                    "employee: ",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyMedium
                                                        ?.copyWith(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                  ),
                                                  Text(booking['employee']
                                                          ['firstName'] +
                                                      " " +
                                                      booking['employee']
                                                          ['lastName']),
                                                ],
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
              );
            },
          )),
    );
    //   return FutureBuilder(
    //       future: context.read<BookingProvider>().getAllBooking(
    //           token: context.read<AuthenticateProvider>().token!,
    //           limit: 5,
    //           page: page),
    //       builder: (context, snapshot) {
    //         if (snapshot.connectionState == ConnectionState.waiting) {
    //           return SliverToBoxAdapter(child: Container());
    //         }
    //         final bookings = context.read<BookingProvider>().bookingList;
    //         return SliverPadding(
    //           padding: EdgeInsets.all(16),
    //           sliver: NotificationListener<ScrollNotification>(
    //             onNotification: (notification) {
    //               print(notification);
    //               if (notification.metrics.pixels ==
    //                   notification.metrics.maxScrollExtent) {
    //                 print("page++");
    //               }
    //               return true;
    //             },
    //             child: SliverList(
    //               delegate: SliverChildBuilderDelegate(
    //                   semanticIndexCallback: (widget, localIndex) {
    //                     print(localIndex);
    //                     if (localIndex == bookings.length) {}
    //                   },
    //                   addAutomaticKeepAlives: true,
    //                   childCount: bookings.length + 1,
    //                   (context, index) {
    //                     if (index >= bookings.length) {
    //                       print("vao chua");
    //                       return Padding(
    //                         padding: EdgeInsets.zero,
    //                         child: Center(
    //                           child: CircularProgressIndicator(
    //                             color: Colors.black,
    //                           ),
    //                         ),
    //                       );
    //                     } else {
    //                       final booking = bookings[index];
    //                       final date = DateFormat("EEEE,MMM d")
    //                           .format(DateTime.parse(booking['startTime']));
    //                       final startTime = DateFormat("HH:mm")
    //                           .format(DateTime.parse(booking['startTime']));
    //                       return Container(
    //                         margin: EdgeInsets.only(bottom: 10),
    //                         decoration: BoxDecoration(
    //                             color: Colors.white,
    //                             borderRadius: BorderRadius.circular(15)),
    //                         height: 300,
    //                         child: Material(
    //                           borderRadius: BorderRadius.only(
    //                             bottomLeft: Radius.circular(15),
    //                             bottomRight: Radius.circular(15),
    //                           ),
    //                           elevation: 1,
    //                           child: Column(
    //                             children: [
    //                               Expanded(
    //                                   flex: 4,
    //                                   child: Container(
    //                                     decoration: BoxDecoration(
    //                                         borderRadius: BorderRadius.only(
    //                                           topLeft: Radius.circular(15),
    //                                           topRight: Radius.circular(15),
    //                                         ),
    //                                         image: DecorationImage(
    //                                             image: NetworkImage(
    //                                               "https://dpbostudfzvnyulolxqg.supabase.co/storage/v1/object/public/datn.serviceBooking/service/ca956d2f-de3b-48e2-8ce2-e8da3a2dfc46?fbclid=IwZXh0bgNhZW0CMTAAAR3nXis-D-fHoCBcAAYdSQEoWnBAFda_fePlO-iBXxWjnmLELhz7wj5Gn4s_aem_ZmFrZWR1bW15MTZieXRlcw",
    //                                             ),
    //                                             fit: BoxFit.fill)),
    //                                   )),
    //                               Expanded(
    //                                 flex: 6,
    //                                 child: Container(
    //                                   padding: EdgeInsets.all(8),
    //                                   decoration: BoxDecoration(
    //                                     borderRadius: BorderRadius.only(
    //                                       bottomLeft: Radius.circular(15),
    //                                       bottomRight: Radius.circular(15),
    //                                     ),
    //                                   ),
    //                                   child: Row(
    //                                     children: [
    //                                       Expanded(
    //                                           flex: 3,
    //                                           child: Container(
    //                                             padding: EdgeInsets.all(8),
    //                                             decoration: BoxDecoration(
    //                                                 borderRadius:
    //                                                     BorderRadius.circular(15),
    //                                                 color: Colors.grey.shade200),
    //                                             child: Column(
    //                                               crossAxisAlignment:
    //                                                   CrossAxisAlignment.start,
    //                                               children: [
    //                                                 Text(
    //                                                   date,
    //                                                   style: Theme.of(context)
    //                                                       .textTheme
    //                                                       .bodyLarge
    //                                                       ?.copyWith(
    //                                                           fontWeight:
    //                                                               FontWeight
    //                                                                   .bold),
    //                                                 ),
    //                                                 Text("8:15 AM"),
    //                                               ],
    //                                             ),
    //                                           )),
    //                                       SizedBox(
    //                                         width: 5,
    //                                       ),
    //                                       Expanded(
    //                                           flex: 7,
    //                                           child: Container(
    //                                             padding: EdgeInsets.all(8),
    //                                             decoration: BoxDecoration(
    //                                               borderRadius:
    //                                                   BorderRadius.circular(15),
    //                                             ),
    //                                             child: Column(
    //                                               children: [
    //                                                 Expanded(
    //                                                     child: Row(
    //                                                   children: [
    //                                                     Icon(Icons
    //                                                         .article_outlined),
    //                                                     Row(
    //                                                       children: [
    //                                                         Text(
    //                                                           "id: ",
    //                                                           style: Theme.of(
    //                                                                   context)
    //                                                               .textTheme
    //                                                               .bodyMedium
    //                                                               ?.copyWith(
    //                                                                   fontWeight:
    //                                                                       FontWeight
    //                                                                           .bold),
    //                                                         ),
    //                                                         Text("db951a1f6430"),
    //                                                       ],
    //                                                     )
    //                                                   ],
    //                                                 )),
    //                                                 Expanded(
    //                                                     child: Row(
    //                                                   children: [
    //                                                     Icon(Icons.info_outline),
    //                                                     Row(
    //                                                       children: [
    //                                                         Text(
    //                                                           "service: ",
    //                                                           style: Theme.of(
    //                                                                   context)
    //                                                               .textTheme
    //                                                               .bodyMedium
    //                                                               ?.copyWith(
    //                                                                   fontWeight:
    //                                                                       FontWeight
    //                                                                           .bold),
    //                                                         ),
    //                                                         Text("Cat toc 123"),
    //                                                       ],
    //                                                     )
    //                                                   ],
    //                                                 )),
    //                                                 Expanded(
    //                                                     child: Row(
    //                                                   children: [
    //                                                     Image(
    //                                                       image: AssetImage(
    //                                                           "assets/images/social-media.png"),
    //                                                       height: 24,
    //                                                       width: 24,
    //                                                     ),
    //                                                     Row(
    //                                                       children: [
    //                                                         Text(
    //                                                           "status: ",
    //                                                           style: Theme.of(
    //                                                                   context)
    //                                                               .textTheme
    //                                                               .bodyMedium
    //                                                               ?.copyWith(
    //                                                                   fontWeight:
    //                                                                       FontWeight
    //                                                                           .bold),
    //                                                         ),
    //                                                         Text("paid"),
    //                                                       ],
    //                                                     )
    //                                                   ],
    //                                                 )),
    //                                                 Expanded(
    //                                                     child: Row(
    //                                                   children: [
    //                                                     Icon(
    //                                                         Icons.people_outline),
    //                                                     Row(
    //                                                       children: [
    //                                                         Text(
    //                                                           "employee: ",
    //                                                           style: Theme.of(
    //                                                                   context)
    //                                                               .textTheme
    //                                                               .bodyMedium
    //                                                               ?.copyWith(
    //                                                                   fontWeight:
    //                                                                       FontWeight
    //                                                                           .bold),
    //                                                         ),
    //                                                         Text(
    //                                                             "Nguyen Vu Khoi"),
    //                                                       ],
    //                                                     )
    //                                                   ],
    //                                                 )),
    //                                               ],
    //                                             ),
    //                                           ))
    //                                     ],
    //                                   ),
    //                                 ),
    //                               )
    //                             ],
    //                           ),
    //                         ),
    //                       );
    //                     }
    //                   }),
    //             ),
    //           ),
    //         );
    //       });
  }
}
