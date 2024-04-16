import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql_demo/data/models/continent/continent_model.dart';
import 'package:graphql_demo/data/models/countries/all_countries_model.dart';

import '../../data/models/countries/countries_by_continent_model.dart';
import '../../data/network/api_provider.dart';
import '../../data/network/network_response.dart';
import 'countries_state.dart';

class CountriesCubit extends Cubit<CountriesState> {
  CountriesCubit({required this.apiProvider})
      : super(
          CountriesState(
            formStatus: FormStatus.pure,
            statusText: "",
            countries: [],
            continentCountries: [],
          ),
        ) {
    //fetchCurrencies();
  }

  List<ContinentModel> continents = [
    ContinentModel(continent: 'North America', code: 'NA'),
    ContinentModel(continent: 'South America', code: 'SA'),
    ContinentModel(continent: 'Africa', code: 'AF'),
    ContinentModel(continent: 'Oceania', code: 'OC'),
    ContinentModel(continent: 'Asia', code: 'AS'),
    ContinentModel(continent: 'Europe', code: 'EU'),
  ];

  final ApiProvider apiProvider;

  List<AllCountriesModel> allCountries = [];
  List<CountriesByContinentModel> continentCountries = [];

  fetchCountries() async {
    emit(state.copyWith(formStatus: FormStatus.loading));
    NetworkResponse response = await apiProvider.getCountries();
    if (response.errorText.isEmpty) {
      allCountries = response.data as List<AllCountriesModel>;
      emit(
        state.copyWith(
          countries: allCountries,
          formStatus: FormStatus.success,
        ),
      );
    } else {
      emit(state.copyWith(
        statusText: response.errorText,
        formStatus: FormStatus.error,
      ));
    }
  }

  fetchCountriesByContinent(String continentName) async {
    emit(state.copyWith(formStatus: FormStatus.loading));
    NetworkResponse response = await apiProvider.getCountriesByContinents(continentName);
    if (response.errorText.isEmpty) {
      continentCountries = response.data as List<CountriesByContinentModel>;
      emit(
        state.copyWith(
          continentCountries: continentCountries,
          formStatus: FormStatus.success,
        ),
      );
    } else {
      emit(state.copyWith(
        statusText: response.errorText,
        formStatus: FormStatus.error,
      ));
    }
  }

  void filterSearchResultsAll(String query) {
    List<AllCountriesModel> searchResults = allCountries
        .where((country) =>
            country.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
    emit(state.copyWith(countries: searchResults));
  }

  void filterSearchResults(String query) {
    List<CountriesByContinentModel> searchResults = continentCountries
        .where((country) =>
            country.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
    emit(state.copyWith(continentCountries: searchResults));
  }

}
