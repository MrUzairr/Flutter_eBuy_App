import '../../consts/consts.dart';

class ShippingInfo extends StatelessWidget {
  const ShippingInfo({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<CartController>();
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: "Shipping Info".text.fontFamily(semibold).make(),
      ),
      bottomNavigationBar: SizedBox(
        height: 60,
        child: customButton(
          color: redColor,
          title: "Continue",
          onPress: () {
            if (controller.addressController.text.length > 10) {
              Get.to(() => PaymentMethod());
            } else {
              VxToast.show(context, msg: "Please fill the form");
            }
          },
          textColor: whiteColor,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(12),
        child: Column(children: [
          customTextField(
            hint: "Address",
            isPass: false,
            title: "Address",
            controller: controller.addressController,
          ),
          customTextField(
            hint: "City",
            isPass: false,
            title: "City",
            controller: controller.cityController,
          ),
          customTextField(
            hint: "State",
            isPass: false,
            title: "State",
            controller: controller.stateController,
          ),
          customTextField(
            hint: "Postal Code",
            isPass: false,
            title: "Postal Code",
            controller: controller.postalController,
          ),
          customTextField(
            hint: "Phone",
            isPass: false,
            title: "Phone",
            controller: controller.phoneController,
          ),
        ]),
      ),
    );
  }
}
