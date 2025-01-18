# Sets the minimum version of CMake required to build your native library.
# This ensures that a certain set of CMake features is available to
# your build.
# android studio set CMakeLists.txt : https://developer.android.com/studio/projects/add-native-code.html

cmake_minimum_required(VERSION 3.4.1)

# Specifies a library name, specifies whether the library is STATIC or
# SHARED, and provides relative paths to the source code. You can
# define multiple libraries by adding multiple add.library() commands,
# and CMake builds them for you. When you build your app, Gradle
# automatically packages shared libraries with your APK.
#set(ARCHS
#        arm64-v8a
#        armeabi-v7a
#        x86
#        x86_64
#        armeabi
#        mips
#        mips64
#        )


#foreach(arch ${ARCHS})
#
#
#    add_library(serial_port_${arch} SHARED src/main/cpp/SerialPort.c)
#    set_target_properties(serial_port_${arch} PROPERTIES
#            LIBRARY_OUTPUT_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/libs/${arch}")
#    # set specific compiler flags or other configuration options for each architecture
#endforeach()
#set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/libs)

#add_library( # Specifies the name of the library.
#             serial_port
#
#             # Sets the library as a shared library.
#             SHARED
#
#             # Provides a relative path to your source file(s).
#             src/main/cpp/SerialPort.c )

find_library( # Sets the name of the path variable.
              log-lib

              # Specifies the name of the NDK library that
              # you want CMake to locate.
              log )

# Specifies libraries CMake should link to your target library. You
# can link multiple libraries, such as libraries you define in this
# build script, prebuilt third-party libraries, or system libraries.

#foreach(arch ${ARCHS})
#    target_link_libraries(serial_port_${arch}  ${log-lib} )
#    # set specific compiler flags or other configuration options for each architecture
#endforeach()
#target_link_libraries( # Specifies the target library.
#                       serial_port
#
#                       # Links the target library to the log library
#                       # included in the NDK.
#                       ${log-lib} )

set(ARCHS
        arm64-v8a
        armeabi-v7a
        x86
        x86_64
        armeabi
        mips
        mips64
        )

set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/libs)

foreach(arch ${ARCHS})
    add_library(serial_port_${arch} SHARED src/main/cpp/SerialPort.c )
    set_target_properties(serial_port_${arch} PROPERTIES
            LIBRARY_OUTPUT_DIRECTORY ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/${arch}
            OUTPUT_NAME serial_port
            ) # This will generate libserial_port.so


    # Example of linking against another library (replace "other_library" with the actual library name)
    target_link_libraries(serial_port_${arch} PRIVATE   ${log-lib})

    # set specific compiler flags or other configuration options for each architecture
endforeach()


