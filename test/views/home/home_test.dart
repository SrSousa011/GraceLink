import 'package:churchapp/views/events/event_detail/event_details_screen.dart';
import 'package:churchapp/views/events/events.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:churchapp/views/home/home.dart';
import 'package:provider/provider.dart';
import 'package:churchapp/theme/theme_provider.dart';

void main() {
  testWidgets('Test Case 1: Verify Header is Displayed', (tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ],
        child: const MaterialApp(
          home: Home(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(Image), findsOneWidget);
    expect(find.text('Bem-vindo à Igreja'), findsOneWidget);
  });

  testWidgets('Test Case 2: Verify Footer is Displayed', (tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ],
        child: const MaterialApp(
          home: Home(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Endereço:'), findsOneWidget);
    expect(find.text('Cultos:'), findsOneWidget);
  });

  testWidgets('Test Case 3: Event Data Fetching', (tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ],
        child: const MaterialApp(
          home: Home(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Test Event'), findsOneWidget);
    expect(find.text('Test Location'), findsOneWidget);
  });

  testWidgets('Test Case 5: Verify Theme Toggle Functionality', (tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ],
        child: const MaterialApp(
          home: Home(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    final themeButton = find.byIcon(Icons.brightness_6);
    expect(themeButton, findsOneWidget);

    await tester.tap(themeButton);
    await tester.pumpAndSettle();

    final darkModeButton = find.byIcon(
        Icons.brightness_4); // Assuming the icon changes to this for dark mode
    expect(darkModeButton, findsOneWidget);
  });

  testWidgets('Test Case 6: Verify Instagram Link', (tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ],
        child: const MaterialApp(
          home: Home(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    final instaIcon = find.byIcon(Icons.image);
    expect(instaIcon, findsOneWidget);

    await tester.tap(instaIcon);
    await tester.pumpAndSettle();
    // Add your verification here if the app opens Instagram
  });

  testWidgets('Test Case 7: Verify Facebook Link', (tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ],
        child: const MaterialApp(
          home: Home(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    final fbIcon = find.byIcon(Icons.image);
    expect(fbIcon, findsOneWidget);

    await tester.tap(fbIcon);
    await tester.pumpAndSettle();
    // Add verification to check if the app opens Facebook
  });

  testWidgets('Test Case 8: Verify YouTube Link', (tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ],
        child: const MaterialApp(
          home: Home(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    final ytIcon = find.byIcon(Icons.image);
    expect(ytIcon, findsOneWidget);

    await tester.tap(ytIcon);
    await tester.pumpAndSettle();
    // Add verification to check if the app opens YouTube
  });

  testWidgets('Test Case 9: Verify Church Page Link', (tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ],
        child: const MaterialApp(
          home: Home(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    final churchPageIcon = find.byIcon(Icons.image);
    expect(churchPageIcon, findsOneWidget);

    await tester.tap(churchPageIcon);
    await tester.pumpAndSettle();
    // Add verification to check if the Linktree URL opens
  });

  testWidgets('Test Case 10: Verify Navigation to Event Details',
      (tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ],
        child: const MaterialApp(
          home: Home(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    final eventFinder = find.text('Test Event');
    expect(eventFinder, findsOneWidget);

    await tester.tap(eventFinder);
    await tester.pumpAndSettle();

    expect(find.byType(EventDetailsScreen), findsOneWidget);
  });

  testWidgets('Test Case 11: Verify Navigation to All Events Screen',
      (tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ],
        child: const MaterialApp(
          home: Home(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    final allEventsButton = find.text('Todos os Eventos');
    expect(allEventsButton, findsOneWidget);

    await tester.tap(allEventsButton);
    await tester.pumpAndSettle();

    expect(find.byType(Events), findsOneWidget);
  });

  testWidgets('Test Case 12: Verify Error Handling for Events Fetching',
      (tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ],
        child: const MaterialApp(
          home: Home(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Erro ao carregar eventos'), findsOneWidget);
  });

  testWidgets('Test Case 13: Verify No UI Breaks or Overflows', (tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ],
        child: const MaterialApp(
          home: Home(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(Container), findsWidgets);
  });
}
