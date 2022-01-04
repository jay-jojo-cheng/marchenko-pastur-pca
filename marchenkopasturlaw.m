% The original assumes the dimensions m<n and normalizes incorrectly.
% This version is general and normalizes correctly.

clear;
close all;

m=1250;
n=1250;
% Ratio of matrix dimensions
c=m/n;

% Sample
x=randn(m,n); % Normal distribution
%x=rand(N,T);  % Uniform distribution
s=std(x(:));
% spectral matrix
r=x*x'/n;
%eigenvalues
l=eig(r);
% negative eigenvalues are a numerical issue so we set to zero
% one can double-check that they are all extremely small in magnitude
l(l<0) = abs(l(l<0));

% Empirical PDF histogram
% number of bins
numbins=50;

% Boundaries 
a=(s^2)*(1-sqrt(c))^2;
b=(s^2)*(1+sqrt(c))^2;

% create histogram
figure(1);
h=histogram(l,numbins,'BinLimits',[0,max(l)],'Normalization','pdf');
% ,'Normalization','probability'
f=h.Values;
lambda=h.BinEdges;
xlabel('Eigenvalue x');
title(['Marchenko Pastur distribution $\gamma=$',num2str(c)],'interpreter','latex');
lmin=min(l);
lmax=max(l);

% Theoretical pdf
ft=@(lambda,a,b,c) (1./(2*pi*lambda*c*s^(2))).*sqrt((b-lambda).*(lambda-a));
F = ft(lambda,a,b,c);
F = real(F);
F(isnan(F))=0;

% Plot theoretical pdf
hold on;
plot(lambda,F,'g','LineWidth',2);
stem(0,inf);
hold off;

% Zooming in on the nonzero bulk spectrum
if c > 1
    figure(2);
    h=histogram(l,numbins,'BinLimits',[a,max(l)],'Normalization','pdf');
    f=h.Values;
    lambda=h.BinEdges;
    xlabel('Eigenvalue x');
    title(' Marchenko Pastur distribution without zeros');
    lmin=min(l);
    lmax=max(l);
    
    F = ft(lambda,a,b,c);
    F = real(F);
    F(isnan(F))=0;

    % Plot theoretical pdf
    hold on;
    plot(lambda,F,'g','LineWidth',2);
    stem(0,inf);
    hold off;
end