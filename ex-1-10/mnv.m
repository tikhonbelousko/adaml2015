function result = mnv(x, sigma)
    result = zeros(size(x));
    [rows, columns] = size(x);
    for i = 1:columns
        t1 = x(:,i) - mean(x(:,i));
        t2 = sigma(i, i);
        newRow= t1/t2;
        result(:,i) = newRow;
    end
end