# Prefer config packages that exist in vcpkg
find_package(OpenEXR CONFIG REQUIRED)   # provides OpenEXR::OpenEXR, OpenEXR::OpenEXRCore
find_package(Imath   CONFIG REQUIRED)   # provides Imath::Imath

# Legacy scripts expect IlmBase::Half (OpenEXR v2). Emulate it with Imath.
if (TARGET Imath::Imath AND NOT TARGET IlmBase::Half)
  add_library(IlmBase::Half INTERFACE IMPORTED)
  target_link_libraries(IlmBase::Half INTERFACE Imath::Imath)
endif()

# Some scripts expect OpenEXR::IlmImf. Map it to the modern OpenEXR C++ target.
if (TARGET OpenEXR::OpenEXR AND NOT TARGET OpenEXR::IlmImf)
  add_library(OpenEXR::IlmImf INTERFACE IMPORTED)
  target_link_libraries(OpenEXR::IlmImf INTERFACE OpenEXR::OpenEXR)
endif()

# Optional: provide IlmBase::IlmThread alias if referenced
if (NOT TARGET IlmBase::IlmThread AND TARGET OpenEXR::OpenEXRCore)
  add_library(IlmBase::IlmThread INTERFACE IMPORTED)
  target_link_libraries(IlmBase::IlmThread INTERFACE OpenEXR::OpenEXRCore)
endif()
