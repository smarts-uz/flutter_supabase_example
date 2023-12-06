import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_supabase_example/city_model.dart';
import 'package:flutter_supabase_example/main.dart';

class EditCityPage extends StatefulWidget {
  const EditCityPage({super.key});

  @override
  State<EditCityPage> createState() => _EditCityPageState();
}

class _EditCityPageState extends State<EditCityPage> {
  late final CityModel? args;
  late final TextEditingController ctrl;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    args = ModalRoute.of(context)?.settings.arguments as CityModel?;
    ctrl = TextEditingController(text: args?.name);
  }

  bool isLoading = false;
  bool isError = false;
  String? errorText;

  Future<bool> updateData({
    bool insert = false,
    bool update = false,
    bool upsert = false,
  }) async {
    if (ctrl.text.isEmpty) {
      setState(() {
        errorText = "empty city name";
        isLoading = false;
        isError = true;
      });
      return false;
    }

    setState(() {
      errorText = null;
      isLoading = true;
      isError = false;
    });

    try {
      final now = DateTime.now();

      if (args == null) {
        await supabase.from('cities').insert({
          'id': Random().nextInt(900) + 100,
          'name': ctrl.text,
          'created_at': now.toString(),
        });
      } else if (update) {
        await supabase.from('cities').update({'name': ctrl.text}).match({
          'id': args!.id,
        });
      } else if (upsert) {
        await supabase.from('cities').upsert({
          'id': Random().nextInt(900) + 100,
          'name': ctrl.text,
          'created_at': now.toString(),
        });
      }

      setState(() {
        isLoading = false;
      });
      return true;
    } catch (e) {
      setState(() {
        errorText = e.toString();
        isLoading = false;
        isError = true;
      });

      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final focus = FocusNode();

    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    isError ? "Error: $errorText" : '',
                    style: const TextStyle(color: Colors.red, fontSize: 20),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    onTapOutside: (event) {
                      focus.unfocus();
                    },
                    focusNode: focus,
                    controller: ctrl,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.blue),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                      hintText: "type city name",
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      (args == null
                              ? updateData(insert: true)
                              : updateData(update: true))
                          .then((value) {
                        if (value) {
                          Navigator.of(context).pop(true);
                        }
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(args == null ? "Add" : "Update"),
                  ),
                  if (args != null) const SizedBox(height: 20),
                  if (args != null)
                    ElevatedButton(
                      onPressed: () {
                        updateData(upsert: true).then((value) {
                          if (value) {
                            Navigator.of(context).pop(true);
                          }
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text("Update and insert new"),
                    ),
                ],
              ),
            ),
    );
  }
}
