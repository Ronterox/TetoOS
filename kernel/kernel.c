#include <stddef.h>
#include <stdint.h>

#define VGA_MEMORY 0xB8000
#define MAX_COLS 80
#define MAX_ROWS 25

#define WHITE_ON_BLACK 0x0f
#define WHITE_ON_RED 0xcf

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
		vga[i] = '\0';
		vga[i + 1] = WHITE_ON_BLACK;
	}

	set_cursor(0);
}

void print_char(const char c, const uint16_t offset, const uint16_t color) {
	char *vga = (char *)VGA_MEMORY;
	vga[offset] = c;
	vga[offset + 1] = color;
}

uint16_t kprint_at(const char *str, int x, int y) {
	uint16_t position = get_cursor();

	if (x < 0) x = position % MAX_COLS;
	if (y < 0) y = position / MAX_COLS;

	uint16_t offset = (x + MAX_COLS * y) * 2;

	for (size_t i = 0; str[i] != '\0'; i++) {
		if (str[i] == '\n') {
			y = position / MAX_COLS + 1;
			position = MAX_COLS * y;
			offset = (position - i - 1) * 2;
		} else {
			const uint16_t char_pos = offset + i * 2;
			if (char_pos > MAX_COLS * MAX_ROWS * 2) {
				print_char('E', (MAX_ROWS * MAX_COLS * 2 - 2), WHITE_ON_RED);
				return position;
			}

			print_char(str[i], char_pos, WHITE_ON_BLACK);
			position++;
		}
	}

	return position;
}

void kprint(const char *str) {
	const uint16_t cursor = kprint_at(str, -1, -1);
	set_cursor(cursor);
}

void int_to_ascii(const int n, char *str, const size_t i) {
	if (n < 10) {
		str[i] = n + '0';
		str[i + 1] = '\0';
		return;
	}
	str[i] = (n % 10) + '0';
	int_to_ascii(n / 10, str, i + 1);
}

void itoa(int n, char *str) { int_to_ascii(n, str, 0); }

int main() {
	clear_screen();

	for (size_t i = 0; i < 24; i++) {
		char str[255];
		itoa(i, str);
		kprint_at(str, 0, i);
	}

	kprint_at("This text forces the kernel to scroll. Row 0 will disappear. ", 60, 24);
	kprint("And with this text, the kernel will scroll again, and row 1 will disappear too!");
}
