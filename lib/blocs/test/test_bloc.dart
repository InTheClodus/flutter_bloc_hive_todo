import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc_hive_todo/test_api.dart';
import 'package:networ_common/http/http.dart';

part 'test_event.dart';
part 'test_state.dart';

class TestBloc extends Bloc<TestEvent, TestState> {
  TestBloc() : super(TestLoadInProgress()) {
    on<TestEvent>((event, emit) {
      // TODO: implement event handler TestLoaded
    });
    on<TestLoaded>(_onLoaded);
  }

  void _onLoaded(TestEvent event,Emitter<TestState> emit) async {
    try {
      /// 获得初始默认待办事项
      var  response = await Https.instance.get("/getAllAdvertise");
      List<Advertise> data =[];
      response["data"].map((e)=>data.add(Advertise.fromJson(e))).toList();
      emit(TestLoadSuccess(
        advertises: data,
      ));
    } catch (e) {
      emit(TestLoadFailure());
    }
  }
}
