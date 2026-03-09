/**
 * Read a byte from the specified port
 */
unsigned char port_byte_in(unsigned short port) {
	unsigned char result;
	/* Inline assembler syntax
	 * !! Notice how the source and destination registers are switched from NASM
	 * !!
	 *
	 * '"=a" (result)'; set '=' the C variable '(result)' to the value of register
	 * e'a'x
	 * '"d" (port)': map the C variable '(port)' into e'd'x register
	 *
	 * Inputs and outputs are separated by colons
	 */
	__asm__("in %%dx, %%al" : "=a"(result) : "d"(port));
	return result;
}

void port_byte_out(unsigned short port, unsigned char data) {
	/* Notice how here both registers are mapped to C variables and
	 * nothing is returned, thus, no equals '=' in the asm syntax
	 * However we see a comma since there are two variables in the input area
	 * and none in the 'return' area
	 */
	__asm__("out %%al, %%dx" : : "a"(data), "d"(port));
}

unsigned short port_word_in(unsigned short port) {
	unsigned short result;
	__asm__("in %%dx, %%ax" : "=a"(result) : "d"(port));
	return result;
}

void port_word_out(unsigned short port, unsigned short data) { __asm__("out %%ax, %%dx" : : "a"(data), "d"(port)); }

int main() {
	/* Screen cursor position: ask VGA control register (0x3d4) for bytes
	 * 14 = high byte of cursor and 15 = low byte of cursor. */
	port_byte_out(0x3d4, 14); /* Requesting byte 14: high byte of cursor pos */
	/* Data is returned in VGA data register (0x3d5) */
	int position = port_byte_in(0x3d5);
	position = position << 8; /* high byte */

	port_byte_out(0x3d4, 15); /* requesting low byte */
	position += port_byte_in(0x3d5);

	/* VGA 'cells' consist of the character and its control data
	 * e.g. 'white on black background', 'red text on white bg', etc */
	int offset_from_vga = position * 2;

	/* Now you can examine both variables using gdb, since we still
	 * don't know how to print strings on screen. Run 'make debug' and
	 * on the gdb console:
	 * breakpoint kernel.c:21
	 * continue
	 * print position
	 * print offset_from_vga
	 */

	/* Let's write on the current cursor position, we already know how
	 * to do that */
	char *vga = (char *)0xb8000;
	vga[offset_from_vga] = 'H';
	vga[offset_from_vga + 1] = 0x0f; /* White text on black background */

	vga[offset_from_vga + 2] = 'E';
	vga[offset_from_vga + 3] = 0x0f; /* White text on black background */

	/* Calculate new position (2 chars forward) */
	int new_pos = position + 2;

	/* Update High Byte */
	port_byte_out(0x3d4, 14);
	port_byte_out(0x3d5, (unsigned char)(new_pos >> 8));

	/* Update Low Byte */
	port_byte_out(0x3d4, 15);
	port_byte_out(0x3d5, (unsigned char)(new_pos & 0xff));
}
