set(_catch2_url "https://github.com/catchorg/Catch2/archive/refs/tags/v3.4.0.zip")
set(_catch2_archive "${CMAKE_SOURCE_DIR}/downloads/Catch2-v3.4.0.zip")
if(EXISTS "${_catch2_archive}")
    set(_catch2_url "${_catch2_archive}")
endif()
add_cmake_project(Catch2
    URL "${_catch2_url}"
    URL_HASH SHA256=cd175f5b7e62c29558d4c17d2b94325ee0ab6d0bf1a4b3d61bc8dbcc688ea3c2
    CMAKE_ARGS
        -DCATCH_BUILD_TESTING:BOOL=OFF
)
unset(_catch2_url)
unset(_catch2_archive)
