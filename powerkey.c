#ifdef POWER_KEY_BOOT
void wait_for_power_key() {
	//0x11CB0064: gpa1 pins
	//32: vol up
	//64: vol down
	//128: power
	//This is true for all known Exynos 7885 devices.
	char value;
	do {
		value = *((char*)0x11CB0064);
	} while (value & 128);
}
#endif
