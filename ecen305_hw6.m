%X~binomial (n,p): E[X] = np.
%                : Var[X] = E[X^2] - E[X]^2 = np(1-p).
%                : StDev[X] = sqrt(Var[X]) = sqrt(np(1-p)).

NUM_SAMPS = 10000;
n = [10 1000 100000];
p = [0.1 0.4];

res = zeros(3,7);
row = 1;
col = 1;
res(1,7) = .5;
res(2,7) = 1-.8413;
res(3,7) = 1-.97725;

X = 0;
mean = 0;
std_dev = 0;

mn0sd = 0;
mn1sd = 0;
mn2sd = 0;

for a = 1:length(n)
    for b = 1:length(p)
        for c = 1:NUM_SAMPS
            X = sum(rand(n(a),1)<p(b));
            mean = n(a)*p(b);
            std_dev = sqrt(n(a)*p(b)*(1-p(b)));
            
            if X > mean
                mn0sd = mn0sd + 1;
            end
            
            if X > mean + std_dev
                mn1sd = mn1sd + 1;
            end
            
            if X > mean + 2*std_dev
                mn2sd = mn2sd + 1;
            end
        end
        
        res(row,col) = mn0sd/NUM_SAMPS;
        row = row + 1;
        res(row,col) = mn1sd/NUM_SAMPS;
        row = row + 1;
        res(row,col) = mn2sd/NUM_SAMPS;
        row = row + 1;
        row = 1;
        col = col + 1;
        mn0sd = 0;
        mn1sd = 0;
        mn2sd = 0;
    end
end

myTbl = array2table(res,'VariableNames',{'n10p1','n10p4','n1000p1','n1000p4','n10000p1','n10000p4','Q'},'RowNames',{'Mean','Mean1StdDev','Mean2StdDev'});
disp(myTbl);