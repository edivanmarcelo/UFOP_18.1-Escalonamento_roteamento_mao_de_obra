param D := 8; #Jornada de trabalho
param num_n := 15; #Numero de vertices

set n := {1 .. 15}; 
set clientes := {2 .. 14}; #Variaveis que decidem o numero de elementos
set tecnico := {1 .. 5};

param o {i in clientes}; #Custo para terceirizar a tarefa i
param q {i in n, k in tecnico}; #1 se o tecnico K e apto a realizar a tarefa i
param d {i in n}; #Duracao da tarefa i
param t {i in n, j in n}; #Tempo de viagem de i para j
param c {i in n, j in n}; #Custo para atravessar o arco (i,j)
param e {i in n}; #Inicio da janela de tempo do cliente i
param l {i in n}; #Termino da janela de tempo do cliente i

var x {i in n, j in n, k in tecnico}, binary; #1 se o tecnico K vai de i para j e 0 c.c.
var y {i in clientes}, binary; #1 se a tarefa i e terceirizada e 0 c.c.
var b {i in n, k in tecnico}, >=0; #Momento em que o tecnico K comea a tarefa i


minimize z : (sum{k in tecnico, i in n, j in n} if(i!=j) then(c[i,j] * x[i,j,k])) + (sum{i in clientes} o[i]*y[i]);


rest1{i in clientes}: (sum{k in tecnico, j in n} if(i!=j) then(x[i,j,k])) + (y[i]) = 1;

rest2{k in tecnico, i in clientes}: (sum{j in n} if(i!=j) then(x[i,j,k])) - (q[i,k]) <= 0;

rest3{k in tecnico}: (sum{j in n} if(j!=1) then(x[1,j,k])) = 1;

rest4{k in tecnico}: (sum{i in n} if(i!=num_n) then(x[i,num_n,k])) = 1;

rest5{k in tecnico, h in clientes}: (sum{i in n} if(i!=h) then(x[i,h,k])) - (sum{j in n} if(h!=j) then(x[h,j,k])) = 0;

rest6{k in tecnico, i in n, j in n}: (if(i!=j) then(b[i,k]+(d[i]+t[i,j])*x[i,j,k])) - (if(i!=j) then(b[j,k] + l[i]*(1-x[i,j,k]))) <= 0;

rest7{k in tecnico, i in n}: e[i] - b[i,k] <= 0;

rest8{k in tecnico, i in n}: b[i,k] - l[i]<= 0; 

rest9{k in tecnico}: b[num_n,k] - b[1,k] <= D;

rest10{k in tecnico, i in n}: b[i,k] >= 0;

solve;

data;

param o:=	2 5
			3 3
			4 2
			5 7
			6 10
			7 5
			8 2
			9 4
			10 8
			11 2
			12 1
			13 6
			14 4;

param q:
	1	2	3	4	5 :=
1	1	1	1	1	1
2	1	1	0	0	0
3	0	0	1	1	1
4	1	0	1	0	1
5	1	1	0	1	1
6	0	1	0	0	0
7	1	1	1	1	1
8	1	1	1	1	1
9	0	1	1	0	1
10	1	1	0	1	0
11	0	0	0	0	1
12	0	1	1	1	0
13	1	0	1	1	0
14	1	0	1	1	1
15	1	1	1	1	1;

param d:=	1 0
			2 3
			3 2
			4 1
			5 2
			6 3
			7 2
			8 3
			9 3
			10 2
			11 1
			12 2
			13 3
			14 1
			15 0;

param t:
	1	2	3	4	5	6	7	8	9	10	11	12	13	14	15:=
1	0	2	3	2	4	5	3	2	2	2	2	3	3	3	4
2	2	0	2	3	4	3	2	3	3	2	3	3	2	3	3
3	3	2	0	2	1	2	3	3	3	3	3	3	3	3	3
4	2	3	2	0	1	3	3	2	2	2	2	3	3	3	3
5	4	4	1	1	0	2	2	4	4	4	4	1	1	1	1
6	5	3	2	3	2	0	1	1	2	3	4	4	3	2	1
7	3	2	3	3	2	1	0	1	1	2	2	3	3	4	4
8	2	3	3	2	4	1	1	0	1	1	1	2	2	2	2
9	2	3	3	2	4	2	1	1	0	3	2	2	2	2	2
10	2	2	3	2	4	3	2	1	3	0	2	1	2	1	2
11	2	3	3	2	4	4	2	1	2	2	0	4	4	3	1
12	3	3	3	3	1	4	3	2	2	1	4	0	1	2	2
13	3	2	3	3	1	3	3	2	2	2	4	1	0	1	2
14	3	3	3	3	1	2	4	2	2	1	3	2	1	0	4
15	4	3	3	3	1	1	4	2	2	2	1	2	2	4	0;

param c:
	1	2	3	4	5	6	7	8	9	10	11	12	13	14	15:=
1	0	2	3	2	4	5	3	2	2	2	2	3	3	3	4
2	2	0	2	3	4	3	2	3	3	2	3	3	2	3	3
3	3	2	0	2	1	2	3	3	3	3	3	3	3	3	3
4	2	3	2	0	1	3	3	2	2	2	2	3	3	3	3
5	4	4	1	1	0	2	2	4	4	4	4	1	1	1	1
6	5	3	2	3	2	0	1	1	2	3	4	4	3	2	1
7	3	2	3	3	2	1	0	1	1	2	2	3	3	4	4
8	2	3	3	2	4	1	1	0	1	1	1	2	2	2	2
9	2	3	3	2	4	2	1	1	0	3	2	2	2	2	2
10	2	2	3	2	4	3	2	1	3	0	2	1	2	1	2
11	2	3	3	2	4	4	2	1	2	2	0	4	4	3	1
12	3	3	3	3	1	4	3	2	2	1	4	0	1	2	2
13	3	2	3	3	1	3	3	2	2	2	4	1	0	1	2
14	3	3	3	3	1	2	4	2	2	1	3	2	1	0	4
15	4	3	3	3	1	1	4	2	2	2	1	2	2	4	0;

param e:=	1 0
			2 0
			3 2
			4 4
			5 4
			6 3
			7 2
			8 2
			9 6
			10 5
			11 6
			12 5
			13 7
			14 8
			15 7;

param l:=	1 20
			2 3
			3 5
			4 7
			5 6
			6 7
			7 8
			8 4
			9 9
			10 7
			11 8
			12 10
			13 8
			14 9
			15 10;

end;