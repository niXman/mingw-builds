
#include <windows.h>
#include <cstdio>

typedef void(*func_t)();

int main() {
   HMODULE lib = LoadLibrary("dll1.dll");
   if ( !lib ) {
      printf("can`t load dll!\n");
      return 1;
   }
   
   func_t func = (func_t)GetProcAddress(lib, "func");
   if ( !func ) {
      printf("can`t resolve the func()\n");
		FreeLibrary(lib);
      return 1;
   }
   
   try {
      func();
		return 1;
   } catch ( ... ) {
		return 0;
   }
	return 0;
}
