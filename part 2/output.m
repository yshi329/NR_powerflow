%voltage level
%fprintf('The voltage level of buses:\n')
vbusfinal = zeros(nbus,1);
thetabusfinal =zeros(nbus,1);
for i = 1:nbus
    vbusfinal(invmapping(i)) = vbus(i);
    thetabusfinal(invmapping(i)) = thetabus(i);
end

vbusfinal
thetabusfinal