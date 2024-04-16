import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql_demo/data/network/api_provider.dart';
import 'package:graphql_demo/screens/home/home_screen.dart';

import 'cubits/countries/countries_cubit.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final ApiProvider apiProvider =
      ApiProvider(graphQLClient: ApiProvider.create().graphQLClient);

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              CountriesCubit(apiProvider: apiProvider)..fetchCountries(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: false),
      home: const HomeScreen(),
    );
  }
}
