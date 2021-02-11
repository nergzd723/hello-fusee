#include <stdint.h>
extern void _usb_transfer_wrapper(char* message, uint32_t len);
extern void _reset();
uint64_t strlen(const char* str) {
	uint64_t len = 0;
	while (str[len])
		len++;
	return len;
}

void kernel(){
    static char* hello = "Hello from C world!\n";
    _usb_transfer_wrapper(hello, strlen(hello));
    static char* hey = "C is better than rust :D\n";
    _usb_transfer_wrapper(hey, strlen(hey));
    static char buffer[2];
    for(int i = 0; i < 150; i++){
        buffer[0] = i;
        _usb_transfer_wrapper(buffer, 2);
    }
    _reset();
}
