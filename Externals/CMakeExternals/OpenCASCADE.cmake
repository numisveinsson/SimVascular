# Copyright (c) 2014-2015 The Regents of the University of California.
# All Rights Reserved.
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject
# to the following conditions:
#
# The above copyright notice and this permission notice shall be included
# in all copies or substantial portions of the Software.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
# IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED
# TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
# PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER
# OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
# EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
# PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
# PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
# LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
# NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
#-----------------------------------------------------------------------------
# OpenCASCADE
set(proj OpenCASCADE)

# Dependencies
set(${proj}_DEPENDENCIES "VTK")
if(${SV_EXTERNALS_ENABLE_TCL})
  set(${proj}_DEPENDENCIES
    ${${proj}_DEPENDENCIES} "TCL")
endif()
if(${SV_EXTERNALS_ENABLE_TK})
  set(${proj}_DEPENDENCIES
    ${${proj}_DEPENDENCIES} "TK")
endif()
if(${SV_EXTERNALS_ENABLE_FREETYPE})
  set(${proj}_DEPENDENCIES
    ${${proj}_DEPENDENCIES} "FREETYPE")
endif()

# Git info
set(SV_EXTERNALS_${proj}_SOURCE_URL "${SV_EXTERNALS_ORIGINALS_URL}/opencascade/opencascade-${SV_EXTERNALS_${proj}_VERSION}.tar.gz" CACHE STRING "Location of ${proj}, can be web address or local path")
mark_as_advanced(SV_EXTERNALS_${proj}_SOURCE_URL)

#If using TCL
if(SV_EXTERNALS_ENABLE_TCL)
  list(APPEND SV_EXTERNALS_${proj}_ADDITIONAL_CMAKE_ARGS
    -D3RDPARTY_TCL_DIR:PATH=${SV_EXTERNALS_TCL_BIN_DIR}
    -D3RDPARTY_TCL_DLL:FILEPATH=${SV_EXTERNALS_TCL_LIBRARY}
    -D3RDPARTY_TCL_DLL_DIR:PATH=${SV_EXTERNALS_TCL_LIBRARY_DIR}
    -D3RDPARTY_TCL_INCLUDE_DIR:PATH=${SV_EXTERNALS_TCL_INCLUDE_DIR}
    -D3RDPARTY_TCL_LIBRARY:FILEPATH=${SV_EXTERNALS_TCL_LIBRARY}
    -D3RDPARTY_TCL_LIBRARY_DIR:PATH=${SV_EXTERNALS_TCL_LIBRARY_DIR}
    )
endif()

#If using TK
if(SV_EXTERNALS_ENABLE_TK)
  list(APPEND SV_EXTERNALS_${proj}_ADDITIONAL_CMAKE_ARGS
    -D3RDPARTY_TK_DIR:PATH=${SV_EXTERNALS_TK_BIN_DIR}
    -D3RDPARTY_TK_DLL:FILEPATH=${SV_EXTERNALS_TK_LIBRARY}
    -D3RDPARTY_TK_DLL_DIR:PATH=${SV_EXTERNALS_TK_LIBRARY_DIR}
    -D3RDPARTY_TK_INCLUDE_DIR:PATH=${SV_EXTERNALS_TK_INCLUDE_DIR}
    -D3RDPARTY_TK_LIBRARY:FILEPATH=${SV_EXTERNALS_TK_LIBRARY}
    -D3RDPARTY_TK_LIBRARY_DIR:PATH=${SV_EXTERNALS_TK_LIBRARY_DIR}
    )
endif()

#If using FREETYPE
if(SV_EXTERNALS_ENABLE_FREETYPE)
  list(APPEND SV_EXTERNALS_${proj}_ADDITIONAL_CMAKE_ARGS
    -D3RDPARTY_FREETYPE_DIR:PATH=${SV_EXTERNALS_FREETYPE_BIN_DIR}
    -D3RDPARTY_FREETYPE_DLL:FILEPATH=${SV_EXTERNALS_FREETYPE_LIBRARY}
    -D3RDPARTY_FREETYPE_DLL_DIR:PATH=${SV_EXTERNALS_FREETYPE_LIBRARY_DIR}
    -D3RDPARTY_FREETYPE_INCLUDE_DIR_freetype2:PATH=${SV_EXTERNALS_FREETYPE_INCLUDE_DIR}
    -D3RDPARTY_FREETYPE_INCLUDE_DIR_ft2build:PATH=${SV_EXTERNALS_FREETYPE_INCLUDE_DIR}
    -D3RDPARTY_FREETYPE_LIBRARY:FILEPATH=${SV_EXTERNALS_FREETYPE_LIBRARY}
    -D3RDPARTY_FREETYPE_LIBRARY_DIR:PATH=${SV_EXTERNALS_FREETYPE_LIBRARY_DIR}
    )
endif()

# Add external project
if(SV_EXTERNALS_DOWNLOAD_${proj})
  ExternalProject_Add(${proj}
    URL ${SV_EXTERNALS_${proj}_BINARIES_URL}
    PREFIX ${SV_EXTERNALS_${proj}_PFX_DIR}
    SOURCE_DIR ${SV_EXTERNALS_${proj}_BIN_DIR}
    BINARY_DIR ${SV_EXTERNALS_${proj}_BLD_DIR}
    DEPENDS ${${proj}_DEPENDENCIES}
    CONFIGURE_COMMAND ""
    BUILD_COMMAND ""
    INSTALL_COMMAND ""
    UPDATE_COMMAND ""
    )
else()
  ExternalProject_Add(${proj}
    URL ${SV_EXTERNALS_${proj}_SOURCE_URL}
    PREFIX ${SV_EXTERNALS_${proj}_PFX_DIR}
    SOURCE_DIR ${SV_EXTERNALS_${proj}_SRC_DIR}
    BINARY_DIR ${SV_EXTERNALS_${proj}_BLD_DIR}
    DEPENDS ${${proj}_DEPENDENCIES}
    UPDATE_COMMAND ""
    CMAKE_CACHE_ARGS
      -DCMAKE_CXX_COMPILER:STRING=${CMAKE_CXX_COMPILER}
      -DCMAKE_C_COMPILER:STRING=${CMAKE_C_COMPILER}
      -DCMAKE_CXX_FLAGS:STRING=${CMAKE_CXX_FLAGS}
      -DCMAKE_C_FLAGS:STRING=${CMAKE_C_FLAGS}
      -DCMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}
      -DCMAKE_MACOSX_RPATH:BOOL=ON
      -DUSE_VTK:BOOL=${SV_EXTERNALS_ENABLE_VTK}
      -DBUILD_MODULE_Draw:BOOL=OFF
      -D3RDPARTY_DIR:PATH=${SV_EXTERNALS_TOPLEVEL_DIR}
      -D3RDPARTY_VTK_DIR:PATH=${SV_EXTERNALS_VTK_BIN_DIR}
      -D3RDPARTY_VTK_DLL_DIR:PATH=${SV_EXTERNALS_VTK_LIBRARY_DIR}
      -D3RDPARTY_VTK_INCLUDE_DIR:PATH=${SV_EXTERNALS_VTK_INCLUDE_DIR}
      -D3RDPARTY_VTK_LIBRARY_DIR:PATH=${SV_EXTERNALS_VTK_LIBRARY_DIR}
      -DINSTALL_DIR:PATH=${SV_EXTERNALS_${proj}_BIN_DIR}
      -DINSTALL_DIR_BIN:PATH=bin
      -DINSTALL_DIR_LIB:PATH=lib
      ${SV_EXTERNALS_${proj}_ADDITIONAL_CMAKE_ARGS}
    )
endif()
