function H = helicopterData
H = zeros(6,11);
a = 1e-02*[4 4 4 5 3 4 4 4 4 4 4]
b = [0.035 0.045 0.025 0.035 0.035 0.035 0.035 0.035 0.035 0.035 0.035]
c = 1e-02*[2 2 2 2 2 3 1 2 2 2 2]
d = 1e-02*[3 3 3 3 3 3 3 3 3 4 2]
L = 1e-02*[13 13 13 13 13 13 13 18 8 13 13]
alpha = pi/8*[1 1 1 1 1 1 1 1 1 1 1 ] % h?r beh?vs riktiga v?rden
H =  [a;b;c;d;L; alpha] 
end