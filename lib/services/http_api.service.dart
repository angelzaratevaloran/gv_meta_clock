class HttpApi {

  final String _url = "relojv2.valoran.mx";

  Uri getURI(String path) {
    return Uri.https(_url, "api/$path");
  }
}