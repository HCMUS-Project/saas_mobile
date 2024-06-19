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
import 'package:provider/provider.dart';

class ProfileBooking extends StatefulWidget {
  @override
  State<ProfileBooking> createState() => _ProfileBookingState();
}

class _ProfileBookingState extends State<ProfileBooking> {
  final controller = ScrollController();
  late BookingProvider bookingProvider;
  List<Map<String, dynamic>> services = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bookingProvider = context.read<BookingProvider>();
    bookingProvider.bookingList = [];
    bookingProvider.page = 1;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait([
        context.read<BookingProvider>().getAllService(domain: context.read<AuthenticateProvider>().domain!,listService: services)
      ]),
      builder:(context, snapshot) {
        
     
        return Scaffold(
        resizeToAvoidBottomInset: false,
        endDrawer: Drawer(
          child: Container(
              padding: EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                  
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Container(
                                alignment: Alignment.bottomLeft,
                                child: Text(
                                  "Services",
                                  style: Theme.of(context).textTheme.titleMedium,
                                )),
                          ),
                          Expanded(
                            flex: 9,
                              child: Align(
                            alignment: Alignment.topLeft,
                            child: AlignedGridView.count(
                              padding: EdgeInsets.all(0),
                              crossAxisCount: 2,
                              crossAxisSpacing: 4,
                              mainAxisSpacing: 4,
                              itemCount: services.length,
                              itemBuilder: (context, index) {
                                final service = services[index];
                                return Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.black
                                    )
                                  ),
                                  child: Center(
                                    child: Text(service['name']),
                                  ),
                                );
                              },
                            ),
                          ))
                        ],
                      ),
                    ),
                  )
                ],
              )),
        ),
        body:snapshot.connectionState == ConnectionState.waiting ?  CircularProgressIndicator(
          color: Colors.black,
        ):Builder(builder: (context) {
          print(services);
          return CustomScrollView(
            controller: controller,
            slivers: [
              SliverAppBar(
                automaticallyImplyLeading: false,
                pinned: true,
                actions: [
                  IconButton(
                      onPressed: () async {
                        // final rs = (await context
                        //         .read<BookingProvider>()
                        //         .getAllService(
                        //             domain: context
                        //                 .read<AuthenticateProvider>()
                        //                 .domain!))
                        //     .result;
      
                        // setState(() {
                        //   services =
                        //       List<Map<String, dynamic>>.from(rs?['services']);
                        // });
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
                            ?.copyWith(fontWeight: FontWeight.bold, fontSize: 20),
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
                          prefixIconConstraints:
                              BoxConstraints(minWidth: 32, minHeight: 32),
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
                          contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                        ),
                      ),
                    )),
              ),
              showBookingHistory()
            ],
          );
        }),
      );
      }
      
    );
  }
}

class showBookingHistory extends StatefulWidget {
  const showBookingHistory({
    super.key,
  });

  @override
  State<showBookingHistory> createState() => _showBookingHistoryState();
}

class _showBookingHistoryState extends State<showBookingHistory> {
  late BookingProvider bookingProvider;
  PagingController<int, dynamic> pagingController =
      PagingController(firstPageKey: 1, invisibleItemsThreshold: 3);
  int _pageSize = 5;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bookingProvider = context.read<BookingProvider>();
    pagingController.addPageRequestListener((pageKey) async {
      print(pageKey);
      await bookingProvider.getAllBooking(
          token: context.read<AuthenticateProvider>().token!,
          limit: 5,
          page: pageKey);
      final bookings = bookingProvider.bookingList;
      final isLastPage = bookings.length < _pageSize;
      if (isLastPage) {
        pagingController.appendLastPage(bookings);
      } else {
        final nextPageKey = pageKey + 1;
        pagingController.appendPage(bookings, nextPageKey);
      }
    });
  }

  @override
  void dispose() {
    pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(context.read<AuthenticateProvider>().token!);
    return SliverPadding(
      padding: EdgeInsets.all(16),
      sliver: PagedSliverList(
          pagingController: pagingController,
          builderDelegate: PagedChildBuilderDelegate(
            newPageProgressIndicatorBuilder: (context) {
              return Center(
                child: CircularProgressIndicator(
                  color: Colors.black,
                ),
              );
            },
            animateTransitions: true,
            // [transitionDuration] has a default value of 250 milliseconds.
            transitionDuration: const Duration(milliseconds: 500),
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
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15)),
                  height: 300,
                  child: Material(
                    borderRadius: BorderRadius.only(
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
