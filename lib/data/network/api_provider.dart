import 'package:flutter/cupertino.dart';
import 'package:graphql/client.dart';
import 'package:graphql_demo/data/models/countries/all_countries_model.dart';

import '../models/countries/countries_by_continent_model.dart';
import '../queries/countries_query.dart';
import 'network_response.dart';

class ApiProvider {
  ApiProvider({required this.graphQLClient});

  factory ApiProvider.create() {
    final _httpLink = HttpLink('https://countries.trevorblades.com');
    final link = Link.from([_httpLink]);
    return ApiProvider(
      graphQLClient: GraphQLClient(
        link: link,
        cache: GraphQLCache(),
      ),
    );
  }

  final GraphQLClient graphQLClient;

  Future<NetworkResponse> getCountries() async {
    try {
      var result = await graphQLClient.query(
        QueryOptions(document: gql(countriesQuery)),
      );

      if (result.hasException) {
        return NetworkResponse(
            errorText: result.exception!.graphqlErrors.toString());
      } else {
        List<AllCountriesModel> countries = (result.data?['countries'] as List?)
                ?.map((dynamic e) =>
                    AllCountriesModel.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [];
        debugPrint("LIST LENGTH:${countries.length}");
        return NetworkResponse(data: countries);
      }
    } catch (error) {
      debugPrint("ERROR:$error");
    }

    return NetworkResponse();
  }

  Future<NetworkResponse> getCountriesByContinents(String continentCode) async {
    try {
      var result = await graphQLClient.query(
        //MutationOptions(document: gql(""))
        QueryOptions(document: gql(getCountryQueryByContinent(continentCode))),
      );

      if (result.hasException) {
        return NetworkResponse(
            errorText: result.exception!.graphqlErrors.toString());
      } else {
        List<CountriesByContinentModel> countries =
            (result.data?['countries'] as List?)
                    ?.map((dynamic e) => CountriesByContinentModel.fromJson(
                        e as Map<String, dynamic>))
                    .toList() ??
                [];
        debugPrint("LIST LENGTH:${countries.length}");
        return NetworkResponse(data: countries);
      }
    } catch (error) {
      debugPrint("ERROR:$error");
    }

    return NetworkResponse();
  }
}
