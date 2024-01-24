import 'package:app/services/firestore_services.dart';

import '../../consts/consts.dart';

class CategoryDetails extends StatelessWidget {
  final String? title;
  const CategoryDetails({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<ProductController>();
    return bgWidget(
        child: Scaffold(
            appBar: AppBar(
              title: title!.text.fontFamily(bold).white.make(),
            ),
            body: StreamBuilder(
              stream: FirestoreServices.getProduct(title),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: loadingIndicator(),
                  );
                } else if (snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: 'No Products Found!'.text.color(darkFontGrey).make(),
                  );
                } else {
                  var data = snapshot.data!.docs;
                  return Container(
                    padding: EdgeInsets.all(12),
                    child: Column(children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        child: Row(
                          children: List.generate(
                              controller.subcat.length,
                              (index) => "${controller.subcat[index]}"
                                  .text
                                  .size(12)
                                  .fontFamily(semibold)
                                  .color(darkFontGrey)
                                  .makeCentered()
                                  .box
                                  .white
                                  .rounded
                                  .size(120, 60)
                                  .margin(EdgeInsets.symmetric(horizontal: 4))
                                  .make()),
                        ),
                      ),

                      // items Container
                      20.heightBox,
                      Expanded(
                        child: GridView.builder(
                            physics: const BouncingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: data.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    mainAxisExtent: 250,
                                    mainAxisSpacing: 8,
                                    crossAxisSpacing: 8),
                            itemBuilder: (context, index) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Image.network(
                                    data[index]['p_imgs'][0],
                                    width: 200,
                                    height: 160,
                                    fit: BoxFit.cover,
                                  ),
                                  10.heightBox,
                                  "${data[index]['p_name']}"
                                      .text
                                      .fontFamily(semibold)
                                      .color(darkFontGrey)
                                      .make(),
                                  10.heightBox,
                                  "${data[index]['p_price']}"
                                      .numCurrency
                                      .text
                                      .color(redColor)
                                      .fontFamily(semibold)
                                      .size(16)
                                      .make(),
                                  10.heightBox
                                ],
                              )
                                  .box
                                  .white
                                  .margin(
                                      const EdgeInsets.symmetric(horizontal: 4))
                                  .roundedSM
                                  .outerShadowSm
                                  .padding(const EdgeInsets.all(8))
                                  .make()
                                  .onTap(() {
                                controller.checkIfFav(data[index]);
                                Get.to(() => ItemDetails(
                                      title: "${data[index]['p_name']}",
                                      data: data[index],
                                    ));
                              });
                            }),
                      )
                    ]),
                  );
                }
              },
            )));
  }
}
