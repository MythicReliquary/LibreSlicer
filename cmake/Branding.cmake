# Toggle official brand assets vs. generic/open placeholders.
# OFF by default so forks build with generic artwork.

option(OFFICIAL_BRAND "Use proprietary LibreSlicer brand assets" OFF)

set(BRAND_OFFICIAL_WORDMARK   "${CMAKE_SOURCE_DIR}/resources/icons/libreslicer_brand_wordmark.png")
set(BRAND_OFFICIAL_MARK       "${CMAKE_SOURCE_DIR}/resources/icons/libreslicer_brand_mark.png")

set(BRAND_GENERIC_WORDMARK    "${CMAKE_SOURCE_DIR}/resources/icons/libreslicer_logo_wordmark.svg")
set(BRAND_GENERIC_MARK        "${CMAKE_SOURCE_DIR}/resources/icons/libreslicer_logo_mark.svg")

if(OFFICIAL_BRAND)
  set(BRAND_WORDMARK "${BRAND_OFFICIAL_WORDMARK}")
  set(BRAND_MARK     "${BRAND_OFFICIAL_MARK}")
else()
  set(BRAND_WORDMARK "${BRAND_GENERIC_WORDMARK}")
  set(BRAND_MARK     "${BRAND_GENERIC_MARK}")
endif()

function(brand_assets_for_target tgt)
  if(NOT TARGET ${tgt})
    message(STATUS "brand_assets_for_target: target '${tgt}' not found; skipping")
    return()
  endif()

  target_sources(${tgt} PRIVATE "${BRAND_WORDMARK}" "${BRAND_MARK}")

  if(APPLE)
    set_source_files_properties("${BRAND_WORDMARK}" PROPERTIES MACOSX_PACKAGE_LOCATION "Resources/icons")
    set_source_files_properties("${BRAND_MARK}"     PROPERTIES MACOSX_PACKAGE_LOCATION "Resources/icons")
  endif()

  install(
    FILES "${BRAND_WORDMARK}" "${BRAND_MARK}"
    DESTINATION "share/libreslicer/resources/icons"
  )

  if(OFFICIAL_BRAND)
    target_compile_definitions(${tgt} PRIVATE LIBRESLICER_OFFICIAL_BRAND=1)
  endif()
endfunction()
