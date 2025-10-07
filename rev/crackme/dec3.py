key = '853af6c53'.rjust(16, '0')
key = bytes.fromhex(key)

def rol(data):
	return data[1:] + data[:1]


base = 0x40127B
for i in range(0xD2):
	curr = get_bytes(base + i, 1)[0]
	patch_byte(base + i, curr ^ key[-1])
	key = rol(key)