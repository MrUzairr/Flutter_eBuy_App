import '../consts/consts.dart';

class ChatController extends GetxController {
  @override
  void onInit() {
    getChatId();
    super.onInit();
  }

  var chat = firestore.collection(chatCollection);

  var friendName = Get.arguments[0];
  var friendId = Get.arguments[1];

  var senderName = Get.find<HomeController>().username;
  var senderId = currentUser!.uid;

  var isloading = false.obs;
  var msgController = TextEditingController();
  dynamic chatDocId;

  getChatId() async {
    isloading(true);
    await chat
        .where('users', isEqualTo: {friendId: null, senderId: null})
        .limit(1)
        .get()
        .then((QuerySnapshot snapshot) {
          if (snapshot.docs.isNotEmpty) {
            chatDocId = snapshot.docs.single.id;
          } else {
            chat.add({
              'last_msg': '',
              'created_on': null,
              'users': {friendId: null, senderId: null},
              'to_id': '',
              'from_id': '',
              'friend_name': friendName,
              'sender_name': senderName
            }).then((value) {
              {
                chatDocId = value.id;
              }
            });
          }
        });
    isloading(false);
  }

  sendMsg(String msg) async {
    if (msg.trim().isNotEmpty) {
      chat.doc(chatDocId).update({
        'created_on': FieldValue.serverTimestamp(),
        'last_msg': msg,
        'to_id': friendId,
        'from_id': senderId,
      });

      chat.doc(chatDocId).collection(messageCollection).doc().set({
        'created_on': FieldValue.serverTimestamp(),
        'msg': msg,
        'uid': senderId
      });
    }
  }
}
