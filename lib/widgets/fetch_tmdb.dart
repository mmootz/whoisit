import 'dart:convert';
import 'package:http/http.dart' as http;

fetchJson(String url) async {
   final response = await http.get(Uri.parse(url));

     if (response.statusCode == 200) {
     // If the server did return a 200 OK response,
     // then parse the JSON.
        final Map<String, dynamic> jsonarray = jsonDecode(response.body);

        return jsonarray;
        } else {
     // If the server did not return a 200 OK response,
     // then throw an exception.
        throw Exception('Failed to load album');
  }
}

