import 'package:graphql_demo/data/models/countries/all_countries_model.dart';
import 'package:graphql_demo/data/models/countries/countries_by_continent_model.dart';

class CountriesState {
  final FormStatus formStatus;
  final List<AllCountriesModel> countries;
  final List<CountriesByContinentModel> continentCountries;
  final String statusText;

  CountriesState({
    required this.formStatus,
    required this.statusText,
    required this.countries,
    required this.continentCountries,
  });

  CountriesState copyWith({
    FormStatus? formStatus,
    List<AllCountriesModel>? countries,
    List<CountriesByContinentModel>? continentCountries,
    String? statusText,
  }) =>
      CountriesState(
        formStatus: formStatus ?? this.formStatus,
        countries: countries ?? this.countries,
        statusText: statusText ?? this.statusText,
        continentCountries: continentCountries ?? this.continentCountries,
      );
}

enum FormStatus {
  pure,
  loading,
  success,
  error,
}