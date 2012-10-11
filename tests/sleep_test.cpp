#include <iostream>
#include <chrono>
#include <thread>

void sleep_for() {
    std::cout << "Hello waiter" << std::endl;
    std::chrono::milliseconds dura( 200 );
    std::this_thread::sleep_for( dura );
    std::cout << "Waited 200 ms\n";
}

void sleep_until() {
	auto days = std::chrono::system_clock::now() + std::chrono::seconds(1);
	std::this_thread::sleep_until(days);
}

int main() {
	sleep_for();
	
	sleep_until();
	
	return 0;
}
