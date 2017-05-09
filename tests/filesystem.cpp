
#include <iostream>
#include <experimental/filesystem>

namespace fs = std::experimental::filesystem;

void demo_status(const fs::file_status s) {
    if(fs::is_regular_file(s)) std::cout << " is a regular file\n";
    if(fs::is_directory(s)) std::cout << " is a directory\n";
    if(fs::is_block_file(s)) std::cout << " is a block device\n";
    if(fs::is_character_file(s)) std::cout << " is a character device\n";
    if(fs::is_fifo(s)) std::cout << " is a named IPC pipe\n";
    if(fs::is_socket(s)) std::cout << " is a named IPC socket\n";
    if(fs::is_symlink(s)) std::cout << " is a symlink\n";
    if(!fs::exists(s)) std::cout << " does not exist\n";
}

int main(int argc, char **argv) {
	const fs::path path = fs::current_path();
	std::cout << "curpath=" << path << std::endl << std::endl;
	
	if ( !fs::exists(argv[0]) ) {
		std::cout << "error";
	} else {
		std::cout << "ok";
	}
	std::cout << std::endl << std::endl;
	
	const fs::file_status s = fs::status(path);
	demo_status(s);
}
