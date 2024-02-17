function[active, d_Cohen] = computeActivatedChannel_ME(HbO_M,HbR_M,HbO_E,HbR_E,t,t0,t1)


%bp = find(t>t0 & t<=0);%Baseline Period 
tp = find(t>2 & t<=t1);%Task period


for Nsub=1:size(HbO_M,3)
    
    for Nchan=1:size(HbO_M,2)
        if ~isnan(HbO_M(1,Nchan,Nsub))
            
            d_Cohen(Nsub,Nchan,1) = ...%HbO
                computeCohen_d(HbO_M(tp,Nchan,Nsub),HbO_E(tp,Nchan,Nsub),'independent');
            d_Cohen(Nsub,Nchan,2) = ...%HbR
                computeCohen_d(HbR_M(tp,Nchan,Nsub),HbR_E(tp,Nchan,Nsub),'independent');
            if d_Cohen(Nsub,Nchan,1)>=0.8 && d_Cohen(Nsub,Nchan,2)<=-0.8
                active(Nsub,Nchan)=1;
            else
                active(Nsub,Nchan)=0;
            end
        else
            active(Nsub,Nchan)=nan;
        end
    end
    
end




end