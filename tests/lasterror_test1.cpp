#include <windows.h>

struct C { ~C() {} };

int Test() {
	C t;
	return ::GetLastError();
}

int main(int, const char**) {
	::SetLastError(2);

	return Test()-2;
}
