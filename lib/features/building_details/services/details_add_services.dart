import 'package:benkelly864/core/models/response_data.dart';
import 'package:benkelly864/core/services/network_caller.dart';
import 'package:benkelly864/core/utils/constants/api_constants.dart';

class DetailsAddService {
  DetailsAddService({NetworkCaller? networkCaller})
      : _networkCaller = networkCaller ?? NetworkCaller();

  final NetworkCaller _networkCaller;

  Future<ResponseData> addExploreEntry({
    required Map<String, dynamic> body,
    String? token,
  }) {
    return _networkCaller.postRequest(
      ApiConstants.exploreCreate,
      body: body,
      token: token,
      headers: const {'accept': 'application/json'},
    );
  }
}
