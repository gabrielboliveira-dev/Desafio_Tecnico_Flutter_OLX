import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import 'package:intl/date_symbol_data_local.dart';

import 'data/datasources/ad_api_data_source.dart';
import 'data/repositories/ad_repository_impl.dart';

import 'domain/repositories/ad_repository.dart';

import 'presentation/providers/ad_provider.dart';
import 'presentation/pages/ad_list_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting('pt_BR', null);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<http.Client>(create: (_) => http.Client()),

        Provider<AdApiDataSource>(
          create: (context) =>
              AdApiDataSource(client: context.read<http.Client>()),
        ),

        Provider<AdRepository>(
          create: (context) =>
              AdRepositoryImpl(dataSource: context.read<AdApiDataSource>()),
        ),

        ChangeNotifierProvider<AdProvider>(
          create: (context) =>
              AdProvider(repository: context.read<AdRepository>()),
        ),
      ],

      child: MaterialApp(
        title: 'OLX Clone',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
          useMaterial3: true,
          scaffoldBackgroundColor: Colors.grey[50],
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.deepPurple,
            foregroundColor: Colors.white,
            elevation: 0,
          ),
        ),
        home: const AdListPage(),
      ),
    );
  }
}
