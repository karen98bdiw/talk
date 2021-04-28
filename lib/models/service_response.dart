class ServiceResponse {
  bool done;
  String errorText;
  dynamic data;

  ServiceResponse({this.done = false, this.errorText, this.data});
}
