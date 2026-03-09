/**
 * Read a byte from the specified port
 */
#include <stddef.h>

unsigned char port_byte_in(unsigned short port) {
	unsigned char result;
	__asm__("in al, dx" : "=a"(result) : "d"(port));
	return result;
}

void port_byte_out(unsigned short port, unsigned char data) {
	/* Notice how here both registers are mapped to C variables and
	 * nothing is returned, thus, no equals '=' in the asm syntax
	 * However we see a comma since there are two variables in the input area
	 * and none in the 'return' area
	 */
	__asm__("out dx, al" : : "d"(port), "a"(data));
}

#define HIGH_BYTE 14
#define LOW_BYTE 15
#define CURSOR_METHOD 0x3d4 // VGA control register
#define CURSOR_DATA 0x3d5	// VGA data register

#define WHITE_ON_BLACK 0x0f

int main() {
	port_byte_out(CURSOR_METHOD, HIGH_BYTE);
	int position = port_byte_in(CURSOR_DATA);
	position = position << 8; // high byte move 8 bits

	port_byte_out(CURSOR_METHOD, LOW_BYTE);
	position += port_byte_in(CURSOR_DATA); // 0xff00 + 0x00ee = 0xffee

	int offset = position * 2; // scale offset by 2 bytes = value:bg&fg

	const char hi[] = "hi mom!";
	char *vga = (char *)0xb8000;

	int index = 0;
	while (hi[index] != '\0') {
		vga[offset + (index * 2)] = hi[index];
		vga[offset + (index * 2) + 1] = WHITE_ON_BLACK;
		index++;
	}

	int new_pos = position + index; // +2 chars

	port_byte_out(CURSOR_METHOD, HIGH_BYTE);
	port_byte_out(CURSOR_DATA, (unsigned char)(new_pos >> 8)); // move to front 0xffee >> 0x00ff

	port_byte_out(CURSOR_METHOD, LOW_BYTE);
	port_byte_out(CURSOR_DATA, (unsigned char)(new_pos & 0x00ff)); // 0000 1111 = false truetruetrue
}
