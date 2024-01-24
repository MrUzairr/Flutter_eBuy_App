import '../../consts/consts.dart';
import '../../services/firestore_services.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(ProfileController());

    return bgWidget(
        child: Scaffold(
            body: StreamBuilder(
                stream: FirestoreServices.getUser(currentUser!.uid),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(redColor),
                    );
                  } else {
                    var data = snapshot.data!.docs[0];
                    return SafeArea(
                      child: Column(children: [
                        // Edit Profile Button
                        Padding(
                            padding: const EdgeInsets.all(4),
                            child: Align(
                                alignment: Alignment.topRight,
                                child: Icon(
                                  Icons.edit,
                                  color: whiteColor,
                                ))).onTap(() {
                          controller.nameController.text = data['name'];
                          Get.to(() => EditProfileScreen(
                                data: data,
                              ));
                        }),
                        // User Details Section

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              data['imageUrl'] == ''
                                  ? Image.asset(imgProfile,
                                          width: 100, fit: BoxFit.cover)
                                      .box
                                      .roundedFull
                                      .clip(Clip.antiAlias)
                                      .make()
                                  : Image.network(data['imageUrl'],
                                          width: 100, fit: BoxFit.cover)
                                      .box
                                      .roundedFull
                                      .clip(Clip.antiAlias)
                                      .make(),
                              Expanded(
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      "${data['name']}"
                                          .text
                                          .white
                                          .fontFamily(semibold)
                                          .make(),
                                      "${data['email']}".text.white.make()
                                    ]),
                              ),
                              OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                    side: BorderSide(color: whiteColor)),
                                onPressed: () async {
                                  await Get.put(AuthController())
                                      .signoutMethod(context: context);

                                  Get.offAll(() => const LoginScreen());
                                },
                                child: logout.text.white
                                    .fontFamily(semibold)
                                    .make(),
                              )
                            ],
                          ),
                        ),

                        // 10.heightBox,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            detailsCard(
                                count: "${data['cart_count']}",
                                title: "in your cart",
                                width: context.screenWidth / 3.4),
                            detailsCard(
                                count: "${data['wishlist_count']}",
                                title: "your wishlist",
                                width: context.screenWidth / 3.4),
                            detailsCard(
                                count: "${data['order_count']}",
                                title: "your orders",
                                width: context.screenWidth / 3.4),
                          ],
                        ),
                        // Button Section
                        ListView.separated(
                          shrinkWrap: true,
                          separatorBuilder: (context, index) {
                            return Divider(
                              color: lightGrey,
                            );
                          },
                          itemCount: ProfileButtonList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ListTile(
                              leading: Image.asset(
                                ProfileButtonIcons[index],
                                width: 22,
                              ),
                              title: ProfileButtonList[index]
                                  .text
                                  .color(darkFontGrey)
                                  .fontFamily(semibold)
                                  .make(),
                            );
                          },
                        )
                            .box
                            .white
                            .margin(EdgeInsets.all(12))
                            .rounded
                            .padding(const EdgeInsets.symmetric(horizontal: 16))
                            .shadowSm
                            .make()
                            .box
                            .color(redColor)
                            .make(),
                      ]),
                    );
                  }
                })));
  }
}
