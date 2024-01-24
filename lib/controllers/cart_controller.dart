import '../consts/consts.dart';

class CartController extends GetxController {
  var totalP = 0.obs;

  // text editing controller for shipping details
  var addressController = TextEditingController();
  var cityController = TextEditingController();
  var stateController = TextEditingController();
  var postalController = TextEditingController();
  var phoneController = TextEditingController();

  var paymentIndex = 0.obs;

  late dynamic productSnapshot;
  var placeOrderLoading = false.obs;
  var products = [];

  calculate(data) {
    totalP.value = 0;
    for (var i = 0; i < data.length; i++) {
      totalP.value = totalP.value + int.parse(data[i]['totalPrice'].toString());
    }
  }

  changePaymentIndex(index) {
    paymentIndex.value = index;
  }

  placeMyOrder({required orderPaymentMethod, required totalAmount}) async {
    placeOrderLoading(true);
    await getProductDetail();
    await firestore.collection(orderCollection).doc().set({
      'order_code': '2340044044',
      'order_date': FieldValue.serverTimestamp(),
      'order_by': currentUser!.uid,
      'order_by_name': Get.find<HomeController>().username,
      'order_by_email': currentUser!.email,
      'order_address': addressController.text,
      'order_city': cityController.text,
      'order_state': stateController.text,
      'order_postal': postalController.text,
      'order_phone': phoneController.text,
      'shipping_method': 'Home Delivery',
      'payment-method': orderPaymentMethod,
      'order_placed': true,
      'order_confirmed': false,
      'order_delivered': false,
      'order_on_delivery': false,
      'total_amount': totalAmount,
      'orders': FieldValue.arrayUnion(products)
    });
    placeOrderLoading(false);
  }

  getProductDetail() {
    products.clear();
    for (var i = 0; i < productSnapshot.length; i++) {
      products.add({
        'title': productSnapshot[i]['title'],
        'color': productSnapshot[i]['color'],
        'image': productSnapshot[i]['image'],
        'vendor_id': productSnapshot[i]['vendor_id'],
        'total_price': productSnapshot[i]['totalPrice'],
        'quantity': productSnapshot[i]['quantity'],
      });
    }
  }

  clearCart() {
    for (var i = 0; i < productSnapshot.length; i++) {
      firestore.collection(cartCollection).doc(productSnapshot[i].id).delete();
    }
  }
}
