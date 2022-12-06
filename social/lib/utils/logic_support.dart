import 'package:flutter/cupertino.dart';
import 'package:social/http/models/generic_response.dart';

class LogicSupport {
  static bool isSuccessToProceed(AsyncSnapshot<GenericResponse> projectSnap) {
    return projectSnap.connectionState == ConnectionState.done &&
        projectSnap.data?.isSuccessful == true;
  }

  static bool isFailToProceed(AsyncSnapshot<GenericResponse> projectSnap) {
    return projectSnap.connectionState == ConnectionState.done &&
        projectSnap.data?.isSuccessful == false;
  }
}
