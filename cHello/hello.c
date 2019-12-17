#include <stdio.h>

void main(void)
{
	*(unsigned char*) 0xD020 = 0x00; // Border black
	*(unsigned char*) 0xD021 = 0x00; // Center of screen black
	*(unsigned char*) 0x0286 = 0x01; // Text white
	__asm__("jsr $e544"); // Clear the screen
	printf("Howdy! \n");
}