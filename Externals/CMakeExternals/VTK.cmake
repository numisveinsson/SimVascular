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
# VTK
set(proj VTK)

# Dependencies
set(${proj}_DEPENDENCIES "")
if(SV_EXTERNALS_ENABLE_TCL)
  set(${proj}_DEPENDENCIES
    ${${proj}_DEPENDENCIES} "TCL")
endif()
if(SV_EXTERNALS_ENABLE_TCLLIB)
  set(${proj}_DEPENDENCIES
    ${${proj}_DEPENDENCIES} "TCLLIB")
endif()
if(SV_EXTERNALS_ENABLE_TK)
  set(${proj}_DEPENDENCIES
    ${${proj}_DEPENDENCIES} "TK")
endif()
if(SV_EXTERNALS_ENABLE_TKLIB)
  set(${proj}_DEPENDENCIES
    ${${proj}_DEPENDENCIES} "TKLIB")
endif()
if(SV_EXTERNALS_ENABLE_PYTHON)
  set(${proj}_DEPENDENCIES
    ${${proj}_DEPENDENCIES} "PYTHON")
endif()
if(SV_EXTERNALS_ENABLE_PIP)
  set(${proj}_DEPENDENCIES
    ${${proj}_DEPENDENCIES} "PIP")
endif()
if(SV_EXTERNALS_ENABLE_NUMPY)
  set(${proj}_DEPENDENCIES
    ${${proj}_DEPENDENCIES} "NUMPY")
endif()
if(SV_EXTERNALS_ENABLE_GDCM)
  set(${proj}_DEPENDENCIES
    ${${proj}_DEPENDENCIES} "GDCM")
endif()
if(SV_EXTERNALS_ENABLE_FREETYPE)
  set(${proj}_DEPENDENCIES
    ${${proj}_DEPENDENCIES} "FREETYPE")
endif()
if(SV_EXTERNALS_ENABLE_Qt)
  set(${proj}_DEPENDENCIES
    ${${proj}_DEPENDENCIES} "Qt")
endif()

# Git info
#set(SV_EXTERNALS_${proj}_GIT_URL "${SV_EXTERNALS_GIT_URL}/VTK.git" CACHE STRING "Location of ${proj}, can be web address or local path")
#mark_as_advanced(SV_EXTERNALS_${proj}_GIT_URL)
#set(SV_EXTERNALS_${proj}_GIT_TAG "simvascular-patch-6.2" CACHE STRING "Tag for ${proj}")
#mark_as_advanced(SV_EXTERNALS_${proj}_GIT_TAG)
set(SV_EXTERNALS_${proj}_SOURCE_URL "${SV_EXTERNALS_ORIGINALS_URL}/vtk/VTK-${SV_EXTERNALS_${proj}_VERSION}.tar.gz" CACHE STRING "Location of ${proj}, can be web address or local path")
mark_as_advanced(SV_EXTERNALS_${proj}_SOURCE_URL)

# Platform specific additions
set(SV_EXTERNALS_${proj}_ADDITIONAL_CMAKE_ARGS )
if(APPLE)
elseif(LINUX)
elseif(WIN32)
  if(NOT SV_EXTERNALS_TK_INTERNAL_PATH)
    set(SV_EXTERNALS_TK_INTERNAL_PATH ${SV_EXTERNALS_TK_BIN_DIR}/internals/tk${SV_EXTERNALS_TK_MAJOR_VERSION}.${SV_EXTERNALS_TK_MINOR_VERSION})
    set(VTK_TK_INTERNAL_PATH_DEFINE  "-DTK_INTERNAL_PATH:PATH=${SV_EXTERNALS_TK_INTERNAL_PATH}")
  endif()
  if(NOT SV_EXTERNALS_TK_XLIB_PATH)
    set(SV_EXTERNALS_TK_XLIB_PATH ${SV_EXTERNALS_TK_BIN_DIR})
    set(VTK_TK_XLIB_PATH_DEFINE  "-DTK_XLIB_PATH:PATH=${SV_EXTERNALS_TK_XLIB_PATH}")
  endif()
  # see http://bugs.mitk.org/show_bug.cgi?id=17858
  list(APPEND SV_EXTERNALS_${proj}_ADDITIONAL_CMAKE_ARGS
    -DVTK_DO_NOT_DEFINE_OSTREAM_SLL:BOOL=ON
    -DVTK_DO_NOT_DEFINE_OSTREAM_ULL:BOOL=ON
      )
elseif(MINGW)
  list(APPEND SV_EXTERNALS_${proj}_ADDITIONAL_CMAKE_ARGS
    -DCMAKE_USE_WIN32_THREADS:BOOL=ON
    -DCMAKE_USE_PTHREADS:BOOL=OFF
    -DVTK_USE_VIDEO4WINDOWS:BOOL=OFF # no header files provided by MinGW
    )
endif()

#If using Qt
if(SV_EXTERNALS_USE_QT)
  #MINGW specific flags
  if(MINGW)
    list(APPEND SV_EXTERNALS_${proj}_ADDITIONAL_CMAKE_ARGS
      -DCMAKE_USE_WIN32_THREADS:BOOL=ON
      -DCMAKE_USE_PTHREADS:BOOL=OFF
      -DVTK_USE_VIDEO4WINDOWS:BOOL=OFF # no header files provided by MinGW
      )
  endif()
  #WIN32 specific flags
  if(WIN32)
    list(APPEND SV_EXTERNALS_${proj}_ADDITIONAL_CMAKE_ARGS
      -DVTK_DO_NOT_DEFINE_OSTREAM_SLL:BOOL=ON
      -DVTK_DO_NOT_DEFINE_OSTREAM_ULL:BOOL=ON
      )
  endif()

  foreach(comp ${SV_EXTERNALS_Qt5_COMPONENTS})
    #if(Qt5${comp}_LIBRARIES)
    list(APPEND SV_EXTERNALS_${proj}_ADDITIONAL_CMAKE_ARGS
      -DQt5${comp}_DIR:PATH=${SV_EXTERNALS_Qt_TOPLEVEL_CMAKE_DIR}/Qt5${comp}
      )
      #-DQt5${comp}_DIR:PATH=${Qt5${comp}_DIR}
    #endif()
  endforeach()

  list(APPEND SV_EXTERNALS_${proj}_ADDITIONAL_CMAKE_ARGS
    -DQt5_DIR:PATH:STRING=${SV_EXTERNALS_Qt_CMAKE_DIR}
    -DVTK_QT_VERSION:STRING=5
    -DCMAKE_PREFIX_PATH:PATH=${CMAKE_PREFIX_PATH}
    -DQT_QMAKE_EXECUTABLE:FILEPATH=${SV_EXTERNALS_Qt_QMAKE_EXECUTABLE}
    -DModule_vtkGUISupportQt:BOOL=ON
    -DModule_vtkGUISupportQtWebkit:BOOL=ON
    -DModule_vtkGUISupportQtSQL:BOOL=ON
    -DModule_vtkRenderingQt:BOOL=ON
    -DVTK_Group_Qt:BOOL=ON
    -DModule_vtkTestingRendering:BOOL=ON
    -DVTK_MAKE_INSTANTIATORS:BOOL=ON
    -DVTK_WINDOWS_PYTHON_DEBUGGABLE:BOOL=OFF
    )
endif()

#If using TCL
if(SV_EXTERNALS_ENABLE_TCL)
  list(APPEND SV_EXTERNALS_${proj}_ADDITIONAL_CMAKE_ARGS
    -DTCL_INCLUDE_PATH:PATH=${SV_EXTERNALS_TCL_INCLUDE_DIR}
    -DTCL_LIBRARY:FILEPATH=${SV_EXTERNALS_TCL_LIBRARY}
    -DTCL_TCLSH:FILEPATH=${SV_EXTERNALS_TCLSH_EXECUTABLE}
    )
endif()

#If using TK
if(SV_EXTERNALS_ENABLE_TK)
  list(APPEND SV_EXTERNALS_${proj}_ADDITIONAL_CMAKE_ARGS
    -DTK_INCLUDE_PATH:PATH=${SV_EXTERNALS_TK_INCLUDE_DIR}
    ${VTK_TK_XLIB_PATH_DEFINE}
    ${VTK_TK_INTERNAL_PATH_DEFINE}
    -DTK_LIBRARY:FILEPATH=${SV_EXTERNALS_TK_LIBRARY}
    )
endif()

#If using PYTHON
if(SV_EXTERNALS_ENABLE_PYTHON)
  list(APPEND SV_EXTERNALS_${proj}_ADDITIONAL_CMAKE_ARGS
    -DPYTHON_EXECUTABLE:FILEPATH=${SV_EXTERNALS_PYTHON_EXECUTABLE}
    -DPYTHON_INCLUDE_DIR:PATH=${SV_EXTERNALS_PYTHON_INCLUDE_DIR}
    -DPYTHON_LIBRARIES:FILEPATH=${SV_EXTERNALS_PYTHON_LIBRARY}
    -DPYTHON_LIBRARY:FILEPATH=${SV_EXTERNALS_PYTHON_LIBRARY}
    -DPYTHON_DEBUG_LIBRARY:FILEPATH=""
    -DPYTHON_LIBRARY_DEBUG:FILEPATH=""
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
      -DBUILD_SHARED_LIBS:BOOL=${SV_EXTERNALS_ENABLE_${proj}_SHARED}
      -DVTK_WRAP_TCL:BOOL=${SV_EXTERNALS_ENABLE_TCL}
      -DVTK_Group_Tk:BOOL=${SV_EXTERNALS_ENABLE_TK}
      -DVTK_WRAP_PYTHON:BOOL=${SV_EXTERNALS_ENABLE_PYTHON}
      -DBUILD_TESTING:BOOL=OFF
      -DBUILD_EXAMPLES:BOOL=OFF
      -DCMAKE_INSTALL_PREFIX:STRING=${SV_EXTERNALS_${proj}_BIN_DIR}
      ${SV_EXTERNALS_${proj}_ADDITIONAL_CMAKE_ARGS}
      )
endif()

# VTK variables needed later on
set(SV_EXTERNALS_${proj}_CMAKE_DIR ${SV_EXTERNALS_${proj}_BIN_DIR}/lib/cmake/vtk-${SV_EXTERNALS_${proj}_MAJOR_VERSION}.${SV_EXTERNALS_${proj}_MINOR_VERSION})
set(SV_EXTERNALS_${proj}_LIBRARY_DIR ${SV_EXTERNALS_${proj}_BIN_DIR}/lib)
set(SV_EXTERNALS_${proj}_INCLUDE_DIR ${SV_EXTERNALS_${proj}_BIN_DIR}/include)
