class SingularCurve:
    def __init__(self, p, a, b) -> None:
        self.p = p
        self.a = a % p
        self.b = b % p
        self.O = Point(self, 0, 0)

class Point:
    def __init__(self, E: Curve, x: int, y: int) -> None:
        self.E = E
        self.x = x % E.p
        self.y = y % E.p

    def __neg__(self) -> 'Point':
        return Point(self.E, self.x, -self.y)

    def __add__(self, other: 'Point') -> 'Point':
        assert self.E == other.E
        E = self.E

        if other == E.O: return self
        if self  == E.O: return other

        xP, yP = self.x, self.y
        xQ, yQ = other.x, other.y

        if xP == xQ:
            if (yP + yQ) % E.p == 0:
                return E.O
            m = (3*xP**2 + E.a)*pow(2*yP, -1, E.p) % E.p
        else:
            m = (yQ - yP)*pow(xQ - xP, -1, E.p) % E.p

        xR = m**2 - xP - xQ
        yR = m*(xP - xR) - yP
        return Point(E, xR, yR)

    def __sub__(self, other: 'Point') -> 'Point':
        return self + -other

    def __mul__(self, k: int) -> 'Point':
        P, R = self, self.E.O
        if k < 0:
            P = -P
            k *= -1

        while k:
            if k % 2:
                R += P
            P += P
            k //= 2
        return R
    
    __rmul__ = __mul__

    def __eq__(self, o: 'Point') -> bool:
        return isinstance(o, Point) \
            and self.E == o.E       \
            and self.x == o.x       \
            and self.y == o.y

def singular_point_div(P, G):
	assert P.E == G.E
	E = P.E

	p, a, b = E.p, E.a, E.b

	assert (4 * a^3 + 27 * b^2) % p == 0

	Zp = GF(p)
	p_x, p_y = Zp(P.x), Zp(P.y)
	g_x, g_y = Zp(G.x), Zp(G.y)

	P.<x,y> = PolynomialRing(Zp)

	factored = list((x^3 + a * x + b).factor())


	assert factored[0][1] == 1 and factored[1][1] == 2

	alpha = list(factored[0][0])[1][0]
	beta = list(factored[1][0])[1][0]

	p_x += beta
	g_x += beta
	alpha -= beta

	sq_alpha = Zp(alpha).sqrt()

	p_morph = (p_y + sq_alpha * p_x) / (p_y - sq_alpha * p_x)
	g_morph = (g_y + sq_alpha * g_x) / (g_y - sq_alpha * g_x)

	mul = p_morph.log(g_morph)

	return mul


if __name__ == "__main__":
	from Crypto.Util.number import *
	import random

	while 1:
		try:
			p = getPrime(100)
			Zp = GF(p)
			a = random.randrange(0, p)
			b = int(Zp(-4 * a^3 / 27).sqrt())
			break
		except:
			continue

	E = SingularCurve(p, a, b)

	while 1:
		try:
			x = random.randrange(0, p)
			y = int(Zp(x^3 + a * x + b).sqrt())
			break
		except:
			continue

	G = Point(E, x, y)
	
	multiply = random.randrange(0, p)

	P = G * multiply

	assert multiply == singular_point_div(P, G)
