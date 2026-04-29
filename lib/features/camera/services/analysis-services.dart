import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import '../../../core/models/response_data.dart';
import '../../../core/services/network_caller.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/utils/constants/api_constants.dart';

class AnalysisService {
  AnalysisService({NetworkCaller? networkCaller})
      : _networkCaller = networkCaller ?? NetworkCaller();

  final NetworkCaller _networkCaller;

  Future<ResponseData> detectLandmark({required String imagePath}) async {
    final mediaType = _mediaTypeForPath(imagePath);
    if (mediaType == null) {
      return ResponseData(
        isSuccess: false,
        statusCode: 415,
        errorMessage: 'Only JPEG, PNG, and WebP images are supported',
        responseData: '',
      );
    }
    final imageFile = await http.MultipartFile.fromPath(
      'image',
      imagePath,
      contentType: mediaType,
    );
    return _networkCaller.multipartRequest(
      ApiConstants.landmarkDetect,
      headers: const {'accept': 'application/json'},
      files: [imageFile],
      token: StorageService.token != null ? 'Bearer ${StorageService.token}' : null,
      timeoutSeconds: 60,
    );
  }

  MediaType? _mediaTypeForPath(String path) {
    final extension = path.split('.').last.toLowerCase();
    switch (extension) {
      case 'jpg':
      case 'jpeg':
        return MediaType('image', 'jpeg');
      case 'png':
        return MediaType('image', 'png');
      case 'webp':
        return MediaType('image', 'webp');
      default:
        return null;
    }
  }
}
