import 'dart:ui';

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutterserial/flutterserial.dart';

void main() {
  DartPluginRegistrant.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Serial Communication',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String logData = "";
  String receivedData = "";
  String selectedPort = "Select Port";
  int selectedBaudRate = Flutterserial().baudRateList.first;
  List<String>? serialList = [];
  DataFormat format = DataFormat.ASCII;
  String message = "";
  Flutterserial flutterSerial = Flutterserial();
  int selectedNavigationIndex = 0;
  @override
  void initState() {
    super.initState();
    flutterSerial.startSerial().listen(_updateConnectionStatus);
    getSerialList();
  }

  getSerialList() async {
    serialList = await flutterSerial.getAvailablePorts();
  }

  @override
  void dispose() {
    flutterSerial.destroy();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: const Text('Flutter Serial Communication Example'),
        ),
        body: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Expanded(
                child: Row(
                  children: [
                    NavigationRail(
                      destinations: [
                        buildNavigationRailDestination(
                            icon: Icons.settings, index: 0, labelText: "Setting"),
                        buildNavigationRailDestination(
                            icon: Icons.print, index: 1, labelText: "Print"),
                      ],
                      onDestinationSelected: (value) {
                        setState(() {
                          selectedNavigationIndex = value;
                        });
                      },
                      selectedIndex: selectedNavigationIndex,
                    ),
                    getChild()
                  ],
                )),
          ],
        ),
      ),
    );
  }

  NavigationRailDestination buildNavigationRailDestination(
      {required IconData icon,
        required String labelText,
        required int index}) =>
      NavigationRailDestination(
          icon: Icon(
            icon,
            size: 40,
            color:
            index == selectedNavigationIndex ? Colors.blue : Colors.black,
          ),
          label: Text(labelText));

  Widget _buildBody(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height,
      width: size.width - 80,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Divider(),
              sendCommand(),
              const Divider(),
              response()
            ],
          ),
        ),
      ),
    );
  }

  Widget getChild() {
    switch (selectedNavigationIndex) {
      case 0:
        return setupButton(context);

      case 1:
        return _buildBody(context);
      default:
        return setupButton(context);
    }
  }

  Widget setupButton(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width - 80,
      height: size.height,
      child: Column(
        children: [
          const Divider(),
          operations(),
          StatefulBuilder(
            builder: (context, state) {
              return Container(
                  height: 400,
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(26),
                      topRight: Radius.circular(26),
                    ),
                  ),
                  child: ListView(
                      physics: const ScrollPhysics(),
                      shrinkWrap: true,
                      children: [
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            verticalDirection: VerticalDirection.down,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Center(
                                    child: Container(
                                      height: 5,
                                      width: 100,
                                      decoration: BoxDecoration(
                                        color: Colors.grey,
                                        borderRadius: BorderRadius.circular(90),
                                      ),
                                    )),
                              ),
                              const Divider(),
                              listTile(
                                  widget: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      isExpanded: true,
                                      borderRadius: BorderRadius.circular(10),
                                      hint: Text(
                                        selectedPort,
                                        style: mediumStyle.apply(
                                            fontSizeFactor: 0.9),
                                      ),
                                      items: serialList!.map((String? value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child:
                                          Text(value!, style: mediumStyle),
                                        );
                                      }).toList(),
                                      onChanged: (p0) {
                                        updateSelectPort(state, p0!);
                                      },
                                    ),
                                  ),
                                  title: "Serial Port:"),
                              listTile(
                                  widget: DropdownButtonHideUnderline(
                                    child: DropdownButton<int>(
                                      isExpanded: true,
                                      borderRadius: BorderRadius.circular(10),
                                      hint: Text(
                                        selectedBaudRate.toString(),
                                        style: mediumStyle.apply(
                                            fontSizeFactor: 0.9),
                                      ),
                                      menuMaxHeight: 400.0,
                                      items: flutterSerial.baudRateList
                                          .map((int? value) {
                                        return DropdownMenuItem<int>(
                                          value: value,
                                          child: Text(value.toString(),
                                              style: mediumStyle),
                                        );
                                      }).toList(),
                                      onChanged: (p0) {
                                        updateSelectBaudRate(state, p0!);
                                      },
                                    ),
                                  ),
                                  title: 'Select the BaudRate:'),
                              listTile(
                                widget: Row(
                                  children: [
                                    Expanded(
                                      child: CheckboxListTile(
                                        title: const Text(
                                          "ASCII",
                                        ),
                                        value: format == DataFormat.ASCII
                                            ? true
                                            : false,
                                        onChanged: (newValue) {
                                          updateDataFormat(
                                              state, DataFormat.ASCII);
                                        },
                                        controlAffinity:
                                        ListTileControlAffinity.leading,
                                      ),
                                    ),
                                    Expanded(
                                      child: CheckboxListTile(
                                        title: const Text(
                                          "HEX String",
                                        ),
                                        value: format == DataFormat.HEX_STRING
                                            ? true
                                            : false,
                                        onChanged: (newValue) {
                                          updateDataFormat(
                                              state, DataFormat.HEX_STRING);
                                        },
                                        controlAffinity:
                                        ListTileControlAffinity.leading,
                                      ),
                                    ),
                                  ],
                                ),
                                title: "Data Format",
                              ),
                            ])
                      ]));
            },
          ),
        ],
      ),
    );

    // return InkWell(
    //   onTap: () {
    //     settingModalBottomSheet(context: context, list: serialList);
    //   },
    //   child: Material(
    //     elevation: 4,
    //     borderRadius: BorderRadius.circular(15),
    //     color: const Color(0xFFF2F2F7),
    //     child: Padding(
    //       padding: const EdgeInsets.all(8.0),
    //       child: Column(
    //         children: [
    //           Text(
    //             "Tap to setup",
    //             style: mediumStyle.apply(fontSizeFactor: 1),
    //           ),
    //           Padding(
    //             padding: const EdgeInsets.all(8.0),
    //             child: Row(
    //               mainAxisAlignment: MainAxisAlignment.spaceAround,
    //               children: [
    //                 RichText(
    //                   text: TextSpan(
    //                     text: 'Device: \n',
    //                     style: mediumStyle.apply(color: Colors.blue),
    //                     children: <TextSpan>[
    //                       TextSpan(
    //                         text: selectedPort,
    //                         style: mediumStyle.apply(color: Colors.black54),
    //                       )
    //                     ],
    //                   ),
    //                 ),
    //                 RichText(
    //                   text: TextSpan(
    //                     text: 'Baud Rate: \n',
    //                     style: mediumStyle.apply(color: Colors.blue),
    //                     children: <TextSpan>[
    //                       TextSpan(
    //                         text: "$selectedBaudRate",
    //                         style: mediumStyle.apply(color: Colors.black54),
    //                       )
    //                     ],
    //                   ),
    //                 ),
    //               ],
    //             ),
    //           ),
    //           RichText(
    //             text: TextSpan(
    //               text: 'Data Format: ',
    //               style: mediumStyle.apply(color: Colors.blue),
    //               children: <TextSpan>[
    //                 TextSpan(
    //                   text: format.name,
    //                   style: mediumStyle.apply(
    //                     color: Colors.black54,
    //                   ),
    //                 )
    //               ],
    //             ),
    //           ),
    //         ],
    //       ),
    //     ),
    //   ),
    // );
  }

  Widget response() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                const Text(
                  "Received Data",
                  style: mediumStyle,
                ),
                const SizedBox(
                  height: 10,
                ),
                button(
                    name: "Empty",
                    onPress: () {
                      flutterSerial.clearRead();
                    }),
              ],
            ),
            Column(
              children: [
                const Text(
                  "Operation Log",
                  style: mediumStyle,
                ),
                const SizedBox(
                  height: 10,
                ),
                button(
                    name: "Empty",
                    onPress: () {
                      flutterSerial.clearLog();
                    }),
              ],
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * .4,
          child: Row(
            children: [
              log(data: receivedData),
              const VerticalDivider(
                thickness: 2,
              ),
              log(data: logData)
            ],
          ),
        ),
      ],
    );
  }

  Widget log({required String data}) {
    return Expanded(
      child: Scrollbar(
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          scrollDirection: Axis.vertical, //.horizontal
          child: Text(
            data,
            style: const TextStyle(
              fontSize: 16.0,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  Widget sendCommand() {
    return Material(
      elevation: 4,
      color: const Color(0xFFF2F2F7),
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                decoration:
                const InputDecoration(hintText: "Write send Command"),
                onChanged: (value) {
                  message = value;
                },
              ),
            ),
            button(
                name: "Send",
                onPress: () {
                  flutterSerial.sendCommand(message: message);
                })
          ],
        ),
      ),
    );
  }

  Widget operations() {
    return Material(
      elevation: 4,
      color: const Color(0xFFF2F2F7),
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(9.0),
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Text("OPERATION", style: mediumStyle.apply(color: Colors.black54)),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                button(
                    name: "Open",
                    onPress: () {
                      flutterSerial.openPort(
                          dataFormat: format,
                          serialPort: selectedPort,
                          baudRate: selectedBaudRate);
                    }),
                button(
                    name: "Close",
                    onPress: () {
                      flutterSerial.closePort();
                    })
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _updateConnectionStatus(SerialResponse? result) async {
    setState(() {
      logData = result!.logChannel ?? "";
      receivedData = result.readChannel ?? "";
    });
  }

  Widget button({required String name, required Function() onPress}) {
    return SizedBox(
      height: 40,
      width: 130,
      child: ElevatedButton(
          onPressed: onPress,
          child: Text(
            name,
            style: mediumStyle,
          )),
    );
  }

  settingModalBottomSheet({context, List<String>? list}) {
    showModalBottomSheet(
        isScrollControlled: true,
        enableDrag: true,
        backgroundColor: Colors.transparent,
        context: context,
        builder: (BuildContext bc) {
          return StatefulBuilder(
            builder: (context, state) {
              return Container(
                  height: 400,
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(26),
                      topRight: Radius.circular(26),
                    ),
                  ),
                  child: ListView(
                      physics: const ScrollPhysics(),
                      shrinkWrap: true,
                      children: [
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            verticalDirection: VerticalDirection.down,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Center(
                                    child: Container(
                                      height: 5,
                                      width: 100,
                                      decoration: BoxDecoration(
                                        color: Colors.grey,
                                        borderRadius: BorderRadius.circular(90),
                                      ),
                                    )),
                              ),
                              const Divider(),
                              listTile(
                                  widget: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      isExpanded: true,
                                      borderRadius: BorderRadius.circular(10),
                                      hint: Text(
                                        selectedPort,
                                        style: mediumStyle.apply(
                                            fontSizeFactor: 0.9),
                                      ),
                                      items: serialList!.map((String? value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child:
                                          Text(value!, style: mediumStyle),
                                        );
                                      }).toList(),
                                      onChanged: (p0) {
                                        updateSelectPort(state, p0!);
                                      },
                                    ),
                                  ),
                                  title: "Serial Port:"),
                              listTile(
                                  widget: DropdownButtonHideUnderline(
                                    child: DropdownButton<int>(
                                      isExpanded: true,
                                      borderRadius: BorderRadius.circular(10),
                                      hint: Text(
                                        selectedBaudRate.toString(),
                                        style: mediumStyle.apply(
                                            fontSizeFactor: 0.9),
                                      ),
                                      menuMaxHeight: 400.0,
                                      items: flutterSerial.baudRateList
                                          .map((int? value) {
                                        return DropdownMenuItem<int>(
                                          value: value,
                                          child: Text(value.toString(),
                                              style: mediumStyle),
                                        );
                                      }).toList(),
                                      onChanged: (p0) {
                                        updateSelectBaudRate(state, p0!);
                                      },
                                    ),
                                  ),
                                  title: 'Select the BaudRate:'),
                              listTile(
                                widget: Row(
                                  children: [
                                    Expanded(
                                      child: CheckboxListTile(
                                        title: const Text(
                                          "ASCII",
                                        ),
                                        value: format == DataFormat.ASCII
                                            ? true
                                            : false,
                                        onChanged: (newValue) {
                                          updateDataFormat(
                                              state, DataFormat.ASCII);
                                        },
                                        controlAffinity:
                                        ListTileControlAffinity.leading,
                                      ),
                                    ),
                                    Expanded(
                                      child: CheckboxListTile(
                                        title: const Text(
                                          "HEX String",
                                        ),
                                        value: format == DataFormat.HEX_STRING
                                            ? true
                                            : false,
                                        onChanged: (newValue) {
                                          updateDataFormat(
                                              state, DataFormat.HEX_STRING);
                                        },
                                        controlAffinity:
                                        ListTileControlAffinity.leading,
                                      ),
                                    ),
                                  ],
                                ),
                                title: "Data Format",
                              ),
                            ])
                      ]));
            },
          );
        });
  }

  Future<void> updateSelectPort(StateSetter updateState, String value) async {
    updateState(() {
      setState(() {
        selectedPort = value;
      });
    });
  }

  Future<void> updateDataFormat(
      StateSetter updateState, DataFormat value) async {
    updateState(() {
      setState(() {
        format = value;
      });
    });
  }

  Future<void> updateSelectBaudRate(StateSetter updateState, int value) async {
    updateState(() {
      setState(() {
        selectedBaudRate = value;
      });
    });
  }

  Widget listTile({required Widget widget, required String title}) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            textAlign: TextAlign.left,
            style: mediumStyle,
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: Colors.black38,
                ),
                borderRadius: BorderRadius.circular(10.0),
              ),
              padding: const EdgeInsets.only(
                left: 8.0,
              ),
              child: widget),
        ],
      ),
    );
  }
}

const mediumStyle = TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.bold,
);
