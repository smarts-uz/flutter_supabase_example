import 'package:flutter/material.dart';
import 'package:flutter_supabase_example/city_model.dart';
import 'package:flutter_supabase_example/edit_city_page.dart';
import 'package:flutter_supabase_example/main.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = false;
  bool isError = false;
  List<CityModel> allCities = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() {
      isLoading = true;
      isError = false;
      allCities = [];
    });
    try {
      if (supabase.auth.currentUser == null) {
        // await supabase.auth.signUp(
        //   password: "123456",
        //   email: "abibobur@gmail.com",
        // );
        await supabase.auth.signInWithPassword(
          password: "123456",
          email: "abibobur@gmail.com",
        );
      }

      final data = await supabase.from('cities').select();

      data.forEach((element) {
        allCities.add(
          CityModel.fromJson(
            element["id"],
            element["created_at"],
            element["name"],
          ),
        );
      });

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        isError = true;

        allCities = [];
      });
    }
  }

  Future<void> _deleteData(int id) async {
    setState(() {
      isLoading = true;
      isError = false;
      allCities = [];
    });
    try {
      await supabase.from('cities').delete().match({'id': id});
    } catch (e) {
      setState(() {
        isLoading = false;
        isError = true;
        allCities = [];
      });
      return;
    }

    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.blue,
      foregroundColor: Colors.white,
      title: const Text("Supabase"),
      actions: [
        IconButton(
          onPressed: _fetchData,
          icon: const Icon(Icons.restart_alt_rounded),
        ),
      ],
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () {
        Navigator.of(context)
            .push(MaterialPageRoute(
          builder: (context) => const EditCityPage(),
        ))
            .then((value) {
          if (value != null) _fetchData();
        });
      },
      tooltip: 'Add',
      child: const Icon(Icons.add),
    );
  }

  Widget _buildBody() {
    return Center(
      child: isLoading
          ? const CircularProgressIndicator()
          : isError
              ? const Text("ERROR")
              : allCities.isEmpty
                  ? const Text("NO DATA")
                  : ListView.separated(
                      itemCount: allCities.length,
                      separatorBuilder: (context, index) {
                        return const Divider();
                      },
                      itemBuilder: (context, index) {
                        final city = allCities[index];
                        return ListTile(
                          onTap: () {
                            Navigator.of(context)
                                .push(
                              MaterialPageRoute(
                                builder: (context) => const EditCityPage(),
                                settings: RouteSettings(arguments: city),
                              ),
                            )
                                .then(
                              (value) {
                                if (value != null) _fetchData();
                              },
                            );
                          },
                          leading: Text("id: ${city.id}"),
                          title: Text(city.name),
                          subtitle: Text(
                            city.createdAt
                                .split("+")
                                .first
                                .split("T")
                                .join(" - "),
                          ),
                          trailing: IconButton(
                            onPressed: () {
                              _deleteData(city.id);
                            },
                            icon: const Icon(
                              Icons.delete_rounded,
                              color: Colors.red,
                            ),
                          ),
                        );
                      },
                    ),
    );
  }
}
