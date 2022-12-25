// ignore_for_file: unnecessary_import, implementation_imports

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

// ignore_for_file: file_names, prefer_const_constructors, unused_import, library_prefixes, avoid_print, use_key_in_widget_constructors, prefer_const_constructors_in_immutables, sized_box_for_whitespace, avoid_web_libraries_in_flutter, prefer_final_fields, unnecessary_null_comparison, await_only_futures, unused_field, unnecessary_new

class CustomDrawer extends StatelessWidget {
  final List<Map> userData;
  const CustomDrawer({super.key, required this.userData});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Center(
        child: Container(
          height: double.maxFinite,
          child: ListView.builder(
              itemCount: userData.length,
              itemBuilder: (context, index) {
                var data = userData[index].values;
                return ListTile(
                  title: Text(
                    data.elementAt(0),
                    style: TextStyle(color: Colors.black, fontSize: 23),
                  ),
                  trailing: Text(
                    data.elementAt(1),
                    style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                );
              }),
        ),
      ),
    );
  }
}
