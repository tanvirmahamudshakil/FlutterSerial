import 'package:flutter_test/flutter_test.dart';
import 'package:flutterserial/flutterserial.dart';
import 'package:flutterserial/flutterserial_platform_interface.dart';
import 'package:flutterserial/flutterserial_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterserialPlatform
    with MockPlatformInterfaceMixin
    implements FlutterserialPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final FlutterserialPlatform initialPlatform = FlutterserialPlatform.instance;

  test('$MethodChannelFlutterserial is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterserial>());
  });

  test('getPlatformVersion', () async {
    Flutterserial flutterserialPlugin = Flutterserial();
    MockFlutterserialPlatform fakePlatform = MockFlutterserialPlatform();
    FlutterserialPlatform.instance = fakePlatform;

    expect(await flutterserialPlugin.getPlatformVersion(), '42');
  });
}
