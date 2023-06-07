import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'temphumi.g.dart';

@JsonSerializable(explicitToJson: true)
class DataRunning {
  DataRunning(this.PPG, this.ECG, this.PTT);
  double PPG ;
  double ECG;
  double PTT;


  factory DataRunning.fromJson(Map<String, dynamic> json) =>
      _$DataFromJson(json);
  Map<String, dynamic> toJson() => _$DataToJson(this);
}
