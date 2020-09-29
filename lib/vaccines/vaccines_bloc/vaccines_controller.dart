import 'package:fhir/r4.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:get/get.dart';
import 'package:vigor/models/patient_model.dart';

import '../../formatters.dart';
import '../vaccine_lists.dart';

part 'vaccines_controller.freezed.dart';
part 'vaccines_event.dart';
part 'vaccines_state.dart';

class VaccinesController extends GetxController {
  // PROPERTIES
  final state = VaccinesState.initial(Get.arguments).obs;

  // INIT
  @override
  Future onInit() async {
    await _getVaccineInfo(state.value.patient);
    super.onInit();
  }

  // GETTERS
  String name() =>
      state.value.patient == null ? '' : state.value.patient.name();
  String birthDate() =>
      state.value.patient == null ? '' : state.value.patient.birthDate();
  DateTime birthDateValue() =>
      state.value.patient == null ? '' : state.value.patient.birthDateValue();
  String get newVaccineType => state.value.vaccineType;
  String get newVaccineName => state.value.vaccineName;
  DateTime get newVaccineDate => state.value.vaccineDate;
  String get vaccineDateString => simpleDateTime(state.value.vaccineDate);

  // GETTERS
  Future _getVaccineInfo(PatientModel patient) async {
    patient.loadImmunizations();
    await patient.getImmunizationRecommendation();
    final fullRecs = <ImmunizationRecommendationRecommendation>[];
    patient.recommendation.recommendation.forEach(fullRecs.add);
    final displayRecs = fullRecs;
    displayRecs.removeWhere(
        (rec) => rec.forecastStatus.coding[0].code != Code('notComplete'));
    state.value = VaccinesState.loadValues(
      patient: patient,
      immEvals: patient.immEvaluations,
      fullImmRecs: fullRecs,
      displayImmRecs: sortRecsByDate(displayRecs),
    );
    update();
  }

  int get numberOfPastVaccines => state.value.patient.pastImmunizations.length;

  int get numberOfRecommendations => state.value.displayImmRecs.length;
  Color colorByDate(int index) {
    final dueDate = DateTime.parse(state
        .value.displayImmRecs[index].dateCriterion
        .firstWhere((criteria) => criteria?.code?.coding != null
            ? criteria.code.coding[0].code == Code('30980-7')
            : false)
        .value
        .toString());
    return dueDate.isBefore(DateTime.now())
        ? Colors.red
        : dueDate.isBefore(DateTime(DateTime.now().year, DateTime.now().month,
                DateTime.now().day + 30))
            ? Colors.yellow
            : Colors.transparent;
  }

  String vaccineType(int index) {
    if (state.value.displayImmRecs[index].vaccineCode == null) {
      return '';
    } else if (state.value.displayImmRecs[index].vaccineCode[0].coding ==
        null) {
      return '';
    } else if (state
            .value.displayImmRecs[index].vaccineCode[0].coding[0].code ==
        null) {
      return '';
    } else {
      return cvxToString[state
          .value.displayImmRecs[index].vaccineCode[0].coding[0].code
          .toString()];
    }
  }

  String vaccineDate(int index) =>
      simpleFhirDateTime(state.value.displayImmRecs[index].dateCriterion
          .firstWhere((criteria) => criteria?.code?.coding != null
              ? criteria.code.coding[0].code == Code('30980-7')
              : false)
          .value);

  // FUNCTIONS
  List<ImmunizationRecommendationRecommendation> sortRecsByDate(
      List<ImmunizationRecommendationRecommendation> recList) {
    recList.sort((a, b) => DateTime.parse(a.dateCriterion
            .firstWhere((criteria) => criteria?.code?.coding != null
                ? criteria.code.coding[0].code == Code('30980-7')
                : false)
            .value
            .toString())
        .compareTo(DateTime.parse(b.dateCriterion
            .firstWhere((criteria) => criteria?.code?.coding != null
                ? criteria.code.coding[0].code == Code('30980-7')
                : false)
            .value
            .toString())));
    return recList;
  }

  // EVENTS
  void event(VaccinesEvent newEvent) {
    newEvent.map(
      enterBirthdate: (event) async {
        final oldPatient = state.value.patient.patient;
        final curPatient = oldPatient.copyWith(birthDate: Date(event.birth));
        await _getVaccineInfo(PatientModel(patient: curPatient));
      },
      enterVaccine: (event) => null,
      newVaccineType: (event) {
        state.value = VaccinesState.vaccineEntry(
          patient: state.value.patient,
          immEvals: state.value.immEvals,
          fullImmRecs: state.value.fullImmRecs,
          displayImmRecs: state.value.fullImmRecs,
          newType: event.type,
        );
        update();
      },
      newVaccineName: (event) {
        state.value = VaccinesState.vaccineEntry(
          patient: state.value.patient,
          immEvals: state.value.immEvals,
          fullImmRecs: state.value.fullImmRecs,
          displayImmRecs: state.value.fullImmRecs,
          newName: event.name,
        );
        update();
      },
      newVaccineDate: (event) {
        state.value = VaccinesState.vaccineEntry(
          patient: state.value.patient,
          immEvals: state.value.immEvals,
          fullImmRecs: state.value.fullImmRecs,
          displayImmRecs: state.value.fullImmRecs,
          date: event.date,
        );
        update();
      },
    );
  }
}
