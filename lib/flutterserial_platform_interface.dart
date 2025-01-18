import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutterserial.dart';
import 'flutterserial_method_channel.dart';

abstract class FlutterserialPlatform extends PlatformInterface {
  /// Constructs a FlutterserialPlatform.
  FlutterserialPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterserialPlatform _instance = MethodChannelFlutterserial();

  /// The default instance of [FlutterserialPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterserial].
  static FlutterserialPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterserialPlatform] when
  /// they register themselves.
  static set instance(FlutterserialPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Stream<SerialResponse> startSerial() {
    throw UnimplementedError('startSerial() has not been implemented.');
  }

  /// Thrown by operations that have not been implemented yet.
  /// a [UnsupportedError] all things considered. This mistake is just planned for
  /// use during improvement.
  Future<String?> openPort(
      {required DataFormat dataFormat,
        required String serialPort,
        required int baudRate}) {
    throw UnimplementedError('openSerial() has not been implemented.');
  }

  /// Thrown by operations that have not been implemented yet.
  /// a [UnsupportedError] all things considered. This mistake is just planned for
  /// use during improvement.
  Future<List<String>?> getAvailablePorts() {
    throw UnimplementedError('getAvailablePorts() has not been implemented.');
  }

  /// Thrown by operations that have not been implemented yet.
  /// a [UnsupportedError] all things considered. This mistake is just planned for
  /// use during improvement.
  Future<String?> closePort() {
    throw UnimplementedError('closeSerial() has not been implemented.');
  }

  /// Thrown by operations that have not been implemented yet.
  /// a [UnsupportedError] all things considered. This mistake is just planned for
  /// use during improvement.
  Future<String?> sendCommand({required String message}) {
    throw UnimplementedError('sendCommand() has not been implemented.');
  }

  /// Thrown by operations that have not been implemented yet.
  /// a [UnsupportedError] all things considered. This mistake is just planned for
  /// use during improvement.

  Future<String?> clearLog() {
    throw UnimplementedError('clearLog() has not been implemented.');
  }

  /// Thrown by operations that have not been implemented yet.
  /// a [UnsupportedError] all things considered. This mistake is just planned for
  /// use during improvement.
  Future<String?> clearRead() {
    throw UnimplementedError('clearRead() has not been implemented.');
  }

  /// Thrown by operations that have not been implemented yet.
  /// a [UnsupportedError] all things considered. This mistake is just planned for
  /// use during improvement.
  Future<String?> destroyResources() {
    throw UnimplementedError('destroyResources() has not been implemented.');
  }
}
