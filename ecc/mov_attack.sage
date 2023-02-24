def mov_attack(G, P):
    E = G.curve()
    p = E.base_ring().order()

    order = G.order()
    k = 1
    while (p**k - 1) % order:
        k += 1

    K.<a> = GF(p**k)
    EK = E.base_extend(K)
    PK = EK(P)
    GK = EK(G)

    R = EK.random_point()
    m = R.order()
    d = gcd(m, G.order())
    Q = (m//d)*R

    PP = PK.tate_pairing(Q, G.order(),k)
    GG = GK.tate_pairing(Q, G.order(),k)


    mul = PP.log(GG)

    assert mul * G == P
    return mul



if __name__ == "__main__":
    import random

    # Test parameters from 'Moving Problems' (CryptoHack)
    p = 1331169830894825846283645180581
    a = -35
    b = 98

    E = EllipticCurve(GF(p), [a, b])

    G = E.random_element()

    multiply = random.randrange(1, p)

    P = G * multiply
    
    # We can't find the exact multiplied value because several of them exist
    assert mov_attack(G, P) * G == P
