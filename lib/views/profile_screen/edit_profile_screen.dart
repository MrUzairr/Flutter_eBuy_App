import 'dart:io';

import 'package:app/consts/consts.dart';
import 'package:app/controllers/profile_controller.dart';

class EditProfileScreen extends StatelessWidget {
  final dynamic data;

  const EditProfileScreen({Key? key, this.data}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var controller = Get.find<ProfileController>();

    return bgWidget(
      child: Scaffold(
          appBar: AppBar(),
          body: Obx(
            () => Column(mainAxisSize: MainAxisSize.min, children: [
              // if data image url and controller path is empty
              data['imageUrl'] == '' && controller.profileImage.isEmpty
                  ? Image.asset(imgProfile, width: 100, fit: BoxFit.cover)
                      .box
                      .roundedFull
                      .clip(Clip.antiAlias)
                      .make()

                  // if data image url is not empty but controller path is empty
                  : data['imageUrl'] != '' && controller.profileImage.isEmpty
                      ? Image.network(data['imageUrl'],
                              width: 100, fit: BoxFit.cover)
                          .box
                          .roundedFull
                          .clip(Clip.antiAlias)
                          .make()
                      // else if data image url is empty but controller path is not empty
                      : Image.file(File(controller.profileImage.value),
                              width: 100, fit: BoxFit.cover)
                          .box
                          .roundedFull
                          .clip(Clip.antiAlias)
                          .make(),
              10.heightBox,
              customButton(
                  color: redColor,
                  onPress: () {
                    controller.changeImage(context);
                  },
                  textColor: whiteColor,
                  title: "Change"),
              Divider(),
              20.heightBox,
              customTextField(
                controller: controller.nameController,
                hint: nameHint,
                title: name,
                isPass: false,
              ),
              10.heightBox,
              customTextField(
                controller: controller.oldpasswordController,
                hint: passwordHint,
                title: oldPass,
                isPass: true,
              ),
              10.heightBox,
              customTextField(
                controller: controller.newpasswordController,
                hint: passwordHint,
                title: newPass,
                isPass: true,
              ),
              20.heightBox,
              controller.isloading.value
                  ? CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(redColor),
                    )
                  : SizedBox(
                      width: context.screenWidth - 60,
                      child: customButton(
                          color: redColor,
                          onPress: () async {
                            controller.isloading(true);

                            // if image is not selected
                            if (controller.profileImage.value.isNotEmpty) {
                              await controller.uploadProfileImage();
                              VxToast.show(context, msg: "Image Selected");
                            } else {
                              controller.profileImageLink = data['imageUrl'];
                              VxToast.show(context, msg: "Not Image Selected");
                            }

                            // if old password matched with database
                            if (data['password'] ==
                                controller.oldpasswordController.value.text) {
                              controller.changeAuthPassword(
                                  email: data['email'],
                                  password:
                                      controller.oldpasswordController.text,
                                  newpassword:
                                      controller.newpasswordController.text);
                              await controller.updateProfile(
                                  imgUrl: controller.profileImageLink,
                                  name: controller.nameController.text,
                                  password:
                                      controller.newpasswordController.text);
                              VxToast.show(context, msg: "Updated");
                            } else {
                              VxToast.show(context, msg: "Wrong Old Password");
                              controller.isloading(false);
                            }
                          },
                          textColor: whiteColor,
                          title: "Save"),
                    ),
            ])
                .box
                .shadowSm
                .white
                .padding(EdgeInsets.all(16))
                .margin(EdgeInsets.only(top: 50, left: 12, right: 12))
                .rounded
                .make(),
          )),
    );
  }
}
