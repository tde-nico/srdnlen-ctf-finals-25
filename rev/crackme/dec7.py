key = '6FB0E02CB'.rjust(16, '0')
key = bytes.fromhex(key)

def rol(s, n, bitlen=64):
	n = n % bitlen
	val = int.from_bytes(s, "big")
	rotated = ((val << n) | (val >> (bitlen - n))) & ((1 << bitlen) - 1)
	return rotated.to_bytes(bitlen//8, "big")

base = 0x401583
for i in range(0x7B):
	curr = get_bytes(base + i, 1)[0]
	patch_byte(base + i, curr ^ key[-1])
	key = rol(key, 5)
