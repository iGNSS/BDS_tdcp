function value = gaussf(x, mu, sigma)
%GAUSSFUN 
%   ���˹��
 
    value = exp(- ((x - mu)./sigma).^2);

end

