# ----------------------------------------------------------------------------
# umm_malloc makefile
# (c)2006-2023 by Ralph Hempel, Owen Sound, Canada
# rhempel@hempeldesigngroup.com
#
# This is designed to be included as part of a make system designed
# to be expandable and maintainable using techniques found in:
#
# Managing Projects with GNU Make - Robert Mecklenburg - ISBN 0-596-00610-1
# ----------------------------------------------------------------------------

MODULE := umm_malloc

MODULE_PATH := $(call make_current_module_path)
$(info MODULE_PATH is $(MODULE_PATH))

$(MODULE)_PATH := $(MODULE_PATH)
$(info $(MODULE)_PATH is $($(MODULE)_PATH))

# ----------------------------------------------------------------------------
# Source file lists go here, C dependencies are automatically generated
# by the compiler using the -m option
#
# You can set up a common source path late in the file
#
# Note that each module gets its own, privately scoped variable for building
# ----------------------------------------------------------------------------

# We need both else a previous definition is used :-) Can we make this an include?

SRC_C :=  
SRC_ASM :=  
SRC_TEST :=

# Here is where we begin to add files to list of sources

SRC_C += src/umm_malloc.c

SRC_TEST += unittest/test_FirstMalloc.c
SRC_TEST += unittest/test_TooBigMalloc.c
SRC_TEST += unittest/test_Free.c
SRC_TEST += unittest/test_Realloc.c
SRC_TEST += unittest/test_MultiMalloc.c
SRC_TEST += unittest/test_Metrics.c
SRC_TEST += unittest/test_Poison.c
SRC_TEST += unittest/test_Stress.c
SRC_TEST += unittest/support_umm_malloc.c
SRC_TEST += unittest/main.c

# ----------------------------------------------------------------------------
# Set up the module level specifics for the source, include, and object paths

$(MODULE)_SRCPATH :=
$(MODULE)_SRCPATH += $(MODULE_PATH)/src

$(MODULE)_INCPATH :=

ifneq (host,$(MCU))
  $(MODULE)_INCPATH += $(umm_libc_PATH)/include
endif

ifeq (unittest,$(MAKECMDGOALS))
  $(MODULE)_SRCPATH += $(MODULE_PATH)/unittest

  $(MODULE)_INCPATH += $(MODULE_PATH)/src
  $(MODULE)_INCPATH += $(MODULE_PATH)/unittest
endif

# ----------------------------------------------------------------------------
# NOTE: The default config file must be created somehow - it is normally
#       up to the developer to specify which defines are needed and how they
#       are to be configured.
#
# By convention we place config files in product/$(PRODUCT)/config/$(MCU) because
# that's an easy pace to leave things like HAL config, linker scripts etc

$(MODULE)_INCPATH += product/$(PRODUCT)/config/$(MCU)

# ----------------------------------------------------------------------------
# Set any module level compile time defaults here

$(MODULE)_CDEFS :=
$(MODULE)_CDEFS +=

$(MODULE)_CFLAGS :=
$(MODULE)_CFLAGS += -Wno-builtin-declaration-mismatch

ifeq (unittest,$(MAKECMDGOALS))
  $(MODULE)_CDEFS +=
endif

# ----------------------------------------------------------------------------
# Include the adaptabuild library makefile - must be done for each module!

include $(ADAPTABUILD_PATH)/make/library.mak

# ----------------------------------------------------------------------------
# Include the unit test framework makefile that works for this module
# if the target is unittest

ifeq (unittest,$(MAKECMDGOALS))
  TESTABLE_MODULES += $(MODULE)
  $(MODULE)_test_main = $(MODULE)/unittest/main.o
  include $(ADAPTABUILD_PATH)/make/test/cpputest.mak
endif

# ----------------------------------------------------------------------------
