import 'package:social/utils/localization_resources.dart';

class GenericResponse<T> {
  late bool isSuccessful;
  late String error;
  T? response;

  GenericResponse(this.isSuccessful, this.error, this.response);

  static GenericResponse<T> createSuccessResponse<T>(T response){
    return GenericResponse<T>(true, '', response);
  }

  static GenericResponse<T> createFailResponse<T>(String? error){
    return GenericResponse<T>(false, error ?? LocalizationResources.somethingWentWrongError, null);
  }
}
