import '../consts/consts.dart';

Widget loadingIndicator() {
  return Center(
    child: CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation(redColor),
    ),
  );
}
