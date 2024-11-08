import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:mobilefinalhcmus/components/show_overlay.dart';
import 'package:mobilefinalhcmus/config/currency_config.dart';
import 'package:mobilefinalhcmus/enum/work_shift.dart';
import 'package:mobilefinalhcmus/feature/auth/providers/auth_provider.dart';
import 'package:mobilefinalhcmus/feature/auth/views/login_page.dart';
import 'package:mobilefinalhcmus/feature/book/provider/booking_provider.dart';
import 'package:mobilefinalhcmus/feature/book/views/models/service_model.dart';
import 'package:mobilefinalhcmus/feature/book/views/service_page/service_page.dart';

import 'package:mobilefinalhcmus/feature/book/widgets/step_process_widget.dart';
import 'package:mobilefinalhcmus/feature/service/animations/faded_animation.dart';
import 'package:mobilefinalhcmus/feature/shop/models/voucher_model.dart';
import 'package:mobilefinalhcmus/helper/cal_discount.dart';
import 'package:mobilefinalhcmus/helper/time_slot.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';

class BookingPage extends StatefulWidget {
  int selectedStep = 0;

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  ServiceModel? chosenService;
  DateTime? chosenDate;
  int selectedIndexEmployee = -1;
  String? selectedEmployee;
  String? catchErro1;
  String? catchErro2;
  Map<String, dynamic>? catchError;
  Widget? listEmployee;
  Widget? listTime;
  int selectedTime = -1;
  Map<String, dynamic>? controller;

  VoucherModel voucher = VoucherModel();
  late AuthenticateProvider authenticateProvider;
  late BookingProvider bookingProvider;
  @override
  void initState() {
    // TODO: implement initState
    authenticateProvider = context.read<AuthenticateProvider>();
    bookingProvider = context.read<BookingProvider>();
    widget.selectedStep = 0;
    catchError = {};
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (authenticateProvider.token == null) {
        final renderBox = context.findRenderObject() as RenderBox;
        final size = renderBox.size;

        controller = showOverlay(
            context: context,
            child: Container(
              alignment: Alignment.center,
              child: Container(
                  height: size.height * 0.2,
                  width: size.width * 0.5,
                  child: Material(
                    borderRadius: BorderRadius.circular(15),
                    color: Theme.of(context).colorScheme.secondary,
                    child: Column(
                      children: [
                        Expanded(
                          flex: 6,
                          child: Image(
                            image: AssetImage("assets/images/logo_0.png"),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Container(
                            alignment: Alignment.topCenter,
                            child: Text(
                              "Login to use app",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      ),
                            ),
                          ),
                        ),
                        Expanded(
                            flex: 2,
                            child: Container(
                              width: size.width / 2.5,
                              margin: EdgeInsets.only(bottom: 5),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      style: Theme.of(context).elevatedButtonTheme.style?.copyWith(

                                      ),
                                        onPressed: () {
                                          controller?['hide']();
                                        },
                                        child: Text(
                                          "No",
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleSmall
                                              ?.copyWith(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary,
                                                  fontWeight: FontWeight.bold),
                                        )),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: ElevatedButton(
                                        onPressed: () {
                                          controller?['hide']();
                                          Navigator.of(context)
                                              .pushNamed("/auth/login");
                                        },
                                        child: Text(
                                          "OK",
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleSmall
                                              ?.copyWith(
                                                  
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary,
                                                  fontWeight: FontWeight.bold),
                                        )),
                                  ),
                                ],
                              ),
                            ))
                      ],
                    ),
                  )),
            ));
        controller?['show']();
      }
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    WidgetsBinding.instance.scheduleFrameCallback((timeStamp) {
      bookingProvider.indexEmployee = null;
    });
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    if (controller != null) {
      controller?['hide']();
    }
  }

  @override
  Widget build(BuildContext context) {
    print("rebuild");

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Booking",
          style: Theme.of(context).textTheme.titleLarge,
        ),
        scrolledUnderElevation: 0,
      ),
      body: authenticateProvider.token == null
          ? Container(
              child: Center(
                child: Text("You must login to booking"),
              ),
            )
          : Container(
              decoration: BoxDecoration(color: Colors.white),
              child: FutureBuilder(
                future: Future.wait([
                  // determinePosition()
                ]),
                builder: (context, snapshot) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      StepProcessWidget(
                        selectedStep: widget.selectedStep,
                        index: 0,
                        functionA: (setActive, startTimer) {
                          return Container(
                            decoration: BoxDecoration(color: Colors.white),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "1. Choose service",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.copyWith(
                                            
                                            fontWeight: FontWeight.bold),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Colors.grey.shade200),
                                    child: GestureDetector(
                                      onTap: () async {
                                        voucher.update(VoucherModel.unknown());
                                        ServiceModel? service =
                                            await Navigator.of(context)
                                                .push(MaterialPageRoute(
                                          builder: (context) {
                                            return ServicePage(
                                              voucher: voucher,
                                            );
                                          },
                                        ));
                                        if(service != null){
                                          setState(() {
                                            widget.selectedStep = 0;
                                            listEmployee = null;
                                            listTime = null;
                                            chosenService = service;
                                            widget.selectedStep++;
                                            catchErro1 = null;
                                          });
                                        }
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Icon(Icons.home),
                                              Expanded(
                                                child: Text(
                                                  chosenService?.name ??
                                                      "See all services",
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                              Icon(Icons
                                                  .arrow_forward_ios_outlined)
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  if (catchErro1!=null)
                                  Text(
                                    catchErro1 ?? "",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(color: Colors.red),
                                  ),
                                  if(voucher.id != null && chosenService != null )
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Image(image: AssetImage("assets/images/coupon.png"), height: 32,width: 32,)),
                                      Expanded(
                                        flex: 8,
                                        child: Text(CurrencyConfig.convertTo(price: CalculateDiscount(voucher: voucher, chosenService: chosenService!)).toString(), style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                          fontWeight: FontWeight.bold
                                        ),)),
                                    ],
                                  )
                                  else if (chosenService != null)
                                  Text(CurrencyConfig.convertTo(price: (chosenService!.price)!).toString(), style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                          fontWeight: FontWeight.bold
                                        ),)
                                ]),
                          );
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      StepProcessWidget(
                        selectedStep: widget.selectedStep,
                        index: 1,
                        functionA: (setActive, startTimer) {
                          return Container(
                            decoration: BoxDecoration(color: Colors.white),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "2. Choose datetime",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(
                                          fontWeight: FontWeight.bold),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      color: Colors.grey.shade200),
                                  child: GestureDetector(
                                    onTap: () async {
                                      if (chosenService?.name == null) {
                                        setState(() {
                                          catchErro1 =
                                              "You have not selected a service yet";
                                        });
                                      } else {
                                        final startDate = DateTime.now();
                                        final endDate =
                                            startDate.add(Duration(days: 5));
                                        chosenDate = await showDatePicker(
                                            builder: (context, child) {
                                              return Theme(
                                                  data: Theme.of(context),
                                                  child: child!);
                                            },
                                            context: context,
                                            firstDate: startDate,
                                            lastDate: endDate);
                                        print(DateFormat.yMMMEd()
                                            .format(chosenDate!));
                                        setState(() {
                                          widget.selectedStep++;
                                          catchErro2 = null;
                                          listTime = null;
                                          listEmployee = null;
                                          context
                                              .read<BookingProvider>()
                                              .indexEmployee = null;
                                        });
                                      }
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Icon(Icons.home),
                                            Container(
                                              child: Expanded(
                                                child: Text(
                                                  chosenDate == null
                                                      ? "Choose time of day"
                                                      : DateFormat(
                                                              'EEEE, d MMM, yyyy')
                                                          .format(chosenDate!),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ),
                                            Icon(Icons
                                                .arrow_forward_ios_outlined)
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Text(
                                  catchErro2 ?? "",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(color: Colors.red),
                                )
                              ],
                            ),
                          );
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      StepProcessWidget(
                        selectedStep: widget.selectedStep,
                        index: 2,
                        functionA: (setActive, startTimer) {
                          return Container(
                            decoration: BoxDecoration(color: Colors.white),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "3. Choose employee",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(
                                 
                                          fontWeight: FontWeight.bold),
                                ),

                                Container(
                                  decoration: BoxDecoration(
                                      color: Colors.grey.shade200),
                                  child: GestureDetector(
                                    onTap: () async {
                                      if (chosenService == null) {
                                        setState(() {
                                          catchErro1 =
                                              "You have not selected a service yet";
                                        });
                                      } else if (chosenDate == null) {
                                        setState(() {
                                          catchErro2 =
                                              "You have not selected  date yet";
                                        });
                                      } else {
                                        await context
                                            .read<BookingProvider>()
                                            .searchForBooking(
                                                token: context
                                                    .read<
                                                        AuthenticateProvider>()
                                                    .token!,
                                                date: chosenDate!
                                                    .toIso8601String(),
                                                service: (chosenService?.id)!);

                                        final timeStartConvert = chosenService
                                            ?.timeService?['startTime']
                                            .toString()
                                            .split(":");
                                        final timeEndConvert = chosenService
                                            ?.timeService?['endTime']
                                            .toString()
                                            .split(":");
                                        final duration = chosenService
                                            ?.timeService?['duration'];
                                        final startHour = timeStartConvert?[0];
                                        final startMinute =
                                            timeStartConvert?[1];
                                        final endHour = timeEndConvert?[0];
                                        final endMinute = timeEndConvert?[1];

                                        final startTime = TimeOfDay(
                                            hour: int.parse(startHour!),
                                            minute: int.parse(startMinute!));
                                        final endTime = TimeOfDay(
                                            hour: int.parse(endHour!),
                                            minute: int.parse(endMinute!));
                                        final step =
                                            Duration(minutes: duration);

                                        final times = getTimes(
                                                startTime,
                                                endTime,
                                                step,
                                                chosenService?.timeService?[
                                                    'breakStart'],
                                                chosenService
                                                    ?.timeService?['breakEnd'])
                                            .map((tod) => tod.format(context))
                                            .toList();
                                        final result = context
                                            .read<BookingProvider>()
                                            .httpResponseFlutter
                                            .result;

                                        final slotBooking =
                                            List<Map<String, dynamic>>.from(
                                                result?['slotBookings']);

                                        print(slotBooking);
                                        print(
                                            "Slot booking: ${slotBooking.length}");
                                        print("time: ${times.length}");

                                        setState(() {
                                          listTime = ShowTimeForBooking(
                                              callback: (employee) {
                                                print("Hello");
                                                print(listEmployee);
                                                setState(() {
                                                  listEmployee =
                                                      ListView.builder(
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    itemCount: employee.length,
                                                    itemExtent: 70,
                                                    itemBuilder:
                                                        (context, index) {
                                                      final employ =
                                                          employee[index];
                                                 
                                                      return GestureDetector(
                                                        onTap: () {
                                                          print(context
                                                                  .read<
                                                                      BookingProvider>()
                                                                  .selectedIndexEmployee ==
                                                              index.toString());
                                                          setState(() {
                                                            context
                                                                    .read<
                                                                        BookingProvider>()
                                                                    .indexEmployee =
                                                                employ['id']
                                                                    .toString();
                                                          });
                                                        },
                                                        child: Container(
                                                          margin: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      2),
                                                          child: Column(
                                                            children: [
                                                              Container(
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(3),
                                                                decoration: BoxDecoration(
                                                                    color: context.watch<BookingProvider>().selectedIndexEmployee ==
                                                                            employ['id']
                                                                                .toString()
                                                                        ? Theme.of(context)
                                                                            .colorScheme
                                                                            .secondary
                                                                        : null,
                                                                    shape: BoxShape
                                                                        .circle),
                                                                child:
                                                                    CircleAvatar(
                                                                  radius: 27,
                                                                  child: Image(
                                                                      image: AssetImage(
                                                                          'assets/images/avatar.png')),
                                                                ),
                                                              ),
                                                              Expanded(
                                                                child: Text(employ[
                                                                        'firstName'] +
                                                                    " " +
                                                                    employ[
                                                                        'lastName'], maxLines: 1, overflow: TextOverflow.ellipsis,),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  );
                                                });
                                              },
                                              slotBooking: slotBooking,
                                              times: times);
                                        });
                                      }
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Icon(Icons.person_add),
                                            Expanded(
                                              child: Text(
                                                "Choose employees that you like",
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                            Icon(Icons
                                                .arrow_forward_ios_outlined)
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                //show list employee
                                SizedBox(
                                  height: 5,
                                ),
                                if (listTime != null)
                                  Container(
                                    height: 180,
                                    child: listTime,
                                  ),

                                Consumer<BookingProvider>(
                                  builder: (context, value, child) {
                                    final isLoading = value.httpResponseFlutter.isLoading;
                                    if (isLoading!){
                                      return Container(
                                        height: 110,
                                        child: Center(
                                          child: CircularProgressIndicator(
                                            color: Theme.of(context).colorScheme.secondary,
                                          ),
                                        ),
                                      );
                                    }else{
                                    return  Container(
                                    height: 90,
                                    child: listEmployee,
                                    );
                                    }
                                  },
                                ),
                                

                                if (context
                                        .read<BookingProvider>()
                                        .selectedIndexEmployee !=
                                    null)
                                  Container(
                                    alignment: Alignment.topCenter,
                                    child: ElevatedButton(
                                        onPressed: () async {
                                          print("VOUCHERRRRRRRRRRRRRRRRRRRr: ${voucher.id}");
                                          await context
                                              .read<BookingProvider>()
                                              .createBooking(
                                                  voucher: voucher.id,
                                                  token: context
                                                      .read<
                                                          AuthenticateProvider>()
                                                      .token!,
                                                  date: chosenDate.toString(),
                                                  employee: context
                                                      .read<BookingProvider>()
                                                      .selectedIndexEmployee,
                                                  service: (chosenService?.id)!,
                                                  note: "qua da pepsi oi",
                                                  startTime: context
                                                      .read<BookingProvider>()
                                                      .selectedTimeForBooking!);
                                          context
                                              .read<BookingProvider>()
                                              .flushData();
                                          final result = context
                                              .read<BookingProvider>()
                                              .httpResponseFlutter;
                                          final errorMessage = context.read<BookingProvider>().httpResponseFlutter.errorMessage;
                                          if (errorMessage != null){
                                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                              backgroundColor: Colors.red,
                                              content: Text(errorMessage, style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                                color: Colors.white
                                              ),)));
                                          }
                                          if (result.result != null) {
                                            QuickAlert.show(
                                                autoCloseDuration:
                                                    Duration(seconds: 1),
                                                context: context,
                                                text: "Booking Success",
                                                // customAsset: 'assets/images/logo_0.png',
                                                onConfirmBtnTap: () {
                                                  Navigator.of(context).pop();
                                                },
                                                widget: Column(),
                                                type: QuickAlertType.custom);
                                          }
                                        },
                                        child: Text(
                                          "BOOK",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary),
                                        )),
                                  )
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
      bottomNavigationBar: Container(
        
        child: Row(
          children: [
            Expanded(child: Text(
              ""
            )),
            Expanded(child: Text("")),
          ],
        ),
      ),
    );
    
  }
}

class ShowTimeForBooking extends StatefulWidget {
  ShowTimeForBooking(
      {super.key,
      this.listEmployee,
      this.callback,
      required this.slotBooking,
      required this.times});
  List<Map<String, dynamic>> slotBooking;
  List<String> times;
  final listEmployee;
  void Function(List<Map<String, dynamic>>)? callback;
  @override
  State<ShowTimeForBooking> createState() => _ShowTimeForBookingState();
}

class _ShowTimeForBookingState extends State<ShowTimeForBooking> {
  int selectedTime = -1;
  @override
  Widget build(BuildContext context) {
    return FadeAnimation(
      0.5,
      CustomScrollView(
        scrollDirection: Axis.horizontal,
        slivers: [
          SliverGrid.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisSpacing: 5, mainAxisSpacing: 5, crossAxisCount: 3),
            itemCount: widget.slotBooking.length,
            itemBuilder: (context, index) {
              final slot = widget.slotBooking[index];
              // print(slot);

              // final startTime = DateTime.parse(slot['startTime']);
              // final time = TimeOfDay.fromDateTime(startTime);
              // print(time);
              final employee =
                  List<Map<String, dynamic>>.from(slot['employees']);

              return GestureDetector(
                onTap: employee.length > 0
                    ? () {
                        print(selectedTime);
                        print(slot['startTime']);
                        context.read<BookingProvider>().timeForBooking =
                            slot['startTime'];

                        widget.callback!(employee);
                        setState(() {
                          selectedTime = index;
                        });
                      }
                    : null,
                child: Container(
                  decoration: BoxDecoration(
                      color: employee.length > 0
                          ? selectedTime == index
                              ? Colors.amber
                              : null
                          : Theme.of(context).colorScheme.secondary,
                      border: Border.all(
                          color: Theme.of(context).colorScheme.secondary),
                      borderRadius: BorderRadius.circular(15)),
                  child: Center(
                    child: Text(
                      widget.times[index],
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: employee.length > 0
                              ? null
                              : Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
