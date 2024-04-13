import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'core/style/style.dart';
import 'core/application.dart';
import 'core/lang/app_localizations.dart';
import 'core/managers/user_manager.dart';
import 'firebase_options.dart';

Future<void> initApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await UserManager().initState();
}

Future<void> main() async {
  await initApp();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(const ProviderScope(child: MyApp()));
  });
}

class MyApp extends HookConsumerWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context, ref) {
    final local = ref.watch(langProvider);
    final appRouter = ref.watch(appRouterProvider);
    application.appRouter = appRouter;
    final theme = ref.watch(themeProvider);
    return MaterialApp.router(
      routerConfig: appRouter.config(),
      builder: (context, child) {
        return child!;
      },
      locale: local,
      theme: Style.appTheme(context),
      themeMode: theme,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales(),
    );
  }
}
