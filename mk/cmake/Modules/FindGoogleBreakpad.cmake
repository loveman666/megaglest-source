# -*- cmake -*-

# - Find Google BreakPad
# Find the Google BreakPad includes and library
# This module defines
#  BREAKPAD_EXCEPTION_HANDLER_INCLUDE_DIR, where to find exception_handler.h, etc.
#  BREAKPAD_EXCEPTION_HANDLER_LIBRARIES, the libraries needed to use Google BreakPad.
#  BREAKPAD_EXCEPTION_HANDLER_FOUND, If false, do not try to use Google BreakPad.
# also defined, but not for general use are
#  BREAKPAD_EXCEPTION_HANDLER_LIBRARY, where to find the Google BreakPad library.

SET(BREAKPAD_OS "linux")
IF(WIN32)
        SET(BREAKPAD_OS "windows")
ELSEIF(APPLE)
        SET(BREAKPAD_OS "mac")
ENDIF()

FIND_PATH(BREAKPAD_INCLUDE_DIR
	#common/breakpad_types.h
        client/${BREAKPAD_OS}/handler/exception_handler.h
	PATHS
	${BREAKPAD_ROOT}/src/
        /usr/local/include/google-breakpad/
        /usr/include/google-breakpad/
        /usr/local/include/
        /usr/include/

)

IF(NOT GoogleBreakpad_FIND_COMPONENTS)
	#SET(GoogleBreakpad_FIND_COMPONENTS common exception_handler client)
        SET(GoogleBreakpad_FIND_COMPONENTS client)
ENDIF()

#IF(CMAKE_TRACE)
	MESSAGE(STATUS "BREAKPAD_ROOT=${BREAKPAD_ROOT} Operating system: ${BREAKPAD_OS}")
	MESSAGE(STATUS "BREAKPAD_INCLUDE_DIR=${BREAKPAD_INCLUDE_DIR}")
#ENDIF(CMAKE_TRACE)

IF(BREAKPAD_INCLUDE_DIR)
        SET(BREAKPAD_EXCEPTION_HANDLER_INCLUDE_DIR ${BREAKPAD_INCLUDE_DIR} ${BREAKPAD_INCLUDE_DIR}/client/${BREAKPAD_OS}/)
	SET(BREAKPAD_FOUND TRUE)

        MESSAGE(STATUS "*** FOUND BREAKPAD_INCLUDE_DIR=${BREAKPAD_INCLUDE_DIR}")

	FOREACH(COMPONENT ${GoogleBreakpad_FIND_COMPONENTS})
		#string(TOUPPER ${COMPONENT} UPPERCOMPONENT)
                string(TOLOWER ${COMPONENT} UPPERCOMPONENT)
		FIND_LIBRARY(BREAKPAD_${UPPERCOMPONENT}_LIBRARY_RELEASE 
			NAMES ${COMPONENT} libbreakpad_${COMPONENT}.a libbreakpad${COMPONENT}.a
			PATHS
				${BREAKPAD_ROOT}/src/client/${BREAKPAD_OS}/Release/lib
				${BREAKPAD_INCLUDE_DIR}/src/client/${BREAKPAD_OS}/Release/lib
				${BREAKPAD_ROOT}/src/client/${BREAKPAD_OS}/
				${BREAKPAD_INCLUDE_DIR}/src/client/${BREAKPAD_OS}/
                                /usr/local/lib/google-breakpad/
                                /usr/lib/google-breakpad/
                                /usr/local/lib/
                                /usr/lib/

			)
		FIND_LIBRARY(BREAKPAD_${UPPERCOMPONENT}_LIBRARY_DEBUG 
			NAMES ${COMPONENT} libbreakpad_${COMPONENT}.a libbreakpad${COMPONENT}.a
			PATHS
				${BREAKPAD_ROOT}/src/client/${BREAKPAD_OS}/Debug/lib
				${BREAKPAD_INCLUDE_DIR}/src/client/${BREAKPAD_OS}/Debug/lib
				${BREAKPAD_ROOT}/src/client/${BREAKPAD_OS}/
				${BREAKPAD_INCLUDE_DIR}/src/client/${BREAKPAD_OS}/
                                /usr/local/lib/google-breakpad/
                                /usr/lib/google-breakpad/
                                /usr/local/lib/
                                /usr/lib/

			)
		IF(BREAKPAD_${UPPERCOMPONENT}_LIBRARY_RELEASE OR BREAKPAD_${UPPERCOMPONENT}_LIBRARY_DEBUG)
			SET(BREAKPAD_${UPPERCOMPONENT}_FOUND TRUE)
			SET(BREAKPAD_${UPPERCOMPONENT}_LIBRARY optimized ${BREAKPAD_${UPPERCOMPONENT}_LIBRARY_RELEASE} debug ${BREAKPAD_${UPPERCOMPONENT}_LIBRARY_DEBUG})
			set(BREAKPAD_${UPPERCOMPONENT}_LIBRARY ${BREAKPAD_${UPPERCOMPONENT}_LIBRARY} CACHE FILEPATH "The breakpad ${UPPERCOMPONENT} library")

                        set(BREAKPAD_EXCEPTION_HANDLER_FOUND TRUE)
                        set(BREAKPAD_EXCEPTION_HANDLER_LIBRARIES ${BREAKPAD_EXCEPTION_HANDLER_LIBRARIES} ${BREAKPAD_${UPPERCOMPONENT}_LIBRARY_RELEASE})

                        MESSAGE(STATUS "*** FOUND BREAKPAD LIB ${BREAKPAD_${UPPERCOMPONENT}_LIBRARY}")

		ELSE()
			SET(BREAKPAD_FOUND FALSE)
			SET(BREAKPAD_${UPPERCOMPONENT}_FOUND FALSE)
			SET(BREAKPAD_${UPPERCOMPONENT}_LIBRARY "${BREAKPAD_${UPPERCOMPONENT}_LIBRARY_RELEASE-NOTFOUND}")

		ENDIF()

#		IF(CMAKE_TRACE)
			MESSAGE(STATUS "Looking for ${UPPERCOMPONENT}")
			MESSAGE(STATUS "BREAKPAD_${UPPERCOMPONENT}_LIBRARY_RELEASE=${BREAKPAD_${UPPERCOMPONENT}_LIBRARY_RELEASE}")
			MESSAGE(STATUS "BREAKPAD_INCLUDE_DIR=${BREAKPAD_INCLUDE_DIR}")
#		ENDIF(CMAKE_TRACE)
	ENDFOREACH(COMPONENT)
ENDIF(BREAKPAD_INCLUDE_DIR)

IF(BREAKPAD_FOUND)
#	IF(CMAKE_TRACE)
		MESSAGE(STATUS "Looking for dump-symbols in: ${BREAKPAD_INCLUDE_DIR}/tools/${BREAKPAD_OS}/" )
#	ENDIF(CMAKE_TRACE)
	FIND_PROGRAM(BREAKPAD_DUMPSYMS_EXE 
		dump_syms NAMES dumpsyms dump_syms.exe
		PATHS 
			ENV 
			PATH 
			${BREAKPAD_ROOT}/tools/${BREAKPAD_OS}/binaries
			${BREAKPAD_INCLUDE_DIR}/tools/${BREAKPAD_OS}/binaries
			${BREAKPAD_ROOT}/tools/${BREAKPAD_OS}/dump_syms
			${BREAKPAD_INCLUDE_DIR}/tools/${BREAKPAD_OS}/dump_syms
			${BREAKPAD_ROOT}/src/tools/${BREAKPAD_OS}/binaries
			${BREAKPAD_INCLUDE_DIR}/src/tools/${BREAKPAD_OS}/binaries
			${BREAKPAD_ROOT}/src/tools/${BREAKPAD_OS}/dump_syms
			${BREAKPAD_INCLUDE_DIR}/src/tools/${BREAKPAD_OS}/dump_syms
                        /usr/local/bin/
                        /usr/bin/

		)
#	IF(CMAKE_TRACE)
		MESSAGE(STATUS "Looking for dump-symbols result: ${BREAKPAD_DUMPSYMS_EXE}" )
#	ENDIF(CMAKE_TRACE)
	IF(BREAKPAD_DUMPSYMS_EXE)
		SET(BREAKPAD_DUMPSYMS_EXE_FOUND TRUE)

                MESSAGE(STATUS "*** FOUND BREAKPAD TOOLS ${BREAKPAD_DUMPSYMS_EXE}}")

	ELSE(BREAKPAD_DUMPSYMS_EXE)
		SET(BREAKPAD_DUMPSYMS_EXE_FOUND FALSE)
		#SET(BREAKPAD_FOUND FALSE)
	ENDIF(BREAKPAD_DUMPSYMS_EXE)
ENDIF(BREAKPAD_FOUND)

