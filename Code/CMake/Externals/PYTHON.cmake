# Copyright (c) Stanford University, The Regents of the University of
#               California, and others.
#
# All Rights Reserved.
#
# See Copyright-SimVascular.txt for additional details.
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

#-----------------------------------------------------------------------------
# PYTHON
set(proj PYTHON)

if(SV_USE_${proj})

  # If using toplevel dir, foce PYTHON_DIR to be the SV_PYTHON_DIR set by the
  # simvascular_add_new_external macro
  if(SV_EXTERNALS_USE_TOPLEVEL_BIN_DIR)
    set(${proj}_DIR ${SV_${proj}_DIR} CACHE PATH "Force ${proj} dir to externals" FORCE)
  endif()

  # Find Python
  if(NOT WIN32)

    simvascular_external(${proj}
      SHARED_LIB ${SV_USE_${proj}_SHARED}
      VERSION ${${proj}_VERSION}
      REQUIRED
      )

    # Set SV_PYTHON_DIR to the directory that was found to contain PYTHON
    set(SV_${proj}_DIR ${${proj}_DIR})
  endif()

  if(WIN32)
    message("manually set PYTHON variables ${SV_${proj}_DIR}")
    set(PYTHON_DEBUG_LIBRARY "" CACHE FILEPATH "doc string" FORCE)
    set(PYTHON_INCLUDE_DIR   ${SV_${proj}_DIR}/include CACHE PATH "doc string" FORCE)
    set(PYTHON_INCLUDE_PATH  ${SV_${proj}_DIR}/include CACHE PATH "doc string" FORCE)
    if(SV_EXTERNALS_VERSION_NUMBER VERSION_EQUAL "2018.01")
      set(PYTHON_LIBRARY       ${SV_${proj}_DIR}/libs/python27.lib CACHE FILEPATH "doc string" FORCE)
    elseif(SV_EXTERNALS_VERSION_NUMBER VERSION_EQUAL "2018.05")
      set(PYTHON_LIBRARY       ${SV_${proj}_DIR}/libs/python35.lib CACHE FILEPATH "doc string" FORCE)
    else()
      message(FATAL_ERROR "Unsupported SV_EXTERNALS_VERSION_NUMBER ($SV_EXTERNALS_VERSION_NUMBER) in PYTHON.cmake")
    endif()
    set(PYTHON_LIBRARY_DEBUG "" CACHE FILEPATH "doc string" FORCE)
    set(PYTHON_SITE_PACKAGES ${SV_${proj}_DIR}/lib/site-packages CACHE PATH "doc string" FORCE)
    set(PYTHON_CORE_PACKAGES ${SV_${proj}_DIR}/lib CACHE PATH "doc string" FORCE)
    set(PYTHON_DLL_PATH      ${SV_${proj}_DIR}/bin CACHE PATH "doc string" FORCE)
    set(PYTHON_EXECUTABLE    ${SV_${proj}_DIR}/bin/python.exe CACHE FILEPATH "doc string" FORCE)
    link_directories(${${proj}_LIBRARY})
    include_directories(${${proj}_INCLUDE_DIR})
  endif()

  # Need to make sure we pick up python module from vtk
  set(VTK_${proj}_MODULES vtkWrappingPythonCore)

endif()
#-----------------------------------------------------------------------------
