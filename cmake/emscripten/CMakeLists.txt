# ################################################################
# zstd - Makefile
# Copyright (C) Yann Collet 2014-2015
# All rights reserved.
#
# BSD license
#
# Redistribution and use in source and binary forms, with or without modification,
# are permitted provided that the following conditions are met:
#
# * Redistributions of source code must retain the above copyright notice, this
#   list of conditions and the following disclaimer.
#
# * Redistributions in binary form must reproduce the above copyright notice, this
#   list of conditions and the following disclaimer in the documentation and/or
#   other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR
# ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
# ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
# You can contact the author at :
#  - zstd source repository : https://github.com/Cyan4973/zstd
#  - Public forum : https://groups.google.com/forum/#!forum/lz4c
# ################################################################

PROJECT(emscripten)

SET(CMAKE_INCLUDE_CURRENT_DIR TRUE)

# Define project root directory
SET(ROOT_DIR ../../zstd)

# Define programs directory, where sources and header files are located
SET(EMSCRIPTEN_DIR ${ROOT_DIR}/../emscripten)
INCLUDE_DIRECTORIES(${EMSCRIPTEN_DIR})

IF (WORKAROUND_OUTDATED_CODE_STYLE)
    # Define library directory, where sources and header files are located
    SET(LIBRARY_DIR ${ROOT_DIR}/lib)
    INCLUDE_DIRECTORIES(${LIBRARY_DIR})
ENDIF (WORKAROUND_OUTDATED_CODE_STYLE)

#IF (ZSTD_LEGACY_SUPPORT)
#    SET(PROGRAMS_LEGACY_DIR ${PROGRAMS_DIR}/legacy)
#    INCLUDE_DIRECTORIES(${PROGRAMS_LEGACY_DIR})
#
#   IF (WORKAROUND_OUTDATED_CODE_STYLE)
#        INCLUDE_DIRECTORIES(${LIBRARY_DIR}/legacy)
#    ENDIF (WORKAROUND_OUTDATED_CODE_STYLE)
#
#    SET(ZSTD_FILEIO_LEGACY ${PROGRAMS_LEGACY_DIR}/fileio_legacy.c)
#ENDIF (ZSTD_LEGACY_SUPPORT)

if (EMSCRIPTEN)
    set(CMAKE_AR "emcc")
    set(CMAKE_STATIC_LIBRARY_SUFFIX ".bc")
    set(CMAKE_C_CREATE_STATIC_LIBRARY "<CMAKE_AR> -o <TARGET> <LINK_FLAGS> <OBJECTS>")
    set(CMAKE_CXX_CREATE_STATIC_LIBRARY "<CMAKE_AR> -o <TARGET> <LINK_FLAGS> <OBJECTS>")
endif()

get_filename_component(EXPORTED_FUNCTIONS_FILE "${ROOT_DIR}/../exported_functions.txt" REALPATH)
get_filename_component(COMPRESS_EXPORTED_FUNCTIONS_FILE "${ROOT_DIR}/../exported_functions_compress.txt" REALPATH)
get_filename_component(DECOMPRESS_EXPORTED_FUNCTIONS_FILE "${ROOT_DIR}/../exported_functions_decompress.txt" REALPATH)

ADD_EXECUTABLE(zstd ${EMSCRIPTEN_DIR}/zstd.js.c)
SET(CFLAGS_A "--bind -O2 -s EXPORT_NAME=\"'ZSTD'\" -s TOTAL_MEMORY=128MB -s ALLOW_MEMORY_GROWTH=1 -s MODULARIZE=1 -s DISABLE_EXCEPTION_CATCHING=1 --memory-init-file 0 -s EXPORTED_FUNCTIONS=@${EXPORTED_FUNCTIONS_FILE}")
SET_TARGET_PROPERTIES(zstd PROPERTIES LINK_FLAGS ${CFLAGS_A})
TARGET_LINK_LIBRARIES(zstd libzstd_static)

ADD_EXECUTABLE(zstd_compress ${EMSCRIPTEN_DIR}/zstd.js.c)
SET(CFLAGS_B "--bind -O2 -s EXPORT_NAME=\"'ZSTD'\" -s TOTAL_MEMORY=128MB -s ALLOW_MEMORY_GROWTH=1 -s MODULARIZE=1 -s DISABLE_EXCEPTION_CATCHING=1 --memory-init-file 0 -s EXPORTED_FUNCTIONS=@${COMPRESS_EXPORTED_FUNCTIONS_FILE}")
SET_TARGET_PROPERTIES(zstd_compress PROPERTIES LINK_FLAGS ${CFLAGS_B})
TARGET_LINK_LIBRARIES(zstd_compress libzstd_compress_static)

ADD_EXECUTABLE(zstd_decompress ${EMSCRIPTEN_DIR}/zstd.js.c)
SET(CFLAGS_C "--bind -Oz -s EXPORT_NAME=\"'ZSTD'\" -s TOTAL_MEMORY=16MB -s ALLOW_MEMORY_GROWTH=0 -s MODULARIZE=1 -s DISABLE_EXCEPTION_CATCHING=1 --memory-init-file 0 -s EXPORTED_FUNCTIONS=@${DECOMPRESS_EXPORTED_FUNCTIONS_FILE}")
SET_TARGET_PROPERTIES(zstd_decompress PROPERTIES LINK_FLAGS ${CFLAGS_C})
TARGET_LINK_LIBRARIES(zstd_decompress libzstd_decompress_static)

ADD_EXECUTABLE(zstd_min ${EMSCRIPTEN_DIR}/zstd.js.c)
SET(CFLAGS_D "--bind -Oz -s EXPORT_NAME=\"'ZSTD'\" -s TOTAL_MEMORY=128MB -s ALLOW_MEMORY_GROWTH=1 -s MODULARIZE=1 -s DISABLE_EXCEPTION_CATCHING=1 --memory-init-file 0 -s EXPORTED_FUNCTIONS=@${EXPORTED_FUNCTIONS_FILE}")
SET_TARGET_PROPERTIES(zstd_min PROPERTIES LINK_FLAGS ${CFLAGS_D})
TARGET_LINK_LIBRARIES(zstd_min libzstd_min_static)
