part of 'temphumi.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DataRunning _$DataFromJson(Map<String?, dynamic> json) => DataRunning(
      (json['PPG'] as num).toDouble(),
      (json['ECG'] as num).toDouble(),
      (json['PTT'] as num).toDouble(),
    
    );

Map<String, dynamic> _$DataToJson(DataRunning instance) => <String, dynamic>{
      'PPG': instance.PPG,
      'ECG': instance.ECG,
      'PTT': instance.PTT
    
    };
