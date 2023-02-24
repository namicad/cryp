# Curve conversion
def edward_2_mont_curve(edward):
	p, a, d = edward

	A = (2 * (a + d) / (a - d)) % p
	B = (4 / (a - d)) % p

	return (p, A, B)

def mont_2_weier_curve(mont):
	p, A, B = mont

	a = (3 - A^2) / (3 * B^2)
	a %= p
	b = (2 * A^3 - 9 * A) / (27 * B^3)
	b %= p

	return (p, a, b)



# Point conversion
def edward_2_mont_point(P, edward):
	x, y = P
	p, a, d = edward

	x_new = ((1 + y) / (1 - y)) % p
	y_new = ((1 + y) / (x - x * y)) % p

	return (x_new, y_new)

def mont_2_weier_point(P, mont):
	p, A, B = mont
	x, y = P

	x_new = x / B + A / (3 * B)
	x_new %= p
	y_new = y / B
	y_new %= p

	return (x_new, y_new)


# twisted edward curve:   ax^2 + y^2 = 1 + dx^2y^2
# montgomery curve:       By^2 = x^3 + Ax^2 + x
# weierstrass curve:      y^2 = x^3 + Ax + B



if __name__ == "__main__":
	from Crypto.Util.number import *
	import random

	# Test data from 'Monward' (ASIS CTF)
	enc = (3419907700515348009508526838135474618109130353320263810121, 5140401839412791595208783401208636786133882515387627726929)
	P = (2021000018575600424643989294466413996315226194251212294606, 1252223168782323840703798006644565470165108973306594946199)

	p = 5237201762126547007797151858779248497586822407792003360117
	a = 5156435618558632445909094488325020226459116348198759927263
	d = 2625317925697180384345488106025337735042363504009731201759

	edward_curve = (p, a, d)

	# edward to montgomery
	mont_curve = edward_2_mont_curve(edward_curve)
	enc = edward_2_mont_point(enc, edward_curve)
	P = edward_2_mont_point(P, edward_curve)

	# montgomery to weierstrass
	weier_curve = mont_2_weier_curve(mont_curve)
	enc = mont_2_weier_point(enc, mont_curve)
	P = mont_2_weier_point(P, mont_curve)

	p, a, b = weier_curve

	E = EllipticCurve(GF(p), [a, b])
	enc = E(enc)
	P = E(P)

	mul = discrete_log(enc, P, operation = "+")

	assert long_to_bytes(mul) == b'MoN7g0m3ry_EdwArd5_cuRv3'
