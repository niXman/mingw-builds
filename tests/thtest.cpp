#include <iostream>
#include <thread>

int main() {
	int var = 0;
	
   std::thread t1(
      [&var]() {++var;}
   );
   std::thread t2(
      [&var]() {++var;}
   );

   t1.join();
   t2.join();
	
	return var-2;
}
