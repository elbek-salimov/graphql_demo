import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql_demo/data/models/continent/continent_model.dart';
import 'package:graphql_demo/data/models/countries/all_countries_model.dart';
import 'package:graphql_demo/data/models/countries/countries_by_continent_model.dart';

import '../../cubits/countries/countries_cubit.dart';
import '../../cubits/countries/countries_state.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController searchController = TextEditingController();

    bool clicked = false;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Countries"),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: BlocBuilder<CountriesCubit, CountriesState>(
        builder: (context, state) {
          if (state.formStatus == FormStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.formStatus == FormStatus.error) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(state.statusText),
              ],
            );
          }
          return Column(
            children: [
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: TextField(
                  controller: searchController,
                  onChanged: (v) {
                    if (clicked == false) {
                      context.read<CountriesCubit>().filterSearchResultsAll(v);
                    } else {
                      context.read<CountriesCubit>().filterSearchResults(v);
                    }
                  },
                  decoration: const InputDecoration(
                    labelText: "Search",
                    hintText: "Search",
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(25.0)),
                    ),
                  ),
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(left: 10),
                child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                          context.read<CountriesCubit>().fetchCountries();
                          clicked = false;
                        },
                        child: const Text(
                          'All',
                          style: TextStyle(color: Colors.indigo),
                        ),
                      ),
                      ...List.generate(
                        context.read<CountriesCubit>().continents.length,
                        (index) {
                          ContinentModel continent =
                              context.read<CountriesCubit>().continents[index];
                          return TextButton(
                            onPressed: () {
                              context
                                  .read<CountriesCubit>()
                                  .fetchCountriesByContinent(continent.code);
                              clicked = true;
                            },
                            child: Text(
                              continent.continent,
                              style: const TextStyle(color: Colors.indigo),
                            ),
                          );
                        },
                      ),
                    ]),
              ),
              (clicked == false
                      ? state.countries.isEmpty
                      : state.continentCountries.isEmpty)
                  ? const Expanded(
                      child: Center(
                        child: Icon(
                          Icons.replay_circle_filled_sharp,
                          size: 40,
                        ),
                      ),
                    )
                  : Expanded(
                      child: ListView(
                        children: clicked == false
                            ? List.generate(state.countries.length, (index) {
                                AllCountriesModel countryModel =
                                    state.countries[index];
                                return Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: [
                                        BoxShadow(
                                          blurRadius: 10,
                                          color: Colors.black.withOpacity(0.3),
                                        )
                                      ]),
                                  child: ListTile(
                                    title: Text(
                                      "Country: ${countryModel.name}",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600),
                                    ),
                                    subtitle: Text(
                                        "Capital: ${countryModel.capital}"),
                                    leading: Text(countryModel.emoji),
                                    trailing: Text(countryModel.code),
                                  ),
                                );
                              })
                            : List.generate(state.continentCountries.length,
                                (index) {
                                CountriesByContinentModel
                                    continentCountriesModel =
                                    state.continentCountries[index];
                                return Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: [
                                        BoxShadow(
                                          blurRadius: 10,
                                          color: Colors.black.withOpacity(0.3),
                                        )
                                      ]),
                                  child: ListTile(
                                    title: Text(
                                      "Country: ${continentCountriesModel.name}",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600),
                                    ),
                                    subtitle: Text(
                                        "Capital: ${continentCountriesModel.capital}"),
                                    leading:
                                        Text(continentCountriesModel.emoji),
                                    trailing:
                                        Text(continentCountriesModel.code),
                                  ),
                                );
                              }),
                      ),
                    ),
            ],
          );
        },
      ),
    );
  }
}
