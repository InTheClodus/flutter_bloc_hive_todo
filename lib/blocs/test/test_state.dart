part of 'test_bloc.dart';

abstract class TestState extends Equatable {
  const TestState();
  @override
  List<Object> get props => [];
}

class TestLoadInProgress extends TestState{}
class TestLoadSuccess extends TestState{
  final List<Advertise> advertises ;
  const TestLoadSuccess({this.advertises = const []});
  @override
  List<Object> get props => [advertises];

  @override
  String toString() => 'TestLoadSuccess { advertises: $advertises }';
}

/// 待办事项加载失败
class TestLoadFailure extends TestState {}
