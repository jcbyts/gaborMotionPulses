%% make hexagonal grid

cxy = [0 0];
nx = [3 4 5 4 3]; % number per row

xs = nan(sum(nx),1);
for jj = 1:numel(nx)
    vs = 1:nx(jj);
    ii = sum(nx(1:jj-1));
    xs(ii+1:ii+nx(jj)) = vs - ceil(numel(vs)/2) - 0.5*mod(nx(jj)-1,2);
end

y0 = (1:numel(nx)) - ceil(numel(nx)/2);
ys = nan(sum(nx),1);
for jj = 1:numel(nx)
    ii = sum(nx(1:jj-1));
    ys(ii+1:ii+nx(jj)) = y0(jj);
end
Xxy = [csc(deg2rad(60))*xs ys] + repmat(cxy, numel(xs), 1);

%% true RF

mu = mean(Xxy); Sigma = [1 0; 0 1];
wf = mvnpdf(Xxy, mu, 3*Sigma)';

figure(1); axis off;
plot.plotKernelSingle(Xxy, wf);

%% create stimulus and response

seed = 388; %round(rand*1000);
rng(seed);

nt = 6000; nw = size(Xxy,1);
X = 2*rand(nt,nw)-1;
e = randn(nt,1);
Y = X*wf' + 0.4*e;
D = asd.sqdist.space(Xxy);

%% fit ML, ASD

scoreObj = reg.getScoreObj(true, 'rsq');
ML = reg.getObj_ML(X, Y);
ML = reg.fitAndScore(X, Y, ML, scoreObj);
ASD = reg.getObj_ASD(X, Y, D, scoreObj);
ASD = reg.fitAndScore(X, Y, ASD, scoreObj);

figure(2); axis off;
plot.plotKernelSingle(Xxy, ML.w);
figure(3); axis off;
plot.plotKernelSingle(Xxy, ASD.w);

disp([ML.score ASD.score]);
