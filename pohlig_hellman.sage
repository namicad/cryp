def point_div(P, G):
    order = G.order()

    fac = list(factor(order))
    print(fac)

    moduli = []
    remainder = []

    for i, j in fac:
        mod = i**j
        _g_ = G * ZZ(order / mod)
        _p_ = P * ZZ(order / mod)

        dl = discrete_log(_p_, _g_, operation = "+")
        moduli.append(mod)
        remainder.append(dl)
        print(dl, mod)

    mul = crt(remainder,moduli)

    return mul


if __name__ == "__main__":
    from Crypto.Util.number import *
    import random

    p = getPrime(50)
    Zp = GF(p)
    a = random.randrange(0, p)
    b = random.randrange(0, p)

    E = EllipticCurve(GF(p), [a, b])

    while 1:
        try:
            x = random.randrange(0, p)
            y = int(Zp(x^3 + a * x + b).sqrt())
            break
        except:
            continue

    G = E(x, y)
    
    multiply = random.randrange(0, p)

    P = G * multiply

    assert multiply == point_div(P, G)
