library interview_router;

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

typedef RouteBuilder = Widget Function(
  BuildContext context,
);

class InterviewRoute {
  InterviewRoute({required this.path, required this.routeBuilder});

  final String path;
  final RouteBuilder routeBuilder;

  Uri get uri => Uri.parse(path);
}

class InterviewRouter implements RouterConfig<List<InterviewRoute>> {
  InterviewRouter({
    required this.initialLocation,
  }) {
    final key = GlobalKey<NavigatorState>();
    routerDelegate = InterviewRouterDelegate(
      initialLocation: initialLocation,
      navigatorKey: key,
    );
    backButtonDispatcher = RootBackButtonDispatcher();
    routeInformationParser = InterviewInformationParser();
    routeInformationProvider = InterviewInformationProvider(
      initial: initialLocation,
    );
  }

  final InterviewRoute initialLocation;

  @override
  late final BackButtonDispatcher backButtonDispatcher;

  /// The router delegate. Provide this to the MaterialApp or CupertinoApp's
  /// `.router()` constructor
  @override
  late final InterviewRouterDelegate routerDelegate;

  @override
  late final InterviewInformationParser routeInformationParser;

  @override
  late final InterviewInformationProvider routeInformationProvider;

  /// Navigate to a new location.
  ///
  /// If [replace] is set, the current location will be replaced with [to].
  void navigate({
    required InterviewRoute to,
    required InterviewRoute from,
  }) {
    final currentStack = routerDelegate.currentConfiguration;

    return routeInformationProvider.navigate(
      to,
      current: currentStack,
    );
  }

  /// Pop the top-most route off the current screen.
  ///
  /// If the top-most route is a pop up or dialog, this method pops it instead
  /// of any route under it.
  void pop<T extends Object?>([T? result]) {
    routerDelegate.pop<T>(result);
  }
}

class InterviewRouterDelegate extends RouterDelegate<List<InterviewRoute>>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<List<InterviewRoute>> {
  InterviewRouterDelegate({
    required InterviewRoute initialLocation,
    required GlobalKey<NavigatorState> navigatorKey,
  })  : _navigatorKey = navigatorKey,
        currentConfiguration = [initialLocation];

  final GlobalKey<NavigatorState> _navigatorKey;

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: _navigatorKey,
      pages: [
        // TODO: probably need to do something here
      ],
      onPopPage: _onPopPage,
    );
  }

  bool _onPopPage(Route<Object?> route, Object? result) {
    currentConfiguration.removeLast();
    notifyListeners();
    return route.didPop(result);
  }

  @override
  GlobalKey<NavigatorState>? get navigatorKey => _navigatorKey;

  @override
  List<InterviewRoute> currentConfiguration = [];

  @override
  Future<void> setNewRoutePath(List<InterviewRoute> configuration) {
    currentConfiguration = configuration;
    return SynchronousFuture(null);
  }

  void pop<T extends Object?>([T? result]) {
    NavigatorState? state;
    if (navigatorKey?.currentState?.canPop() ?? false) {
      state = navigatorKey?.currentState;
    }
    state?.pop(result);
  }
}

class InterviewInformationParser
    extends RouteInformationParser<List<InterviewRoute>> {
  @override
  Future<List<InterviewRoute>> parseRouteInformation(
    RouteInformation routeInformation,
  ) async {
    final state = routeInformation.state;
    return state as List<InterviewRoute>;
  }

  @override
  RouteInformation? restoreRouteInformation(
    List<InterviewRoute> configuration,
  ) {
    return RouteInformation(
      uri: Uri.parse(configuration.map((e) => e.path).join('/')),
      state: configuration,
    );
  }
}

class InterviewInformationProvider extends RouteInformationProvider
    with ChangeNotifier {
  InterviewInformationProvider({
    required InterviewRoute initial,
  }) : _value = RouteInformation(
          uri: Uri.parse('/${initial.path}'),
          state: [initial],
        );

  @override
  RouteInformation get value => _value;
  RouteInformation _value;

  /// Navigate to a new location.
  void navigate(
    InterviewRoute location, {
    required List<InterviewRoute> current,
  }) async {
    // TODO: You will need to do something here

    notifyListeners();
  }
}
