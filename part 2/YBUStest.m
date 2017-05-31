%calculating the admittance matrix Y
j=sqrt(-1); i = sqrt(-1);
nl = linedata(:,1); 
nr = linedata(:,2); 
R = linedata(:,3);
X = linedata(:,4); 
Bc = j*linedata(:,5);
a = linedata(:,6);
nbr=length(linedata(:,1)); 
nbus = max(max(nl), max(nr));
Z = R + j*X; 
tapratio = ones(nbus,nbus);

% ybr= ones(nbr,1)./Z;        %branch admittance  % y1 = zeros(nbus,nbus);  %y
% y2 = zeros(nbus,nbus);  %y'% Ybus = zeros(nbus,nbus); %Y
y= ones(nbr,1)./Z;        %branch admittance
for n = 1:nbr
    if a(n) <= 0
        a(n) = 1;
    end
    tapratio(linedata(n,1),linedata(n,2)) = linedata(n,6);
end

Ybus=zeros(nbus,nbus);     % initialize Ybus to zero

% formation of the off diagonal elements
for k=1:nbr
       Ybus(nl(k),nr(k))=Ybus(nl(k),nr(k))-y(k)*a(k);
       Ybus(nr(k),nl(k))=Ybus(nl(k),nr(k));
end
              % formation of the diagonal elements
for  n=1:nbus
     for k=1:nbr
         if nl(k)==n
         Ybus(n,n) = Ybus(n,n)+y(k)*(a(k)^2) + Bc(k);
         elseif nr(k)==n
         Ybus(n,n) = Ybus(n,n)+y(k) +Bc(k);
         else, end
     end
end

% for n = 1:nbr
%     y1(bus1(n),bus2(n)) = ybr(n)/a(k);
%     y1(bus2(n),bus1(n)) = ybr(n)/a(k);
%     y2(bus1(n),bus2(n)) = Bc(n);
%     y2(bus2(n),bus1(n)) = Bc(n);
% end

% for n = 1:nbus
%     for k = 1:nbus
%         if(n == k)                %diagonal
%             for p = 1:nbus
%                 Ybus(n,k) = Ybus(n,k) + y1(n,p)/(a(k));
%                 Ybus(n,k) = Ybus(n,k) + y2(n,p);
%             end
%         else                      %non-diagonal
%             Ybus(n,k) = -y1(n,k);
%         end
%     end
% end

