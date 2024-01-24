import 'package:app/consts/consts.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool? isCheck = false;
  var controller = Get.put(AuthController());

  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var retypePasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return bgWidget(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Center(
          child: Column(
            children: [
              (context.screenHeight * 0.1).heightBox,
              appLogoWidget(),
              10.heightBox,
              "Join the $appname".text.fontFamily(bold).white.size(18).make(),
              15.heightBox,
              Obx(
                () => Column(
                  children: [
                    customTextField(
                      title: name,
                      hint: nameHint,
                      controller: nameController,
                      isPass: false,
                    ),
                    customTextField(
                      title: email,
                      hint: emailHint,
                      controller: emailController,
                      isPass: false,
                    ),
                    customTextField(
                      title: password,
                      hint: passwordHint,
                      controller: passwordController,
                      isPass: true,
                    ),
                    customTextField(
                      title: retyprPassword,
                      hint: passwordHint,
                      controller: retypePasswordController,
                      isPass: true,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {},
                        child: forgetPass.text.make(),
                      ),
                    ),
                    5.heightBox,
                    Row(
                      children: [
                        Checkbox(
                          activeColor: redColor,
                          checkColor: whiteColor,
                          value: isCheck,
                          onChanged: (newValue) {
                            setState(() {
                              isCheck = newValue;
                            });
                          },
                        ),
                        5.widthBox,
                        Expanded(
                          child: RichText(
                            text: const TextSpan(children: [
                              TextSpan(
                                text: "I agree to the ",
                                style: TextStyle(
                                  fontFamily: regular,
                                  color: fontGrey,
                                  fontSize: 12,
                                ),
                              ),
                              TextSpan(
                                text: termsAndCondition,
                                style: TextStyle(
                                  fontFamily: bold,
                                  color: redColor,
                                  fontSize: 12,
                                ),
                              ),
                              TextSpan(
                                text: " & ",
                                style: TextStyle(
                                  fontFamily: regular,
                                  color: fontGrey,
                                  fontSize: 12,
                                ),
                              ),
                              TextSpan(
                                text: privacyPolicy,
                                style: TextStyle(
                                  fontFamily: bold,
                                  color: redColor,
                                  fontSize: 12,
                                ),
                              ),
                            ]),
                          ),
                        ),
                      ],
                    ),
                    controller.isloading.value
                        ? const CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(redColor),
                          )
                        : customButton(
                            color: isCheck == true ? redColor : lightGrey,
                            textColor: whiteColor,
                            title: signup,
                            onPress: () async {
                              if (isCheck != false) {
                                controller.isloading(true);
                                try {
                                  await controller
                                      .signupMethod(
                                    context: context,
                                    email: emailController.text,
                                    password: passwordController.text,
                                  )
                                      .then((value) {
                                    // Insert user data into SQLite
                                    DatabaseHelper().insertUser({
                                      'name': nameController.text,
                                      'email': emailController.text,
                                      'password': passwordController.text,
                                    });
                                  }).then((value) {
                                    VxToast.show(
                                      context,
                                      msg: loginSuccessfully,
                                    );
                                    Get.offAll(() => Home());
                                  });
                                } catch (e) {
                                  auth.signOut();
                                  VxToast.show(context, msg: e.toString());
                                  controller.isloading(false);
                                }
                              }
                            },
                          ).box.width(context.screenWidth - 50).make(),
                    10.heightBox,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        alreadyHaveAccount.text.color(fontGrey).make(),
                        login.text
                            .color(redColor)
                            .fontFamily(bold)
                            .make()
                            .onTap(() {
                          Get.back();
                        }),
                      ],
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
