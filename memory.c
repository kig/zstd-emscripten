#include "zstd.h"

#if defined (__cplusplus)
extern "C" {
#endif

extern unsigned char __heap_base;

unsigned long bump_pointer = (unsigned long)(&__heap_base);

void* malloc(unsigned long n) {
  unsigned long r = bump_pointer;
  bump_pointer = (bump_pointer + n + 15) & 0xfffffff0; // align on 16 bytes
  return (void *)r;
}

void free(void* p) {
}

void *memset(void *dst, int c, unsigned long n) {
	char *dstc = (char*)dst, cc = (char)c;
	while (n--) *dstc++ = cc;
	return dst - n;
}

void *memcpy(void *dst, const void *src, unsigned long n) {
	char *dstc = (char*)dst, *srcc = (char*)src;
	while (n--) *dstc++ = *srcc++;
	return dst - n;
}

void *memmove(void *dst, const void *src, unsigned long n) {
	if (dst > src) return memcpy(dst, src, n);
	char *dstc = (char*)dst, *srcc = (char*)src;
	dstc += n;
	srcc += n;
	while (n--) *--dstc = *--srcc;
	return dst+1;
}

void *calloc(unsigned long nmemb, unsigned long size) {
	if (nmemb * size < 0) return (void *)-1;
	void *p = malloc(nmemb * size);
	memset(p, 0, nmemb * size);
	return p;
}

void setHeapPtr(unsigned int n) {
	bump_pointer = n;
}


#if defined (__cplusplus)
}
#endif
