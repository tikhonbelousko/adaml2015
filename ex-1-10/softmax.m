function result = softmax(x, sigma)
    y = mnv(x, sigma);
    result = arrayfun(@(x) 1/(1+exp(-x)), y); 
end