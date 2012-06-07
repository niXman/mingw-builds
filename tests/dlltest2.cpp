
#include <stdio.h>

void f();

int main(int, char **)
{
	try {
		f();
		return 1;
	} catch(int) {
		return 0;
	}
	return 1;
}
