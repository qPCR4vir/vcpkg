include(vcpkg_common_functions)
set(GEOS_VERSION 3.6.2)

vcpkg_download_distfile(ARCHIVE
    URLS "http://download.osgeo.org/geos/geos-${GEOS_VERSION}.tar.bz2"
    FILENAME "geos-${GEOS_VERSION}.tar.bz2"
    SHA512 515d8700b8a28282678e481faee355e3a43d7b70160472a63335b8d7225d9ba10437be782378f18f31a15288118126d411a2d862f01ce35d27c96f6bc0a73016
)
vcpkg_extract_source_archive_ex(
    OUT_SOURCE_PATH SOURCE_PATH
    ARCHIVE ${ARCHIVE}
    REF ${GEOS_VERSION}
    PATCHES geos_c-static-support.patch
)

file(WRITE ${SOURCE_PATH}/cmake/modules/GenerateSourceGroups.cmake "function(GenerateSourceGroups)\nendfunction()\n")

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
    OPTIONS
        -DCMAKE_DEBUG_POSTFIX=d
        -DGEOS_ENABLE_TESTS=False
)
vcpkg_install_cmake()
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)

# Handle copyright
file(COPY ${SOURCE_PATH}/COPYING DESTINATION ${CURRENT_PACKAGES_DIR}/share/geos)
file(RENAME ${CURRENT_PACKAGES_DIR}/share/geos/COPYING ${CURRENT_PACKAGES_DIR}/share/geos/copyright)

if(VCPKG_LIBRARY_LINKAGE STREQUAL dynamic)
    file(REMOVE ${CURRENT_PACKAGES_DIR}/lib/libgeos.lib ${CURRENT_PACKAGES_DIR}/debug/lib/libgeosd.lib)
else()
    file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/bin ${CURRENT_PACKAGES_DIR}/debug/bin)
    file(REMOVE ${CURRENT_PACKAGES_DIR}/lib/geos.lib ${CURRENT_PACKAGES_DIR}/debug/lib/geosd.lib)
    file(REMOVE ${CURRENT_PACKAGES_DIR}/lib/geos_c.lib ${CURRENT_PACKAGES_DIR}/debug/lib/geos_cd.lib)
endif()

vcpkg_copy_pdbs()
