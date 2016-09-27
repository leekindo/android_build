#
#     OPTIMIZATIONS LEVELS!!
#

#######################
### GENERAL SECTION ###
#######################

# General optimization level
LEE_GCC_CFLAGS_OPTI := -O3

# 03
ifeq ($(USE_O3_OPTIMIZATIONS),true)
# General optimization level of target ARM compiled with GCC. Default: -O2
LEE_GCC_CFLAGS_ARM := $(LEE_GCC_CFLAGS_OPTI)

# General optimization level of target THUMB compiled with GCC. Default: -Os
LEE_GCC_CFLAGS_THUMB := $(LEE_GCC_CFLAGS_OPTI)

# Additional flags passed to all C targets compiled with GCC
LEE_GCC_CFLAGS := $(LEE_GCC_CFLAGS_OPTI) -pipe -fgcse-las -fgcse-sm -fipa-pta -fivopts -fomit-frame-pointer -frename-registers -fsection-anchors -ftree-loop-im -ftree-loop-ivcanon -ftree-vectorize -funsafe-loop-optimizations -funswitch-loops -fweb

# Flags passed to all C targets compiled with GCC
LEE_GCC_CPPFLAGS := $(LEE_GCC_CFLAGS_OPTI)

# Flags passed to linker (ld) of all C and C targets compiled with GCC
LEE_GCC_LDFLAGS := -Wl,-O3 -Wl,--as-needed -Wl,--gc-sections -Wl,--relax -Wl,--sort-common

# Flags below are applied to specific targets only, use them if your flag is not compatible for both compilers

# We use GCC 5.3 for arm-linux-androideabi, make sure to remove flags below if you decided to stick with 4.9
# LEE_GCC_CFLAGS_32 := -Wno-error=bool-compare -Wno-error=logical-not-parentheses -Wno-error=sizeof-array-argument

# We use GCC 4.9 for aarch64-linux-android, so we don't have any extra flags for it
# LEE_GCC_CFLAGS_64 := 

#####################
### CLANG SECTION ###
#####################

# Flags passed to all C targets compiled with CLANG
LEE_CLANG_CFLAGS := $(LEE_GCC_CFLAGS_OPTI) -Qunused-arguments -Wno-unknown-warning-option

# Flags passed to all C targets compiled with CLANG
LEE_CLANG_CPPFLAGS := $(LEE_CLANG_CFLAGS)

# Flags passed to linker (ld) of all C and C targets compiled with CLANG
LEE_CLANG_LDFLAGS := $(LEE_GCC_LDFLAGS)
else
LEE_GCC_CFLAGS_ARM := \
	$(LEE_GCC_CFLAGS_OPTI) \
	-fomit-frame-pointer \
	-fstrict-aliasing    \
	-funswitch-loops

LEE_GCC_CFLAGS_THUMB := \
	-mthumb \
	$(LEE_GCC_CFLAGS_OPTI) \
	-fomit-frame-pointer \
	-fno-strict-aliasing

LEE_GCC_CFLAGS := \
	-DNDEBUG \
	-Wstrict-aliasing=2 \
	-fgcse-after-reload \
	-frerun-cse-after-loop \
	-frename-registers

LEE_GCC_CPPFLAGS := \
	-fvisibility-inlines-hidden

LEE_CLANG_CFLAGS :=
LEE_CLANG_CPPFLAGS :=
LEE_CLANG_LDFLAGS :=
endif


# Extra flags
ifeq ($(ENABLE_EXTRAGCC),true)
   LEE_GCC_CFLAGS += -fgcse-las -fgraphite -ffast-math -fgraphite-identity -fgcse-sm -fivopts -fomit-frame-pointer -frename-registers -fsection-anchors -ftracer -ftree-loop-im -ftree-loop-ivcanon -funsafe-loop-optimizations -funswitch-loops -fweb -Wno-error=array-bounds -Wno-error=clobbered -Wno-error=maybe-uninitialized -Wno-error=strict-overflow -frerun-cse-after-loop -ffunction-sections -fdata-sections -fira-loop-pressure -fforce-addr -funroll-loops -ftree-loop-distribution -ffp-contract=fast -mvectorize-with-neon-quad -Wno-unused-parameter -Wno-unused-but-set-variable
   LEE_GCC_CPPFLAGS += -fgcse-las -fgcse-sm -fivopts -fomit-frame-pointer -frename-registers -fsection-anchors -ftracer -ftree-loop-im -ftree-loop-ivcanon -funsafe-loop-optimizations -funswitch-loops -fweb -Wno-error=array-bounds -Wno-error=clobbered -Wno-error=maybe-uninitialized -Wno-error=strict-overflow -frerun-cse-after-loop -ffunction-sections -fdata-sections -fira-loop-pressure -fforce-addr -funroll-loops -ftree-loop-distribution -ffp-contract=fast -mvectorize-with-neon-quad -Wno-unused-parameter -Wno-unused-but-set-variable
endif

#Graphite
ifeq ($(GRAPHITE_OPTS),true)
   #LEE_GCC_CPPFLAGS += -fgraphite -fgraphite-identity -floop-flatten -floop-parallelize-all -ftree-loop-linear -floop-interchange -floop-strip-mine -floop-block
   CLANG_CONFIG_EXTRA_CONLYFLAGS += -fgraphite -fgraphite-identity -floop-flatten -floop-parallelize-all -ftree-loop-linear -floop-interchange -floop-strip-mine -floop-block
endif

#FFAST-MATH
ifeq ($(FFAST_MATH),true)
    CLANG_CONFIG_EXTRA_CONLYFLAGS += -ffast-math -ftree-vectorize
    LEE_GCC_CPPFLAGS += -ffast-math -ftree-vectorize
endif

# IPA Analyser
ifeq ($(ENABLE_IPA_ANALYSER),true)
    LEE_GCC_CFLAGS += -fipa-sra -fipa-pta -fipa-cp -fipa-cp-clone
    LEE_GCC_LDFLAGS += -fipa-sra -fipa-pta -fipa-cp -fipa-cp-clone
endif

# pipe
ifeq ($(TARGET_USE_PIPE),true)
   CLANG_CONFIG_EXTRA_CONLYFLAGS += -pipe
   LEE_GCC_CPPFLAGS += -pipe
endif

# Krait
ifeq ($(KRAIT_TUNINGS),true)
    CLANG_CONFIG_EXTRA_CONLYFLAGS += -mcpu=cortex-a15 -mtune=cortex-a15
    LEE_GCC_CPPFLAGS += -mcpu=cortex-a15 -mtune=cortex-a15
endif

# pthread
ifeq ($(ENABLE_PTHREAD),true)
   #LEE_GCC_CFLAGS += -pthread
   LEE_GCC_CPPFLAGSS += -pthread
endif

# OpenMP
ifeq ($(ENABLE_GOMP),true)
   LEE_GCC_CFLAGS += -lgomp -ldl -lgcc -fopenmp
endif

# Memory Sanitize
ifeq ($(ENABLE_SANITIZE),true)
     CLANG_CONFIG_EXTRA_CONLYFLAGS += -fsanitize=leak
endif

# Strict
ifeq ($(STRICT_ALIASING),true)
   CLANG_CONFIG_EXTRA_CONLYFLAGS += -fstrict-aliasing -Werror=strict-aliasing -fno-strict-aliasing -Wstrict-aliasing=3
   LEE_GCC_CPPFLAGS += -fstrict-aliasing -Werror=strict-aliasing -fno-strict-aliasing -Wstrict-aliasing=3
endif

# No error
ifeq ($(DONT_ERROROUT),true)
 ifneq ($(filter 5.3& 5.2% 6.0% 7.0%,$(TARGET_GCC_VERSION)),)
    LEE_GCC_CFLAGS += -Wno-error
    LEE_GCC_CPPFLAGS += -Wno-error
 endif
endif

# Flags that are used by GCC, but are unknown to CLANG. If you get "argument unused during compilation" error, add the flag here
LEE_CLANG_UNKNOWN_FLAGS := \
  -mvectorize-with-neon-double \
  -mvectorize-with-neon-quad \
  -fgcse-after-reload \
  -fgcse-las \
  -fgcse-sm \
  -fivopts \
  -ftracer \
  -fgraphite \
  -ffast-math \
  -ftree-vectorize \
  -fgraphite-identity \
  -fipa-pta \
  -fipa-sra \
  -fipa-cp \
  -fipa-cp-clone \
  -floop-flatten \
  -ftree-loop-linear \
  -floop-strip-mine \
  -floop-block \
  -floop-interchange \
  -floop-nest-optimize \
  -floop-parallelize-all \
  -ftree-parallelize-loops=2 \
  -ftree-parallelize-loops=4 \
  -ftree-parallelize-loops=8 \
  -ftree-parallelize-loops=16 \
  -fira-loop-pressure \
  -ftree-loop-distribution \
  -fmodulo-sched \
  -fmodulo-sched-allow-regmoves \
  -frerun-cse-after-loop \
  -frename-registers \
  -fsection-anchors \
  -ftree-loop-im \
  -ftree-loop-ivcanon \
  -funsafe-loop-optimizations \
  -fsection-anchors \
  -Wstrict-aliasing=3 \
  -Wno-error=clobbered \
  -fweb

#####################
### HACKS SECTION ###
#####################

# Most of the flags are increasing code size of the output binaries, especially O3 instead of Os for target THUMB
# This may become problematic for small blocks, especially for boot or recovery blocks (ramdisks), used in older devices
# For example, i9300 has only 8 MB block for recovery.img, and compiling TWRP for it with above optimizations will fail
#
# If you don't care about the size of recovery.img, e.g. you have no use of it, and you want to silence the
# error "image too large" for recovery.img, use this definition
#
# NOTICE: It's better to use device-based flag TARGET_NO_RECOVERY instead, but some devices may have
# boot + recovery combo (e.g. Sony Xperias), and we must build recovery for them, so we can't set TARGET_NO_RECOVERY globally
# Therefore, this seems like a safe approach (will only ignore check on recovery.img, without doing anything else)
# However, if you use compiled recovery.img for your device, please disable this flag (comment or set to false), and lower
# optimization levels instead, as you need to make sure that recovery.img fits prior to trying to flash it
# Most (if not all) of the builders have no use of recovery.img, therefore this option is enabled by default
LEE_IGNORE_RECOVERY_SIZE := true 
