from z3 import *

# flag = [BitVec(f'flag_{i}', 8) for i in range(5)]

# res = 0
# res += flag[0]
# res += flag[1] * (0xc8 - 0x46)
# res += flag[2] * 0x82 * 0x82
# res += flag[3] * 0x218608
# res += flag[4] * 0x11061010

# cmd = 0x73D106217

# s = Solver()
# s.add(res == cmd)
# if s.check() == sat:
# 	m = s.model()
# 	print([chr(m.evaluate(flag[i]).as_long()) for i in range(5)])
# else:
# 	print("UNSAT")


flag = b'srdnl'

res = 0
res += flag[0]
res += flag[1] * (0xc8 - 0x46)
res += flag[2] * 0x82 * 0x82
res += flag[3] * 0x218608
res += flag[4] * 0x11061010
check = 0x73D106217
print(hex(res), hex(check))

flag = b'srdnlen{W0'

res = 0
res += flag[5] * 0x86 * 0x86
res += flag[6] * 0x1337B510
res += flag[7] * 0x24B6D8
res += flag[8]
res += flag[9] * 0x86
check = 0x853AF6C53
print(hex(res), hex(check))

flag = b'srdnlen{W0w_y0u'

res = 0
res += flag[10] * 0x14FF4BA1
res += flag[11] * 0x4951
res += flag[12] * 0x89
res += flag[13]
res += flag[14] * 0x273C59
check = 0x9D4B63284
print(hex(res), hex(check))


it = 4
flag = b'srdnlen{W0w_y0u_4r3_'
res = 0
res += flag[(it-1)*5+0] * 0x118DB651
res += flag[(it-1)*5+1] * 0x4309
res += flag[(it-1)*5+2] * 1
res += flag[(it-1)*5+3] * 0x83
res += flag[(it-1)*5+4] * 0x224D9B
check = 0x6905F2CF3
print(hex(res), hex(check))


it = 5
flag = b'srdnlen{W0w_y0u_4r3_4c7u4'
res = 0
res += flag[(it-1)*5+0] * 0x2819E8
res += flag[(it-1)*5+1]
res += flag[(it-1)*5+2] * 0x4A64
res += flag[(it-1)*5+3] * 0x8A
res += flag[(it-1)*5+4] * 0x159DF710
check = 0x46C4BAD51
print(hex(res), hex(check))


it = 6
flag = b'srdnlen{W0w_y0u_4r3_4c7u4lly_G'
res = 0
res += flag[(it-1)*5+0] * 0x23E5FD
res += flag[(it-1)*5+1]
res += flag[(it-1)*5+2] * 0x4519
res += flag[(it-1)*5+3] * 0x12A67C71
res += flag[(it-1)*5+4] * 0x85
check = 0x6FB0E02CB
print(hex(res), hex(check))

it = 7
flag = b'srdnlen{W0w_y0u_4r3_4c7u4lly_G00D!}'
res = 0
res += flag[(it-1)*5+0] * 0x4731
res += flag[(it-1)*5+1]
res += flag[(it-1)*5+2] * 0x258AD7
res += flag[(it-1)*5+3] * 0x13CC3761
res += flag[(it-1)*5+4] * 0x87
check = 0x297599FE8


## EXEC

it = 7
flag = [BitVec(f'flag_{i}', 64) for i in range(5 * it)]

res = 0
res += flag[(it-1)*5+0] * 0x4731
res += flag[(it-1)*5+1]
res += flag[(it-1)*5+2] * 0x258AD7
res += flag[(it-1)*5+3] * 0x13CC3761
res += flag[(it-1)*5+4] * 0x87
check = 0x297599FE8

s = Solver()
for i in range(len(flag)):
	s.add(flag[i] >= 32, flag[i] <= 126)
# 	s.add(Or(
# 		And(flag[i] >= ord('0'), flag[i] <= ord('9')),
# 		And(flag[i] >= ord('A'), flag[i] <= ord('Z')),
# 		And(flag[i] >= ord('a'), flag[i] <= ord('z')),
# 		flag[i] == ord('_'),
# 		flag[i] == ord('}'),
# 	))
s.add(res == check)
if s.check() == sat:
	m = s.model()
	print([chr(m.evaluate(flag[i]).as_long()) for i in range((it-1)*5, len(flag))])
else:
	print("UNSAT")

