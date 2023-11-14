import 'package:http/http.dart' as http;

// void main(List<String> args) {
//   var future = http.get(Uri.parse('http://example.com'));

//   // get the content of the URL and print it
//   future.then((response) => print(response.body));

//   print('Hej Jakob');
// }

// void main(List<String> args) {
//   Future<http.Response> html = http.get(Uri.parse('http://example.com'));
//   print(html);
// }

// void main(List<String> args) async {
//   // use await to get the response
//   http.Response response = await http.get(Uri.parse('http://example.com'));
//   print(response.body);
//   print('Hej Jakob');
// }

// void main(List<String> args) {
//   var future = http.get(Uri.parse('http://example.com'));

//   // get the content of the URL and print it
//   future.then((response) => print(response.body));

//   // print the type of the future = "Future<Response>""
//   print(future.runtimeType);
// }

// void main(List<String> args) async {
//   var response = await http.get(Uri.parse('http://example.com'));
//   print(response.body);
// }

void main(List<String> args) async {
  // now let's try with a non-existing URL
  var future = http.get(Uri.parse('http://no_future.com'));

  future
      .then((response) => print(response.headers))
      .catchError((error) => print('An Error occurred in the future:  $error'))
      .whenComplete(() => print('But at least the future has arrived....'));
}

// void main(List<String> args) {
//   var future = getHtmlPage('http://example.com');

//   future
//       .then((page) => print(page))
//       .catchError((error) => print('An Error occurred in the future:  $error'))
//       .whenComplete(() => print('But at least the future has arrived....'));
// }

/// Returns the HTML content for a page at [url].
///
/// This is an example of how to create an asynchronous function that returns
/// a Future, including handling different types of errors.
Future<String> getHtmlPage(String url) async {
  try {
    var response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return response.body;
    } else {
      return Future.error(
          'An HTTP Error occurred - status: ${response.statusCode} - ${response.reasonPhrase}');
    }
  } catch (error) {
    return Future.error(error);
  }
}

// void main(List<String> args) async =>
//     print(await getHtmlPage('http://example.com'));
