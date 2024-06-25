import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobilefinalhcmus/feature/auth/providers/auth_provider.dart';
import 'package:mobilefinalhcmus/feature/tenant/models/tenants_model.dart';
import 'package:provider/provider.dart';

List<TenantModel> tenantList = [
  TenantModel(
      domain: "30shine.com",
      name: "30Shine",
      imageUrl:
          "https://30shine.com/static/media/logo_30shine_new.7135aeb8.png"),
  TenantModel(
      domain: "hcmussaas.com",
      name: "Saas",
      imageUrl: "https://cdn-icons-png.flaticon.com/512/1363/1363376.png")
];

class TenantPage extends StatelessWidget {
  const TenantPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        
        // backgroundColor: Color(0xFF161D3A),
        scrolledUnderElevation: 0,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            padding: const EdgeInsets.all(8),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Apps",
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: constraints.maxWidth / 1.5,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 2,
                          itemBuilder: (context, index) {
                            final tenant = tenantList[index];
                            return SizedBox(
                              width: constraints.maxWidth / 2,
                              child: Card(
                                elevation: 1,
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15)),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        tenant.name!,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge
                                            ?.copyWith(
                                                fontWeight: FontWeight.bold),
                                      ),
                                      Image.network(
                                        tenant.imageUrl!,
                                        height: 100,
                                      ),
                                      ElevatedButton(
                                          // style: ElevatedButton.styleFrom(
                                          //   backgroundColor:Theme.of(context).buttonTheme.colorScheme?.background,
                                          //   shape: RoundedRectangleBorder(
                                          //     borderRadius: BorderRadius.circular(10)
                                          //   ),
                                          //   fixedSize: Size(150, 40)
                                          // ),
                                          onPressed: () {
                                            context
                                                .read<AuthenticateProvider>()
                                                .setDomain = tenant.domain!;
                                            Navigator.of(context)
                                                .pushNamed('/auth/login',arguments: tenant.domain);
                                          },
                                          child: Container(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  "Go",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium
                                                      ?.copyWith(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                const Icon(
                                                  Icons.arrow_forward,
                                                  color: Colors.white,
                                                )
                                              ],
                                            ),
                                          ))
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 40,
                    alignment: Alignment.center,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: const Color(0xFF161D3A)),
                    child: Text(
                      "WELCOME TO SAASHCMUS",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(0),
                    child: Container(
                      alignment: Alignment.center,
                      height: constraints.maxWidth / 2.5,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 3,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15)),
                            width: constraints.maxWidth * 0.7,
                            child: Material(
                              borderRadius: BorderRadius.circular(15),
                              elevation: 1,
                              child: SvgPicture.asset(
                                  'assets/icons/tenant_banner.svg'),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                      height: constraints.maxWidth / 3,
                      width: double.infinity,
                      child: Row(
                        children: [
                          Expanded(
                            child: Card(
                    
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                   ),
                                child: const Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Image(
                                        width: 56,
                                        height: 56,
                                        image: AssetImage(
                                            'assets/images/instagram.png')),
                                    Text("Instagram")
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Card(
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: const Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Image(
                                        width: 56,
                                        height: 56,
                                        image: AssetImage(
                                            'assets/images/facebook.png')),
                                    Text("Facebook")
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Card(
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: const Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Image(
                                        width: 56,
                                        height: 56,
                                        image: AssetImage(
                                            'assets/images/add-friend.png')),
                                    Text("Refer a friend")
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ))
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
