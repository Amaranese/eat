import '../consts/consts.dart';

Widget customButton({String? title, onPress, color, textcolor}) {
  return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.all(12),
      ),
      onPressed: onPress,
      child: Text(
        title!,
        style: TextStyle(color: textcolor, fontFamily: bold),
      ));
}
