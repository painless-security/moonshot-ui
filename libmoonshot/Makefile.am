AUTOMAKE_OPTIONS = foreign
libmoonshot_la_CPPFLAGS = \
        $(libmoonshot_CFLAGS) \
        $(AM_CPPFLAGS) 

libmoonshot_la_SOURCES = libmoonshot-common.c

libmoonshot_la_LIBADD = $(libmoonshot_LIBS)
libmoonshot_la_LDFLAGS = -no-undefined -version-info 1:0:0

include_HEADERS = libmoonshot.h
noinst_HEADERS = libmoonshot-common.h
noinst_LTLIBRARIES = libmoonshot.la
AM_CPPFLAGS =
if TARGET_WINDOWS
AM_CPPFLAGS += -DOS_WIN32
noinst_DATA = libmoonshot.lib

BUILT_SOURCES = moonshot-msrpc.h \
                moonshot-msrpc_s.c \
                moonshot-msrpc_c.c

DISTCLEANFILES = ${BUILT_SOURCES}

moonshot-msrpc.h: libmoonshot/moonshot-msrpc.idl libmoonshot/moonshot-msrpc.acf
	${AM_V_GEN} ${MIDL_WRAPPER} -o libmoonshot -m "${MIDL}" $^

moonshot-msrpc_s.c: moonshot-msrpc.h
moonshot-msrpc_c.c: moonshot-msrpc.h

libmoonshot_la_SOURCES += \
        libmoonshot-msrpc.c

nodist_libmoonshot_la_SOURCES = \
        moonshot-msrpc_c.c

endif
