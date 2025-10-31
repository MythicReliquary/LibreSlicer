cmake_minimum_required(VERSION 3.13)
project(OCCTWrapper)

if (APPLE)
    # TODO: we need to fix notarization with the separate shared library
    add_library(OCCTWrapper STATIC OCCTWrapper.cpp)
else ()
    add_library(OCCTWrapper MODULE OCCTWrapper.cpp)
endif ()

set_target_properties(OCCTWrapper
    PROPERTIES
    LIBRARY_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/src"
    RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/src"
    PREFIX ""
)

include(GenerateExportHeader)

generate_export_header(OCCTWrapper)

find_package(OpenCASCADE CONFIG REQUIRED)

set(OCCT_LIBS ${OpenCASCADE_LIBRARIES})

slic3r_remap_configs("${OCCT_LIBS}" RelWithDebInfo Release)

target_include_directories(OCCTWrapper PRIVATE ${CMAKE_CURRENT_BINARY_DIR})
target_include_directories(OCCTWrapper PUBLIC ${OpenCASCADE_INCLUDE_DIR})
target_link_libraries(OCCTWrapper ${OCCT_LIBS})

include(GNUInstallDirs)

install(TARGETS OCCTWrapper DESTINATION "${CMAKE_INSTALL_BINDIR}")
