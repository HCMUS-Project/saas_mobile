
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:mobilefinalhcmus/config/currency_config.dart';
import 'package:mobilefinalhcmus/feature/auth/providers/auth_provider.dart';
import 'package:mobilefinalhcmus/feature/cart/models/cart_model.dart';
import 'package:mobilefinalhcmus/feature/cart/provider/cart_provider.dart';
import 'package:mobilefinalhcmus/feature/checkout/views/checkout_page.dart';
import 'package:mobilefinalhcmus/feature/shop/models/product_model.dart';
import 'package:mobilefinalhcmus/feature/shop/provider/shop_provider.dart';
import 'package:provider/provider.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late CartProvider? cartProvider;
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    cartProvider = context.read<CartProvider>();

    print("cart init");
  }

  @override
  void dispose() {
    // TODO: implement dispose
    SchedulerBinding.instance.scheduleFrameCallback((timeStamp) {
      print("qeoqheweh");
      cartProvider?.setCartList = [];
      cartProvider?.setTotal = 0;
    });

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cartList = context.read<CartProvider>().cartList;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop(null);
            },
            icon: const Icon(
              Icons.arrow_back,
            )),
        title: Text("Cart", style: Theme.of(context).textTheme.titleLarge,),
      ),
      body: Container(
        padding: const EdgeInsets.all(8),
        decoration: const BoxDecoration(color: Colors.white),
        child: FutureBuilder(
            future: context
                .read<CartProvider>()
                .getAllItem(token: context.read<AuthenticateProvider>().token!),
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
              final result =
                  context.read<CartProvider>().httpResponseFlutter.errorMessage;

              if (result != null) {
                return Container(
                  child: const Center(
                    child: Text("No items"),
                  ),
                );
              }
              final carts = List<Map<String, dynamic>>.from(context
                  .read<CartProvider>()
                  .httpResponseFlutter
                  .result?['data']['carts']);

              final cartItems =
                  List<Map<String, dynamic>>.from(carts[0]['cartItems']);
              final cartId = carts[0]['id'];
              print("taij sao lai rebuild o day v");
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 10,
                    child: Container(
                      child: FutureBuilder(
                        future: fetchCartItems(context, cartItems, cartList,
                            size, cartId, setState),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Container();
                          }
                          return Container(
                            child: Column(
                              children: snapshot.data!,
                            ),
                          );
                        },
                      ),
                      // child: ListView.builder(
                      //   itemCount: cartItems.length,
                      //   itemBuilder: (context, index) {
                      //     final item = cartItems[index];

                      //     return CartItemWidget(
                      //         item: item,
                      //         size: size,
                      //         cartProvider: cartProvider,
                      //         cartList: cartList,
                      //         cartId: cartId);
                      //   },
                      // ),
                    ),
                  ),
                  Consumer(
                    builder: (context, value, child) {
                      final totalTemp = context.select(
                        (CartProvider value) => value.total,
                      );
                      return context.select(
                        (CartProvider value) => value.cartList.isNotEmpty,
                      )
                          ? Container(
                              child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                "Total: ${CurrencyConfig.convertTo(price: totalTemp).toString()}",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                            ))
                          : Container();
                    },
                  ),
                  Expanded(
                      flex: 1,
                      child: Consumer(
                        builder: (context, value, child) {
                          final totalTemp = context.select(
                            (CartProvider value) => value.total,
                          );
                          print("adasdsadsadsad: $totalTemp");
                          return GestureDetector(
                            onTap: context.select(
                              (CartProvider value) => value.cartList.isNotEmpty,
                            )
                                ? () {
                                    final selectedListTemp =
                                        context.read<CartProvider>().cartList;

                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) {
                                        return CheckOutPage(
                                          cartID: cartId as String,
                                          products: selectedListTemp,
                                          total: totalTemp,
                                        );
                                      },
                                    ));
                                  }
                                : null,
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: context.select(
                                    (CartProvider value) =>
                                        value.cartList.isNotEmpty,
                                  )
                                      ? Theme.of(context).colorScheme.secondary
                                      : Colors.grey),
                              child: Text(
                                "CHECK OUT",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
                                        ),
                              ),
                            ),
                          );
                        },
                      ))
                ],
              );
            }),
      ),
    );
  }

  Future<List<Widget>> fetchCartItems(
      BuildContext context,
      List<Map<String, dynamic>> cartItems,
      List<CartModel> cartList,
      Size size,
      String cartId,
      void Function(void Function()) setState) async {
    List<Widget> data = [];

    for (int i = 0; i < cartItems.length; i++) {
      final item = cartItems[i];
      final rs = await context.read<ShopProvider>().findProduct(
            domain: context.read<AuthenticateProvider>().domain!,
            productId: item['productId'],
          );
      final result = rs.result?['data'];

      final cartItem = CartModel.fromJson({
        "product": ProductModel.fromJson(result),
        "quantity": item['quantity']
      });

      data.add(CartItemWidget(
        cartItem: cartItem,
        cartId: cartId,
        cartList: cartList,
        cartProvider: cartProvider,
        item: item,
        size: size,
        setState: setState,
      ));
    }
    return data;
  }
}

class CartItemWidget extends StatefulWidget {
  const CartItemWidget(
      {super.key,
      required this.item,
      required this.size,
      required this.cartProvider,
      required this.cartList,
      required this.cartId,
      required this.cartItem,
      required this.setState});

  final Map<String, dynamic> item;
  final Size size;
  final CartProvider? cartProvider;
  final List<CartModel> cartList;
  final String cartId;
  final CartModel cartItem;
  final void Function(void Function()) setState;
  @override
  State<CartItemWidget> createState() => _CartItemWidgetState();
}

class _CartItemWidgetState extends State<CartItemWidget>
    with TickerProviderStateMixin {
  late SlidableController slidableController;
  bool isToggle = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    slidableController = SlidableController(this);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    slidableController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final isClosed = Slidable.of(context)!.actionPaneType.value == ActionPaneType.none;
    int quantityChange = widget.cartItem.quantity;

    return StatefulBuilder(
      builder: (context, setState2) => SizedBox(
        height: widget.size.width / 3,
        child: Slidable(
          enabled: true,
          controller: slidableController,
          endActionPane: ActionPane(
              extentRatio: 0.4,
              motion: const ScrollMotion(),
              children: [
                SlidableAction(
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  foregroundColor: Theme.of(context).colorScheme.primary,
                  icon: Icons.delete,
                  onPressed: (context)async {
                    await context.read<CartProvider>().updateCart(
                            token: context.read<AuthenticateProvider>().token!,
                            cartId: widget.cartId,
                            quantity: 0,
                            productId: widget.cartItem.product.id!);
                    widget.setState(
                      () {
                        
                      },
                    );
                  },
                ),
              ]),
          child: Row(
            children: [
              Expanded(
                  flex: 1,
                  child: Checkbox(
                    activeColor: Theme.of(context).colorScheme.secondary,
                    onChanged: (value) {
                      setState2(() {
                        if (value!) {
                          widget.cartProvider?.updateCheckout(
                              item: widget.cartItem, typeFlag: "ADD_ITEM");
                          // cartList.add(cartItem);
                        } else {
                          widget.cartProvider?.updateCheckout(
                              item: widget.cartItem, typeFlag: "REMOVE_ITEM");
                        }
                      });
                    },
                    shape: const BeveledRectangleBorder(side: BorderSide(width: 1)),
                    value: widget.cartList
                        .where((element) =>
                            element.product.id == widget.cartItem.product.id)
                        .isNotEmpty,
                  )),
              Expanded(
                  flex: 3,
                  child: Container(
                    height: widget.size.width * 0.3,
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(
                                (widget.cartItem.product.image![0])),
                            fit: BoxFit.fill)),
                  )),
              Expanded(
                  flex: 6,
                  child: Container(
                    child: Row(
                      children: [
                        Expanded(
                            flex: 7,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Align(
                                  alignment: Alignment.center,
                                  child: Text(widget.cartItem.product.name!),
                                ),
                                // Row(
                                //   mainAxisAlignment:
                                //       MainAxisAlignment
                                //           .spaceAround,
                                //   children: [
                                //     Text(
                                //         "Color: Black"),
                                //     Text("Size: L")
                                //   ],
                                // ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            shape: const CircleBorder(),
                                            minimumSize: const Size(36, 36),
                                            backgroundColor: Colors.white),
                                        onPressed: () async {
                                          await context
                                              .read<CartProvider>()
                                              .updateCart(
                                                  token: context
                                                      .read<
                                                          AuthenticateProvider>()
                                                      .token!,
                                                  cartId: widget.cartId,
                                                  quantity: quantityChange - 1,
                                                  productId: widget
                                                      .cartItem.product.id!);
                                          final result = context
                                              .read<CartProvider>()
                                              .httpResponseFlutter
                                              .result;
                                          if (result == null) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                                    duration: const Duration(
                                                        milliseconds: 100),
                                                    content: Text(context
                                                        .read<CartProvider>()
                                                        .httpResponseFlutter
                                                        .errorMessage!)));
                                          } else {
                                            setState2(
                                              () {
                                                quantityChange =
                                                    quantityChange - 1;
                                                widget.cartItem.quantity =
                                                    quantityChange;
                                                if (widget
                                                    .cartProvider!.cartList
                                                    .where((element) =>
                                                        element.product.id ==
                                                        widget.cartItem.product
                                                            .id)
                                                    .isNotEmpty) {
                                                  widget.cartProvider
                                                      ?.setTotal = widget
                                                          .cartProvider!.total -
                                                      widget.cartItem.product
                                                          .price!;
                                                }
                                              },
                                            );
                                          }
                                        },
                                        child: const Icon(
                                          Icons.remove,
                                          color: Colors.black,
                                        )),
                                    Text(
                                      quantityChange.toString(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge
                                          ?.copyWith(
                                              fontWeight: FontWeight.bold),
                                    ),
                                    ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            shape: const CircleBorder(),
                                            minimumSize: const Size(36, 36),
                                            backgroundColor: Colors.white),
                                        onPressed: () async {
                                          await context
                                              .read<CartProvider>()
                                              .updateCart(
                                                  token: context
                                                      .read<
                                                          AuthenticateProvider>()
                                                      .token!,
                                                  cartId: widget.cartId,
                                                  quantity: quantityChange + 1,
                                                  productId: widget
                                                      .cartItem.product.id!);
                                          final result = context
                                              .read<CartProvider>()
                                              .httpResponseFlutter
                                              .result;
                                          if (result == null) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                                    duration: const Duration(
                                                        milliseconds: 100),
                                                    content: Text(context
                                                        .read<CartProvider>()
                                                        .httpResponseFlutter
                                                        .errorMessage!)));
                                          } else {
                                            setState2(() {
                                              quantityChange =
                                                  quantityChange + 1;
                                              widget.cartItem.quantity =
                                                  quantityChange;
                                              if (widget.cartProvider!.cartList
                                                  .where((element) =>
                                                      element.product.id ==
                                                      widget
                                                          .cartItem.product.id)
                                                  .isNotEmpty) {
                                                widget.cartProvider?.setTotal =
                                                    widget.cartProvider!.total +
                                                        widget.cartItem.product
                                                            .price!;
                                              }
                                            });
                                          }
                                        },
                                        child: const Icon(
                                          Icons.add,
                                          color: Colors.black,
                                        )),
                                  ],
                                )
                              ],
                            )),
                        Expanded(
                            flex: 3,
                            child: Container(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: IconButton(
                                        onPressed: () async {
                                          final isClose = slidableController
                                                  .actionPaneType.value ==
                                              ActionPaneType.none;
                                          if (isClose) {
                                            await slidableController
                                                .openEndActionPane(
                                                    curve: Curves.linear,
                                                    duration:
                                                        Durations.medium1);
                                          } else {
                                            await slidableController.close(
                                                duration: Durations.medium1);
                                          }
                                        },
                                        icon: const Icon(Icons.more_vert)),
                                  ),
                                  Expanded(
                                      flex: 8,
                                      child: Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                            CurrencyConfig.convertTo(
                                                    price: widget.cartItem
                                                            .product.price! *
                                                        quantityChange)
                                                .toString(),
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall,
                                          )))
                                ],
                              ),
                            ))
                      ],
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
