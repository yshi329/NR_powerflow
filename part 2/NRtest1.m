%% This prgram aims to calculate the unknowns using NR method
%developed by Luo Yifeng Shi Yunfei
% slack bus -> bus 1
% PV bus #npv -> bus 2 - npv+1 
% PQ bus #npq -> bus nbus-npq+1 - nbus

%x = zeros(npv+npq*2,1); %all unknown v and delta

vbus = ones(nbus,1);
thetabus = zeros(nbus,1);

vbus(1) = slack(3);
for n = 2:npv+1
 vbus(n) = PV_bus(n-1,3);
end


pqknown = zeros(npv+2*npq,1);
nknown = 1;%counter
%pqknown : 
%P -> 1 - ?nknown-npq
%Q -> nknown-npq+1 ?- nknown

for n = 1:npv
 pqknown(nknown) = PV_bus(n,4);  %P
 nknown = nknown+1;
end
for n = 1:npq
 pqknown(nknown) = PQ_bus(n,4);
 nknown = nknown+1;
end
for n = 1:npq
 pqknown(nknown) = PQ_bus(n,5);
 nknown = nknown+1;
end
nknown = nknown-1;



maxerror = 1;
iter = 0;
accuracy = 0.001;
maxiter=0;
while (maxerror >= accuracy) && (iter <= maxiter)
 pqdelta = pqknown;
 for n = 1:nknown-npq
  for k = 1:nbus
   pqdelta(n) = pqdelta(n) - vbus(n+1)*vbus(k)*(real(Ybus(n+1,k))*cos(thetabus(n+1)-thetabus(k)) + imag(Ybus(n+1,k))*sin(thetabus(n+1)-thetabus(k)));
  end
 end
 for n = nknown-npq+1:nknown
  for k = 1:nbus
   pqdelta(n) = pqdelta(n) - vbus(n-npq+1)*vbus(k)*(real(Ybus(n-npq+1,k))*sin(thetabus(n-npq+1)-thetabus(k)) - imag(Ybus(n-npq+1,k))*cos(thetabus(n-npq+1)-thetabus(k)));
  end
 end
 
 H = zeros(npv+npq,npv+npq);
 for n = 1:npv+npq
  for k = 1:npv+npq
   if k+1 == n+1
    for p = 1:nbus
     if p ~= n+1
      H(n,k) = H(n,k) - vbus(n+1)*vbus(p)/tapratio(p,n+1)*(-real(Ybus(n+1,p))*sin(thetabus(n+1)-thetabus(p))+imag(Ybus(n+1,p))*cos(thetabus(n+1)-thetabus(p)));
     end
    end
   else
    H(n,k) = -vbus(n+1)*vbus(k+1)/tapratio(n+1,k+1)*(real(Ybus(n+1,k+1))*sin(thetabus(n+1)-thetabus(k+1))-imag(Ybus(n+1,k+1))*cos(thetabus(n+1)-thetabus(k+1)));
   end
  end
 end
 
 N = zeros(npv+npq,npq);
 for n = 1:npv+npq
  for k = 1:npq
   if k+npv+1 == n+1
    for p = 1:nbus
        if p ~= n+1
            N(n,k) = N(n,k) - vbus(p)*(real(Ybus(n+1,p))*cos(thetabus(n+1)-thetabus(p))+imag(Ybus(n+1,p))*sin(thetabus(n+1)-thetabus(p)));
        else
            N(n,k) = N(n,k) - 2*vbus(p)*real(Ybus(p,p));
        end            
    end
   else
    N(n,k) = -vbus(n+1)*(real(Ybus(n+1,k+npv+1))*cos(thetabus(n+1)-thetabus(k+npv+1))+imag(Ybus(n+1,k+npv+1))*sin(thetabus(n+1)-thetabus(k+npv+1)));
   end
  end
 end
 
 J = zeros(npq,npv+npq);
  for n = 1:npq
   for k = 1:npv+npq
    if k+1 == n+npv+1
     for p = 1:nbus
         if p ~= k+1
             J(n,k) = J(n,k) - vbus(n+npv+1)*vbus(p)*(real(Ybus(n+npv+1,p))*cos(thetabus(n+npv+1)-thetabus(p))+imag(Ybus(n+npv+1,p))*sin(thetabus(n+npv+1)-thetabus(p)));
         end
     end
    else
     J(n,k) = vbus(n+npv+1)*vbus(k+1)*(real(Ybus(n+npv+1,k+1))*cos(thetabus(n+npv+1)-thetabus(k+1))+imag(Ybus(n+npv+1,k+1))*sin(thetabus(n+npv+1)-thetabus(k+1)));
    end
   end
  end
 
 L = zeros(npq,npq);
 for n = 1:npq
  for k = 1:npq
   if k+npv+1 == n+npv+1
    for p = 1:nbus
        if p ~= k+npv+1
            L(n,k) = L(n,k) - vbus(p)*(real(Ybus(n+npv+1,p))*sin(thetabus(n+npv+1)-thetabus(p))-imag(Ybus(n+npv+1,p))*cos(thetabus(n+npv+1)-thetabus(p)));
        else
            L(n,k) = L(n,k) + 2*vbus(p)*imag(Ybus(p,p));
        end
    end
   else
    L(n,k) = -vbus(n+npv+1)*(real(Ybus(n+npv+1,k+npv+1))*sin(thetabus(n+npv+1)-thetabus(k+npv+1))-imag(Ybus(n+npv+1,k+npv+1))*cos(thetabus(n+npv+1)-thetabus(k+npv+1)));
   end
  end
 end
 
 
 
 
 

 Jac = [H N ; J L];
 invJac = pinv(Jac);
 vthetadelta = invJac * pqdelta;
 maxerror = max(abs(vthetadelta));
 iter = iter + 1;
 
 for n = 2:nbus
  thetabus(n) = thetabus(n) - vthetadelta(n-1);
 end
 for n = nbus-npq+1:nbus
  vbus(n) = vbus(n) - vthetadelta(n+npq-1);
 end

 
end

