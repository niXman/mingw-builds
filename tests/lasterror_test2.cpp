#include <windows.h>

struct S {
	~S() { SetLastError(2); }
};

void foo() {
	S s;
}

int main(int, const char**) {
	foo();
	return GetLastError()-2;
}
