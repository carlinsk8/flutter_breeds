import '../../../../core/api/api_auth_client.dart';

import '../../../../core/config/env.dart';
import '../../../../core/models/response_model.dart';

abstract class BreedsDataSources {
  Future<ResponseModel> getBreeds({
    required String limit,
    required String page,
  });
  Future<ResponseModel> getImagesBreeds(
      {required String limit,
      required String page,
      required List<String> breedIds,
      required String order});
  Future<ResponseModel> getImageById(String id);
}

class BreedsDataSourcesImpl extends BreedsDataSources {
  final ApiAuthClient apiAuthClient;

  static String baseApiUrl = Env.apiUrl;

  BreedsDataSourcesImpl({
    required this.apiAuthClient,
  });

  @override
  Future<ResponseModel> getBreeds(
      {required String limit, required String page}) async {
    final queryParameters = {
      'attach_image': '1',
      'order': 'ASC',
    };
    final response = await apiAuthClient.getUri('$baseApiUrl/v1/breeds',
        queryParameters: queryParameters);

    final body = ResponseModel.fromJson(response.data);

    return body;
  }

  @override
  Future<ResponseModel> getImageById(String id) async {
    final response = await apiAuthClient.getUri('$baseApiUrl/v1/images/$id');

    final body = ResponseModel.fromJson(response.data);

    return body;
  }

  @override
  Future<ResponseModel> getImagesBreeds(
      {required String limit,
      required String page,
      required List<String> breedIds,
      required String order}) async {
    final queryParameters = {
      'limit': limit,
      'page': page,
      'size': 'small',
      'has_breeds': '1',
      if (breedIds.isNotEmpty) 'breed_ids': breedIds,
      'order': 'ASC',
    };
    final response = await apiAuthClient.getUri('$baseApiUrl/v1/images/search',
        queryParameters: queryParameters);

    final body = ResponseModel.fromJson(response.data);

    return body;
  }
}
