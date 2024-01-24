import 'package:app/services/firestore_services.dart';

import '../../consts/consts.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: "My Orders".text.fontFamily(semibold).make(),
        ),
        body: StreamBuilder(
          stream: FirestoreServices.getAllOrders(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: loadingIndicator(),
              );
            } else if (snapshot.data!.docs.isEmpty) {
              return Center(
                child: 'No Orders'.text.color(darkFontGrey).make(),
              );
            } else {
              var data = snapshot.data!.docs;
              return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      leading: Image.network(
                        "${data[index]['orders'][0]['image']}",
                        width: 80,
                        fit: BoxFit.cover,
                      ),
                      title: "${data[index]['orders'][0]['title']}"
                          .text
                          .fontFamily(semibold)
                          .make(),
                      subtitle: "${data[index]['order_date']}"
                          .text
                          .fontFamily(semibold)
                          .make(),
                      trailing: "${data[index]['total_amount']}"
                          .text
                          .fontFamily(semibold)
                          .make(),
                    );
                  });
            }
          },
        ));
  }
}
