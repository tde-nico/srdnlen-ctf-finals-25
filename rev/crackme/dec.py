key = '001337DEADBEEF42'
key = bytes.fromhex(key)

def ror(data):
	return data[-1:] + data[:-1]


base = 0x40103f
for i in range(0x158):
	curr = get_bytes(base + i, 1)[0]
	patch_byte(base + i, curr ^ key[-1])
	key = ror(key)
