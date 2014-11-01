function pltmsh(xnod, ielem, type_line)
    
    if (nargin < 3) 
        type_line = 'w'; 
    end
    
    [numel, nel] = size(ielem);
    
    X = []; 
    Y = [];
    
    for k=1:nel,

        X = [ X ; xnod(ielem(:,k),1)' ];
        Y = [ Y ; xnod(ielem(:,k),2)' ];

    end

    patch(X, Y, type_line)
    
end
