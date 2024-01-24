import '../../consts/consts.dart';

class PaymentMethod extends StatelessWidget {
  const PaymentMethod({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<CartController>();
    return Obx(
      () => Scaffold(
          backgroundColor: whiteColor,
          bottomNavigationBar: SizedBox(
            height: 60,
            child: controller.placeOrderLoading.value
                ? Center(
                    child: loadingIndicator(),
                  )
                : customButton(
                    color: redColor,
                    title: "Place my order",
                    onPress: () async {
                      await controller.placeMyOrder(
                          orderPaymentMethod: PaymentMethodStringList[
                              controller.paymentIndex.value],
                          totalAmount: controller.totalP.value);
                      await controller.clearCart();
                      VxToast.show(context, msg: "Order Placed Successfully");
                      Get.offAll(() => Home());
                    },
                    textColor: whiteColor,
                  ),
          ),
          appBar: AppBar(
            title: "Choose Payment Method"
                .text
                .color(darkFontGrey)
                .fontFamily(semibold)
                .make(),
          ),
          body: Padding(
            padding: EdgeInsets.all(12),
            child: Obx(
              () => Column(
                children: List.generate(PaymentMethodImgList.length, (index) {
                  return GestureDetector(
                    onTap: () {
                      controller.changePaymentIndex(index);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: controller.paymentIndex.value == index
                                ? redColor
                                : Colors.transparent,
                            width: 4,
                            style: BorderStyle.solid),
                      ),
                      margin: EdgeInsets.only(bottom: 12),
                      child: Stack(
                        alignment: Alignment.topRight,
                        children: [
                          Image.asset(
                            PaymentMethodImgList[index],
                            width: double.infinity,
                            colorBlendMode:
                                controller.paymentIndex.value == index
                                    ? BlendMode.darken
                                    : BlendMode.clear,
                            color: controller.paymentIndex.value == index
                                ? Colors.black.withOpacity(0.4)
                                : Colors.transparent,
                            height: 120,
                            fit: BoxFit.cover,
                          ),
                          controller.paymentIndex.value == index
                              ? Transform.scale(
                                  scale: 1.3,
                                  child: Checkbox(
                                      activeColor: Colors.green,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(50)),
                                      value: true,
                                      onChanged: (value) {}),
                                )
                              : Container(),
                          Positioned(
                              bottom: 10,
                              right: 10,
                              child: PaymentMethodStringList[index]
                                  .text
                                  .white
                                  .size(16)
                                  .fontFamily(bold)
                                  .make())
                        ],
                      ),
                    ).box.roundedSM.clip(Clip.antiAlias).make(),
                  );
                }),
              ),
            ),
          )),
    );
  }
}
