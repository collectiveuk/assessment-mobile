import 'package:flutter/material.dart' as material;
import 'package:flutter_test/flutter_test.dart';

import 'package:interview_router/interview_router.dart';

void main() {
  final homeRoute = InterviewRoute(
    path: 'home',
    routeBuilder: (context) => const HomeScreen(),
  );

  final page1Route = InterviewRoute(
    path: 'page1',
    routeBuilder: (context) => const Page1Screen(),
  );

  testWidgets('match home route', (tester) async {
    final router = await createRouter(homeRoute, tester);
    final locations = router.routerDelegate.currentConfiguration;
    expect(locations.length, 1);
    expect(locations.map((e) => e.path).join('/'), 'home');
    expect(find.byType(HomeScreen), findsOneWidget);
  });

  testWidgets('navigates to page 1', (tester) async {
    final router = await createRouter(homeRoute, tester);

    router.navigate(to: page1Route, from: homeRoute);
    final locations = router.routerDelegate.currentConfiguration;
    expect(locations.map((e) => e.path).join('/'), 'home/page1');
    await tester.pumpAndSettle();
    expect(find.byType(Page1Screen), findsOneWidget);
  });

  testWidgets('can pop', (tester) async {
    final router = await createRouter(homeRoute, tester);

    router.navigate(to: page1Route, from: homeRoute);
    await tester.pumpAndSettle();
    expect(find.byType(Page1Screen), findsOneWidget);

    router.pop();
    await tester.pumpAndSettle();
    expect(find.byType(HomeScreen), findsOneWidget);
  });

  testWidgets('does not break when popping root', (tester) async {
    final router = await createRouter(homeRoute, tester);

    router.pop();
    await tester.pumpAndSettle();
    expect(find.byType(HomeScreen), findsOneWidget);
  });
}

class HomeScreen extends material.StatelessWidget {
  const HomeScreen({super.key});

  @override
  material.Widget build(material.BuildContext context) {
    return const material.Center(
      child: material.Text('Home'),
    );
  }
}

class Page1Screen extends material.StatelessWidget {
  const Page1Screen({super.key});

  @override
  material.Widget build(material.BuildContext context) {
    return const material.Center(
      child: material.Text('Page 1'),
    );
  }
}

Future<InterviewRouter> createRouter(
  InterviewRoute initialLocation,
  WidgetTester tester,
) async {
  final router = InterviewRouter(
    initialLocation: initialLocation,
  );
  await tester.pumpWidget(
    material.MaterialApp.router(
      routerConfig: router,
    ),
  );
  return router;
}
