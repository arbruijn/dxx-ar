# build windows version with msys2

PATCH = ar4

DISTLIBS = SDL.dll libFLAC-8.dll libSDL_mixer-1-2-0.dll libgcc_s_dw2-1.dll libmad-0.dll libmikmod-3.dll \
	libogg-0.dll libopenal-1.dll libphysfs.dll libvorbis-0.dll libvorbisfile-3.dll libwinpthread-1.dll

export SCONSFLAGS = -j5

export CFLAGS = -mno-ms-bitfields -fwrapv \
	-fno-aggressive-loop-optimizations -fno-strict-aliasing \
	-Wno-deprecated-declarations -Wno-misleading-indentation \
	-I/mingw32/include/SDL -D__EXPORT__= -DHAVE_STRUCT_TIMESPEC

dist: d1 d2
	mkdir -p out
	zip -9jX out/d1x-rebirth-0.58.1-$(PATCH)-win.zip d1/COPYING.txt d1/CHANGELOG.txt \
		d1/d1x-rebirth.{exe,ico} d1/d1x.ini d1/README-D1X.txt \
		d1/README.txt d1/RELEASE-NOTES.txt \
		$(patsubst %,/mingw32/bin/%,$(DISTLIBS))
	zip -9jX out/d2x-rebirth-0.58.1-$(PATCH)-win.zip d2/COPYING.txt d2/CHANGELOG.txt \
		d2/d2x-rebirth.{exe,ico} d2/d2x.ini d2/README-D2X.txt \
		d2/RELEASE-NOTES.txt \
		$(patsubst %,/mingw32/bin/%,$(DISTLIBS))

init:
	pacman -S mingw32/mingw-w64-i686-gcc tar scons pkg-config mingw32/mingw-w64-i686-SDL \
		mingw32/mingw-w64-i686-SDL_mixer mingw32/mingw-w64-i686-physfs \
		zip unzip diffutils

d1: d1/main/vers_id.h
	cd d1; scons

d2:
	cd d2; scons

d1/main/vers_id.h d2/main/vers_id.h:
	mkdir -p out
	sed -r 's/("." D[2X]X(_VERSION_)?MICRO).*/\1 "-$(PATCH)"/' $@ > out/vers_id.h
	if ! cmp -s out/vers_id.h $@; then mv out/vers_id.h $@; fi

.PHONY: d1 d2 d1/main/vers_id.h d2/main/vers_id.h
