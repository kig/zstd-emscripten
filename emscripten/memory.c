#include "zstd.h"	 /* ZSTD version numbers */

#if defined (__cplusplus)
extern "C" {
#endif

	/*
		The actual wrapper is in the build script.
		See cmake/emscripten/CMakeLists.txt for the exported functions. 
		See zstd.h and Zstandard docs for details on usage.
	*/

extern unsigned char __heap_base;

unsigned int bump_pointer = &__heap_base;

char* malloc(unsigned int n) {
  unsigned int r = bump_pointer;
  bump_pointer += n;
  return (char *)r;
}

void free(void* p) {
  // lol
}

char *calloc(int nmemb, int size) {
	if (nmemb * size < 0) return (void *)-1;
	void *p = malloc(nmemb * size);
	memset(p, 0, nmemb * size);
	return p;
}

void setHeapPtr(unsigned int n) {
	bump_pointer = n;
}

char *memset(char *dst, int c, int n) {
	while (n--) *dst++ = c;
	return dst-n;
}

char *memcpy(char *dst, char *src, int n) {
	while (n--) *dst++ = *src++;
	return dst-n;
}

char *memmove(char *dst, char *src, int n) {
	if (dst > src) return memcpy(dst, src, n);
	dst += n;
	src += n;
	while (n--) *--dst = *--src;
	return dst+1;
}

#if defined (__cplusplus)
}
#endif
