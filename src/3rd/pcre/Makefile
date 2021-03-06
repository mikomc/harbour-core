ROOT := ../../../

include $(TOP)$(ROOT)config/global.mk

HB_BUILD_WARN := no
HB_BUILD_MODE := c

C_SOURCES := \
   chartabs.c \
   pcrebyte.c \
   pcrecomp.c \
   pcreconf.c \
   pcredfa.c \
   pcreexec.c \
   pcrefinf.c \
   pcreget.c \
   pcreglob.c \
   pcrejitc.c \
   pcremktb.c \
   pcrenewl.c \
   pcreoutf.c \
   pcrerefc.c \
   pcrestud.c \
   pcretabs.c \
   pcreucd.c \
   pcrever.c \
   pcrevutf.c \
   pcrexcls.c \

LIBNAME := hbpcre

ifneq ($(HB_HAS_PCRE_LOCAL),)

   HB_CFLAGS += -DSUPPORT_UTF -DSUPPORT_UCP
   # only needed for win/wce, for other platforms this is noop
   HB_CFLAGS_STA := -DPCRE_STATIC

   ifneq ($(filter $(HB_COMPILER),clang gcc mingw mingw64 sunpro),)
      ifeq ($(filter $(HB_PLATFORM)-$(HB_COMPILER),win-clang),)
         HB_CFLAGS += -DHAVE_INTTYPES_H
      endif
   endif

#   ifneq ($(filter $(HB_COMPILER),mingw mingw64 msvc mvc64)$(filter $(HB_PLATFORM),darwin linux),)
#      HB_CFLAGS += -DSUPPORT_JIT
#   endif

   HB_CFLAGS += -DHAVE_CONFIG_H

   # workaround for problems in sunpro x86 PIC builds exploited by hbpcre library code
   ifeq ($(HB_COMPILER),sunpro)
      ifeq ($(HB_PLATFORM),sunos)
         ifeq ($(findstring sparc,$(shell isalist)),)
            HB_CFLAGS += -xbuiltin=%none
         endif
      else
         HB_CFLAGS += -xbuiltin=%none
      endif
   endif

   # suppress bcc warnings
   ifeq ($(HB_COMPILER),bcc)
      HB_CFLAGS += -w-use -w-csu -w-aus -w-sig
   endif

   include $(TOP)$(ROOT)config/lib.mk
else
   HB_SKIP_REASON := local copy unused
   include $(TOP)$(ROOT)config/none.mk
endif

# ORIGIN http://pcre.org/
# URL    https://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-8.39.tar.bz2
# DIFF   pcre.dif
#
# MAP    LICENCE                           LICENSE.txt
# MAP    config.h.generic                  config.h
# MAP    pcre.h.generic                    pcre.h
# MAP    pcre_internal.h                   pcreinal.h
# MAP    ucp.h
# MAP    pcre_chartables.c.dist            chartabs.c
# MAP    pcre_byte_order.c                 pcrebyte.c
# MAP    pcre_compile.c                    pcrecomp.c
# MAP    pcre_config.c                     pcreconf.c
# MAP    pcre_dfa_exec.c                   pcredfa.c
# MAP    pcre_exec.c                       pcreexec.c
# MAP    pcre_fullinfo.c                   pcrefinf.c
# MAP    pcre_get.c                        pcreget.c
# MAP    pcre_globals.c                    pcreglob.c
# MAP    pcre_jit_compile.c                pcrejitc.c
# MAP    pcre_maketables.c                 pcremktb.c
# MAP    pcre_newline.c                    pcrenewl.c
# MAP    pcre_ord2utf8.c                   pcreoutf.c
# MAP    pcre_printint.c                   pcreprni.c
# MAP    pcre_refcount.c                   pcrerefc.c
# MAP    pcre_study.c                      pcrestud.c
# MAP    pcre_tables.c                     pcretabs.c
# MAP    pcre_ucd.c                        pcreucd.c
# MAP    pcre_valid_utf8.c                 pcrevutf.c
# MAP    pcre_version.c                    pcrever.c
# MAP    pcre_xclass.c                     pcrexcls.c
# MAP    sljit/sljitConfig.h               sjconf.h
# MAP    sljit/sljitConfigInternal.h       sjconfi.h
# MAP    sljit/sljitExecAllocator.c        sjexeca.c
# MAP    sljit/sljitLir.c                  sjlir.c
# MAP    sljit/sljitLir.h                  sjlir.h
# MAP    sljit/sljitNativeARM_32.c         sjarm32.c
# MAP    sljit/sljitNativeARM_64.c         sjarm64.c
# MAP    sljit/sljitNativeARM_T2_32.c      sjarmt2.c
# MAP    sljit/sljitNativeMIPS_32.c        sjmips32.c
# MAP    sljit/sljitNativeMIPS_64.c        sjmips64.c
# MAP    sljit/sljitNativeMIPS_common.c    sjmipsc.c
# MAP    sljit/sljitNativePPC_32.c         sjppc32.c
# MAP    sljit/sljitNativePPC_64.c         sjppc64.c
# MAP    sljit/sljitNativePPC_common.c     sjppcc.c
# MAP    sljit/sljitNativeSPARC_32.c       sjspar32.c
# MAP    sljit/sljitNativeSPARC_common.c   sjsparc.c
# MAP    sljit/sljitNativeTILEGX-encoder.c sjtilenc.c
# MAP    sljit/sljitNativeTILEGX_64.c      sjtil64.c
# MAP    sljit/sljitNativeX86_32.c         sjx8632.c
# MAP    sljit/sljitNativeX86_64.c         sjx8664.c
# MAP    sljit/sljitNativeX86_common.c     sjx86c.c
# MAP    sljit/sljitUtils.c                sjutils.c
