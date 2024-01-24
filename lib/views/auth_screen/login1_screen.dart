import 'package:app/consts/consts.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(AuthController());

    return bgWidget(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Center(
          child: Column(
            children: [
              (context.screenHeight * 0.1).heightBox,
              appLogoWidget(),
              10.heightBox,
              "Log in to $appname".text.fontFamily(bold).white.size(18).make(),
              15.heightBox,
              Obx(
                () => Column(
                  children: [
                    customTextField(
                      title: email,
                      hint: emailHint,
                      isPass: false,
                      controller: controller.emailController,
                    ),
                    customTextField(
                      title: password,
                      hint: passwordHint,
                      isPass: true,
                      controller: controller.passwordController,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {},
                        child: forgetPass.text.make(),
                      ),
                    ),
                    5.heightBox,
                    controller.isloading.value
                        ? const CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(redColor),
                          )
                        : customButton(
                            color: redColor,
                            textColor: whiteColor,
                            title: login,
                            onPress: () async {
                              controller.isloading(true);
                              await controller
                                  .loginMethod(context: context)
                                  .then(
                                (value) async {
                                  if (value != null) {
                                    // Store login status using shared_preferences
                                    final prefs =
                                        await SharedPreferences.getInstance();
                                    prefs.setBool('isLoggedIn', true);

                                    // Insert user data into SQLite
                                    await DatabaseHelper().insertUser({
                                      'email': controller.emailController.text,
                                      'password':
                                          controller.passwordController.text,
                                    });

                                    VxToast.show(context,
                                        msg: loginSuccessfully);
                                    Get.offAll(() => const Home());
                                  } else {
                                    controller.isloading(false);
                                  }
                                },
                              );
                            },
                          ).box.width(context.screenWidth - 50).make(),
                    5.heightBox,
                    createNewAccount.text.color(fontGrey).make(),
                    5.heightBox,
                    customButton(
                      color: lightGolden,
                      textColor: redColor,
                      title: signup,
                      onPress: () {
                        Get.to(() => const SignupScreen());
                      },
                    ).box.width(context.screenWidth - 50).make(),
                    10.heightBox,
                    loginWith.text.color(fontGrey).make(),
                    5.heightBox,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        3,
                        (index) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CircleAvatar(
                            backgroundColor: lightGrey,
                            radius: 25,
                            child: Image.asset(
                              iconList[index],
                              width: 30,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
                  .box
                  .white
                  .rounded
                  .padding(const EdgeInsets.all(16))
                  .width(context.screenWidth - 70)
                  .shadowSm
                  .make(),
            ],
          ),
        ),
      ),
    );
  }
}
