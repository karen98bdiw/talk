import 'package:talk/utils/enums.dart';

var dummyUserImage =
    "https://library.kissclipart.com/20180901/krw/kissclipart-user-thumbnail-clipart-user-lorem-ipsum-is-simply-bfcb758bf53bea22.jpg";
var dummyProfileImg =
    "https://suryahospitals.com/jaipur/wp-content/uploads/sites/3/2020/07/dummy-user.jpg";
String messageStateToString(MessageState state) {
  switch (state) {
    case MessageState.Sended:
      return "Sended";
      break;
    case MessageState.Delivered:
      return "Delivered";
      break;
    case MessageState.Readed:
      return "Readed";
      break;
    default:
  }

  return null;
}

MessageState messageStateFromString(String state) {
  switch (state) {
    case "Sended":
      return MessageState.Sended;

      break;
    case "Delivered":
      return MessageState.Delivered;

      break;
    case "Readed":
      return MessageState.Readed;

      break;
    default:
  }

  return null;
}

bool isValidEmail(String email) {
  return RegExp(
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
      .hasMatch(email);
}

dynamic emailValidator(String value) {
  return value.isEmpty || !isValidEmail(value) ? "Invalid E-Main" : null;
}

dynamic passwordValidator(String value) {
  return value.isEmpty || value.length < 6
      ? "Password must contains at last 6 symbols"
      : null;
}
