/*
 * OpenCommunication.java
 * Created by: Mahad Asghar on 12/08/2022.
 *
 *  Copyright © 2022 BjsSoftSolution. All rights reserved.
 */


package com.example.flutterserial;


import android.serialport.SerialPortFinder;
import android.serialport.port.BaseReader;
import android.serialport.port.LogInterceptorSerialPort;
import android.serialport.port.SerialApiManager;
import android.text.TextUtils;
import android.util.Log;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


public class OpenCommunication {
    private SerialApiManager spManager;
    private BaseReader baseReader;
    private String currentPort;
    public String logChannel = "";
    public String readChannel ="";

    List<String> entries = new ArrayList<String>();
    List<String> entryValues = new ArrayList<String>();

    public void destroyResources() {
        spManager.destroy();
    }

    public void initData() {

        spManager = SerialApiManager.getInstances().setLogInterceptor(new LogInterceptorSerialPort() {
            @Override
            public void log(@SerialApiManager.Type final String type, final String port, final boolean isAscii, final String log) {
                Log.d("SerialPortLog", new StringBuffer()
                        .append("Serial Port ：").append(port)
                        .append("\ndata format ：").append(isAscii ? "ascii" : "hexString")
                        .append("\ntype：").append(type)
                        .append("messages：").append(log).toString());
                logChannel = (new StringBuffer()
                        .append(" ").append(port)
                        .append(" ").append(isAscii ? "ascii" : "hexString")
                        .append(" ").append(type)
                        .append("：").append(log)
                        .append("\n").toString());

                Map<String,String>dataMap= new HashMap<String,String>();
                dataMap.put("LogChannel",logChannel);
                dataMap.put("readChannel",readChannel);
                CustomEventHandler.sendEvent(dataMap);
            }

        });
        baseReader = new BaseReader() {
            @Override
            protected void onParse(final String port, final boolean isAscii, final String read) {
                
                readChannel = (new StringBuffer().append(port).append("/").append(isAscii ? "ascii" : "hex").append(" read：").append(read).append("\n").toString());
                Map<String,String>dataMap= new HashMap<String,String>();
                dataMap.put("LogChannel",logChannel);
                dataMap.put("readChannel",readChannel);
                CustomEventHandler.sendEvent( dataMap);

            }
        };
    }
    List<String> sendDeviceData() {
         SerialPortFinder mSerialPortFinder = new SerialPortFinder();
         entries=Arrays.asList(mSerialPortFinder.getAllDevicesPath());
       // entries = List.of(mSerialPortFinder.getAllDevices());
//        entryValues = List.of(mSerialPortFinder.getAllDevicesPath());
        entryValues =Arrays.asList(mSerialPortFinder.getAllDevicesPath());
       return entryValues;
    }


    public void open(String name, boolean isAscii, int baudRate) {
        initData();
        String checkPort = name;
        if (TextUtils.isEmpty(checkPort)) {
            return;
        } else if (TextUtils.equals(checkPort, "other")) {
            checkPort = name;
            if (TextUtils.isEmpty(checkPort)) {
                return;
            }
        }

        if (TextUtils.equals(currentPort, checkPort)) {
            return;
        }

        if (!TextUtils.isEmpty(currentPort)) {
            // Close the CurrentPort serial port
            spManager.stopSerialPort(currentPort);
        }

        if(entryValues.contains(checkPort)){
            currentPort = checkPort;
            spManager.startSerialPort(checkPort, isAscii, baseReader,baudRate);
            changeCode(isAscii);
        }


    }




    public void close() {
        if (!TextUtils.isEmpty(currentPort)) {
            // currentPort
            spManager.stopSerialPort(currentPort);
            currentPort = "";
        }
    }

    public void send(String sendCommand) {
        if (TextUtils.isEmpty(currentPort)) {
            return;
        }

        if (TextUtils.isEmpty(sendCommand)) {
            return;
        }
        // send data
        spManager.send(currentPort, sendCommand);
    }

    private void changeCode(boolean isAscii) {
        if (TextUtils.isEmpty(currentPort)) {
            return;
        }
        spManager.setReadCode(currentPort, isAscii);

    }


}
