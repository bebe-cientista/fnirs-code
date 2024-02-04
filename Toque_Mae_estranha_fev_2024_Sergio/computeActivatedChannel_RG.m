function[active, d_Cohen] = computeActivatedChannel(HbO,HbR,t,t0,t1)


bp = find(t>t0 & t<=0);%Baseline Period 
tp = find(t>2 & t<=t1);%Task period


for Nsub=1:size(HbO,3)
    
    for Nchan=1:size(HbO,2)
        if ~isnan(HbO(1,Nchan,Nsub))
            
            d_Cohen(Nsub,Nchan,1) = ...%HbO
                computeCohen_d(HbO(tp,Nchan,Nsub),HbO(bp,Nchan,Nsub),'independent');
            d_Cohen(Nsub,Nchan,2) = ...%HbR
                computeCohen_d(HbR(tp,Nchan,Nsub),HbR(bp,Nchan,Nsub),'independent');
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