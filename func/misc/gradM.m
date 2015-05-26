function L = gradM(R, U)

nabla = R.'/(R*(R.'));

L = (U*nabla).';