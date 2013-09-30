
#include <random>

int main() {
	std::random_device rd;
	
	return rd() == rd();
}
