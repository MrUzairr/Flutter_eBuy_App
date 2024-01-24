import 'package:app/consts/consts.dart';

class AuthController extends GetxController {
  var isloading = false.obs;
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  Future<UserCredential?> loginMethod({context}) async {
    UserCredential? userCredential;
    try {
      userCredential = await auth.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
    } on FirebaseAuthException catch (e) {
      VxToast.show(context, msg: e.message.toString());
    }
    return userCredential;
  }

  Future<UserCredential?> signupMethod({email, password, context}) async {
    UserCredential? userCredential;
    try {
      userCredential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      // Store user data locally in SQLite
      await DatabaseHelper().insertUser({
        'name': email.split('@')[0], // Set a default name using the email
        'email': email,
        'password': password,
      });
    } on FirebaseAuthException catch (e) {
      VxToast.show(context, msg: e.message.toString());
    }
    return userCredential;
  }

  storeUserData({name, email, password}) async {
    DocumentReference store =
        await firestore.collection(userCollection).doc(currentUser!.uid);
    store.set({
      'name': name,
      'email': email,
      'password': password,
      'imageUrl': '',
      'id': currentUser!.uid,
      'cart_count': '00',
      'order_count': '00',
      'wishlist_count': '00',
    });
  }

  signoutMethod({context}) async {
    try {
      await auth.signOut();
    } catch (e) {
      VxToast.show(context, msg: e.toString());
    }
  }
}
