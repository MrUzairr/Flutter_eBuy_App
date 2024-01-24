import '../../services/firestore_services.dart';

import '../../consts/consts.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(ChatController());
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: "${controller.friendName}"
            .text
            .fontFamily(semibold)
            .color(darkFontGrey)
            .make(),
      ),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: Column(children: [
          Obx(
            () => controller.isloading.value
                ? Center(
                    child: loadingIndicator(),
                  )
                : Expanded(
                    child: StreamBuilder(
                    stream: FirestoreServices.getChatMessages(
                        controller.chatDocId.toString()),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                          child: loadingIndicator(),
                        );
                      } else if (snapshot.data!.docs.isEmpty) {
                        return Center(
                          child:
                              "Send a message".text.color(darkFontGrey).make(),
                        );
                      } else {
                        return ListView(
                          children: snapshot.data!.docs
                              .mapIndexed((currentValue, index) {
                            var data = snapshot.data!.docs[index];
                            return Align(
                              alignment: data['uid'] == currentUser!.uid
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                              child: SenderBubble(data),
                            );
                          }).toList(),
                        );
                      }
                    },
                  )),
          ),
          10.heightBox,
          Row(
            children: [
              Expanded(
                  child: TextFormField(
                      controller: controller.msgController,
                      decoration: const InputDecoration(
                        hintText: "Type a message...",
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: textfieldGrey)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: textfieldGrey)),
                      ))),
              IconButton(
                  onPressed: () {
                    controller.sendMsg(controller.msgController.text);
                    controller.msgController.clear();
                  },
                  icon: Icon(
                    Icons.send,
                    color: redColor,
                  ))
            ],
          )
              .box
              .height(80)
              .padding(EdgeInsets.all(12))
              .margin(EdgeInsets.only(bottom: 8))
              .make()
        ]),
      ),
    );
  }
}
