import 'package:flutter/material.dart';
import 'package:mobilefinalhcmus/feature/auth/providers/auth_provider.dart';
import 'package:mobilefinalhcmus/feature/book/provider/booking_provider.dart';
import 'package:mobilefinalhcmus/feature/book/views/models/service_model.dart';
import 'package:provider/provider.dart';

class ServicePage extends StatelessWidget {
  const ServicePage({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Choose service",style: Theme.of(context).textTheme.titleLarge),
      ),
      body: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary.withAlpha(1)),
        child: FutureBuilder(
          future: context.read<BookingProvider>().getAllService(
              domain: context.read<AuthenticateProvider>().domain!),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                child: Center(
                  child: CircularProgressIndicator(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              );
            }
            final services = List<Map<String, dynamic>>.from(
                snapshot.data?.result?['services']);
            return Column(
              children: [
                Expanded(
                    flex: 9,
                    child: Container(
                      child: ListView.builder(
                        itemCount: services.length,
                        itemBuilder: (context, index) {
                          final service =
                              ServiceModel.fromJson(services[index]);

                          return Container(
                            height: 150,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.amber),
                            margin: const EdgeInsets.all(8),
                            child: Material(
                              elevation: 1,
                              borderRadius: BorderRadius.circular(15),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: NetworkImage(
                                                  (service.images?[0])!),
                                              fit: BoxFit.fill),
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(15),
                                            bottomLeft: Radius.circular(15),
                                          )),
                                    ),
                                  ),
                                  Expanded(
                                      child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: const BoxDecoration(
                                        
                                        borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(15),
                                            bottomRight: Radius.circular(15))),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              service.name!,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium
                                                  ?.copyWith(
                                                      
                                                      fontWeight:
                                                          FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.timer_outlined,
                                              
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              (service.timeService?['duration']
                                                  .toString())!,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium
                                                  ?.copyWith(
                                                      
                                                      fontWeight:
                                                          FontWeight.bold),
                                            )
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          service.description!,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(
                                                
                                              ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            alignment: Alignment.center,
                                            child: ElevatedButton(
                                                style: Theme.of(context)
                                                    .elevatedButtonTheme
                                                    .style
                                                    ?.copyWith(
                                                        ),
                                                onPressed: () {
                                                  Navigator.of(context).pop<ServiceModel>(service);
                                                },
                                                child: Text(
                                                  "Try it",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium
                                                      ?.copyWith(
                                                          ),
                                                )),
                                          ),
                                        )
                                      ],
                                    ),
                                  ))
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ))
              ],
            );
          },
        ),
      ),
    );
  }
}
