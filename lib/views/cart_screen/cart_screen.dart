import '../../services/firestore_services.dart';

import '../../consts/consts.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(CartController());
    return Scaffold(
        bottomNavigationBar: SizedBox(
          height: 60,
          child: customButton(
            color: redColor,
            title: "Proceed to Checkout",
            onPress: () {
              Get.to(() => ShippingInfo());
            },
            textColor: whiteColor,
          ),
        ),
        backgroundColor: whiteColor,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: "Shopping Cart"
              .text
              .fontFamily(semibold)
              .color(darkFontGrey)
              .make(),
        ),
        body: StreamBuilder(
            stream: FirestoreServices.getCart(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: loadingIndicator(),
                );
              } else if (snapshot.data!.docs.isEmpty) {
                return Center(
                  child: 'Cart is empty'.text.color(darkFontGrey).make(),
                );
              } else {
                var data = snapshot.data!.docs;
                controller.calculate(data);
                controller.productSnapshot = data;
                return Padding(
                  padding: EdgeInsets.all(8),
                  child: Column(children: [
                    Expanded(
                        child: Container(
                      child: ListView.builder(
                          itemCount: data.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ListTile(
                              leading: Image.network(
                                "${data[index]['image']}",
                                width: 80,
                                fit: BoxFit.cover,
                              ),
                              title:
                                  "${data[index]['title']} (x${data[index]['quantity']})"
                                      .text
                                      .fontFamily(semibold)
                                      .size(16)
                                      .make(),
                              subtitle: "${data[index]['totalPrice']}"
                                  .numCurrency
                                  .text
                                  .color(redColor)
                                  .fontFamily(semibold)
                                  .make(),
                              trailing:
                                  const Icon(Icons.delete, color: redColor)
                                      .onTap(() {
                                FirestoreServices.deleteDocument(
                                    data[index].id);
                              }),
                            );
                          }),
                    )),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        "Total Price"
                            .text
                            .color(darkFontGrey)
                            .fontFamily(semibold)
                            .make(),
                        Obx(
                          () => "${controller.totalP.value}"
                              .numCurrency
                              .text
                              .fontFamily(semibold)
                              .color(redColor)
                              .make(),
                        ),
                      ],
                    )
                        .box
                        .padding(EdgeInsets.all(12))
                        .width(context.screenWidth - 60)
                        .color(lightGolden)
                        .roundedSM
                        .make(),
                    10.heightBox,
                    // SizedBox(
                    //   width: context.screenWidth - 60,
                    //   child: customButton(
                    //     color: redColor,
                    //     title: "Proceed to Checkout",
                    //     onPress: () {},
                    //     textColor: whiteColor,
                    //   ),
                    // )
                  ]),
                );
              }
            }));
  }
}
