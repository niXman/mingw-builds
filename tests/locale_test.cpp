#include <clocale>
#include <iostream>

int main() {
   try {
      //std::setlocale(LC_ALL, "en_US.UTF-8");
      //std::locale::global(std::locale("ru_RU.UTF-8"));
      std::locale::global(std::locale("rus"));
      std::cout << "бла бла" << std::endl;
		return 0;
   } catch ( const std::exception& ex ) {
      std::cout << ex.what() << std::endl;
		return 1;
   }
	
	return 1;
}
