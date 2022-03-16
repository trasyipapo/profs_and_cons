import 'dart:async';
import 'package:http/http.dart' as http;

class ProfessorApi {
  static Future getProfessor() {
    return http
        .get(Uri.parse("https://profsandcons.000webhostapp.com/allprofs.php"));
  }
}
