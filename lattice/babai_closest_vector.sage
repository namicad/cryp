from sage.modules.free_module_integer import IntegerLattice

def Babai_closest_vector(M, G, target):
    small = target
    for _ in range(1):
        for i in reversed(range(M.nrows())):
            c = ((small * G[i]) / (G[i] * G[i])).round()
            small -= M[i] * c
    return target - small

def closest_vector_problem(mat, target)
	lattice = IntegerLattice(mat, lll_reduce=True)
	print("LLL done")
	gram = lattice.reduced_basis.gram_schmidt()[0]
	target = vector(ZZ, b_values)
	res = Babai_closest_vector(lattice.reduced_basis, gram, target)

	return res