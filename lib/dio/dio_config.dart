import 'package:agenda/dio/utilities.dart';
import 'package:dio/dio.dart';

class DioConfig {
  static Dio getDio() {
    return Dio(
      BaseOptions(
        baseUrl: Utilities.classesUrl,
        headers: {
          'X-Parse-Application-Id': 'o4hycDF1uorSATkt2kg48vaMIdm87xFKlytEVUXO',
          'X-Parse-REST-API-Key': 'nYmABbSUyKFdNhHEkJhg7G74jWCMBoe44iJn6Bdk',
          'Content-Type': 'application/json'
        },
      ),
    );
  }
}
