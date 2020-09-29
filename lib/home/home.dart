import 'package:fhir_db/resource_dao.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'home_bloc/home_controller.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      init: HomeController(),
      builder: (controller) => Scaffold(
        appBar: AppBar(title: const Text('VaxCast')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              runAlignment: WrapAlignment.spaceBetween,
              direction: Axis.horizontal,
              children: <Widget>[
                Text(
                  'VaxCast',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.courgette(
                      textStyle:
                          const TextStyle(color: Colors.red, fontSize: 60)),
                ),
                Text(
                  'Powered by FHIRFLI',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.averiaLibre(
                      textStyle:
                          const TextStyle(color: Colors.black, fontSize: 40)),
                ),
                DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                      items: controller.nameList.map((String name) {
                        return DropdownMenuItem<String>(
                          value: name,
                          child: Text(name),
                        );
                      }).toList(),
                      hint: Text(
                        "Select Patient's Name".tr,
                      ),
                      onChanged: (newName) =>
                          controller.event(HomeEvent.choosePatient(newName))),
                ),
                Text(
                  controller.nameError.tr,
                  style: const TextStyle(fontSize: 12.0, color: Colors.red),
                ),
                TextFormField(
                  controller: controller.nameController,
                  decoration: InputDecoration(
                    hintText: 'Enter New Patient Name'.tr,
                    errorText: controller.newNameError.tr,
                  ),
                ),
                RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  onPressed: () => controller.event(
                    HomeEvent.registerPatient(controller.nameController.text),
                  ),
                  child: Text('Click to Register New Patient'.tr),
                ),
                RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  onPressed: () async =>
                      await ResourceDao().deleteAllResources(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
