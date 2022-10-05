import '../widgets/fetch_tmdb.dart';

Future fetchActors(int page) async {
  const String apiUrlRoot = "https://api.themoviedb.org/3/person/popular?";
  const String apiUrlKey = "api_key=e7012f0ede42eedde18f502522c6f94e";
  const String apiUrlPage = "&language=en-US&page=";

  final actors =
  await fetchJson(apiUrlRoot + apiUrlKey + apiUrlPage + page.toString());
  return actors["results"];
}