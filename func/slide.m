function [ ] = slide( c, X,Y,Z, i)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

n = size(X, 1);

switch (c)
    case 1
        mesh(reshape(X(i,:,:),[n n]),reshape(Y(i,:,:),[n n]),reshape(Z(i,:,:),[n n]));
    case 2
        mesh(reshape(X(:,i,:),[n n]),reshape(Y(:,i,:),[n n]),reshape(Z(:,i,:),[n n]));
    case 3
        mesh(reshape(X(:,:,i),[n n]),reshape(Y(:,:,i),[n n]),reshape(Z(:,:,i),[n n]));
end

end

