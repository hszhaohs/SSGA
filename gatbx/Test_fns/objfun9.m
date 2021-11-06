% OBJFUN9.M      (OBJective function for sum of different power FUNction 9)
%
% This function implements the sum of different power.
%
% Syntax:  ObjVal = objfun9(Chrom,rtn_type)
%
% Input parameters:
%    Chrom     - Matrix containing the chromosomes of the current
%                population. Each row corresponds to one individual's
%                string representation.
%                if Chrom == [], then special values will be returned
%    rtn_type  - if Chrom == [] and
%                rtn_type == 1 (or []) return boundaries
%                rtn_type == 2 return title
%                rtn_type == 3 return value of global minimum
%
% Output parameters:
%    ObjVal    - Column vector containing the objective values of the
%                individuals in the current population.
%                if called with Chrom == [], then ObjVal contains
%                rtn_type == 1, matrix with the boundaries of the function
%                rtn_type == 2, text for the title of the graphic output
%                rtn_type == 3, value of global minimum
%                
%
% Author:     Hartmut Pohlheim
% History:    07.04.94     file created
%             14.01.03     updated for MATLAB v6 by Alex Shenfield

function ObjVal = objfun9(Chrom,rtn_type);

% Dimension of objective function
   Dim = 10;
   
% Compute population parameters
   [Nind,Nvar] = size(Chrom);

% Check size of Chrom and do the appropriate thing
   % if Chrom is [], then define size of boundary-matrix and values
   if Nind == 0
      % return text of title for graphic output
      if rtn_type == 2
         ObjVal = ['Sum of different Power 9-' int2str(Dim)];
      % return value of global minimum
      elseif rtn_type == 3
         ObjVal = 0;
      % define size of boundary-matrix and values
      else   
         % lower and upper bound, identical for all n variables        
         ObjVal = [-1; 1];
         ObjVal = ObjVal(1:2,ones(Dim,1));
      end
   % if Dim variables, compute values of function
   elseif Nvar == Dim
      % function 9, sum of abs(xi)^(i+1) for i = 1:Dim (Dim=30)
      % n = Dim, -1 <= xi <= 1
      % global minimum at (xi)=(0) ; fmin=0
      nummer = rep(1:Dim,[Nind 1]);
      ObjVal = sum((abs(Chrom).^(nummer+1))')';
   % otherwise error, wrong format of Chrom
   else
      error('size of matrix Chrom is not correct for function evaluation');
   end   


% End of function