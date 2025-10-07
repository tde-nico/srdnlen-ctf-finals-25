key = '73D106217'.rjust(16, '0')
key = bytes.fromhex(key)

def ror(data):
	return data[-1:] + data[:-1]


base = 0x401197
for i in range(0xE4):
	curr = get_bytes(base + i, 1)[0]
	patch_byte(base + i, curr ^ key[-1])
	key = ror(key)