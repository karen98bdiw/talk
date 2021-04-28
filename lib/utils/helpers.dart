import 'package:talk/utils/enums.dart';

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
