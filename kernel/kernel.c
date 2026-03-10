#include <stddef.h>
#include <stdint.h>

#define VGA_MEMORY 0xB8000
#define MAX_ROWS 80
#define MAX_COLS 25
#define WHITE_ON_BLACK 0x0f

#define VGA_FUNC 0x3d4
#define VGA_DATA 0x3d5

#define HIGH_BYTE 14
#define LOW_BYTE 15

void outb(const uint16_t port, const uint16_t data) { __asm__("outb dx, al" : : "d"(port), "a"(data)); }

uint16_t inb(const uint16_t port) {
	unsigned char result;
	__asm__("inb al, dx" : "=a"(result) : "d"(port));
	return result;
}

uint16_t get_cursor() {
	uint16_t position;

	outb(VGA_FUNC, HIGH_BYTE);
	position = inb(VGA_DATA) << 8; // 0x00ff << 0xff00

	outb(VGA_FUNC, LOW_BYTE);
	position += inb(VGA_DATA);

	return position;
}

void set_cursor(const uint16_t position) {
	outb(VGA_FUNC, HIGH_BYTE);
	outb(VGA_DATA, position >> 8); // 0xffee >> 0x00ff
	outb(VGA_FUNC, LOW_BYTE);
	outb(VGA_DATA, position & 0x00ff);
}

void clear_screen() {
	char *vga = (char *)VGA_MEMORY;

	for (size_t i = 0; i < MAX_ROWS * MAX_COLS; i += 2) {
		vga[i] = ' ';
		vga[i + 1] = WHITE_ON_BLACK;
	}
}

void print_char(const char c, const uint16_t offset, const uint16_t color) {
	char *vga = (char *)VGA_MEMORY;
	vga[offset] = c;
	vga[offset + 1] = color;
}

uint16_t kprint_at(const char str[], const int x, const int y) {
	const uint16_t position = get_cursor();
	const uint16_t offset = (x < 0 || y < 0) ? position * 2 : (y * MAX_ROWS + x * MAX_COLS) * 2;

	size_t i;
	for (i = 0; str[i] != '\0'; i++) {
		print_char(str[i], offset + i * 2, WHITE_ON_BLACK);
	}

	return position + i;
}

void kprint(const char str[]) {
	const uint16_t cursor = kprint_at(str, -1, -1);
	set_cursor(cursor);
}

int main() {
	clear_screen();

	const char msg[] = "Hi there mom!";
	kprint(msg);
}
