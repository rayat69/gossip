import 'package:flutter/widgets.dart';
import 'package:gossip/router/path.dart';

class MainRouteInfoParser extends RouteInformationParser<MainPath> {
  @override
  Future<MainPath> parseRouteInformation(
      RouteInformation routeInformation) async {
    final url = Uri.parse(routeInformation.location!);
    final pathSegments = url.pathSegments;
    if (pathSegments.length == 0) {
      return MainPath.home();
    }
    if (pathSegments.length == 1 && pathSegments.first == 'auth') {
      return MainPath.auth();
    }
    if (pathSegments.length == 2 &&
        pathSegments.first == 'chat' &&
        pathSegments.last != null) {
      return MainPath.chat(pathSegments.last);
    }
    throw UnimplementedError();
  }

  @override
  RouteInformation? restoreRouteInformation(MainPath config) {
    return RouteInformation(location: config.toString());
  }
}
