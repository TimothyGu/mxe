# This file is part of MXE.
# See index.html for further information.

PKG             := pire
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.0.5
$(PKG)_CHECKSUM := fc5f451043c6fc1034f104463a4b9c6c1c46c00c
$(PKG)_SUBDIR   := pire-release-$($(PKG)_VERSION)
$(PKG)_FILE     := pire-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://github.com/yandex/pire/archive/release-$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     := gcc

define $(PKG)_BUILD
    cd '$(1)' && autoreconf -fi
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --enable-extra \
        ac_cv_func_malloc_0_nonnull=yes
    $(MAKE) -C '$(1)/pire' -j '$(JOBS)' bin_PROGRAMS= LDFLAGS='-no-undefined'
    $(MAKE) -C '$(1)/pire' -j 1 install bin_PROGRAMS=

    '$(TARGET)-g++' \
        -W -Wall -Werror \
        '$(1)/samples/pigrep/pigrep.cpp' -o '$(PREFIX)/$(TARGET)/bin/test-$(PKG).exe' \
        -lpire
endef