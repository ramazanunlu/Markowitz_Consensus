%tic
function [OptiAllocation]=markowitz2(P1,P1Cov,P1Ret,P1RetAnn,P1StdAnn)
nAssets=numel(P1Ret);
Aineq=-P1Ret';
r=0.0000001:0.000001:0.1;
Aeq=ones(1,nAssets);
Beq=1;
lb=zeros(nAssets,1);
ub=ones(nAssets,1);
c=zeros(nAssets,1);
options=optimset('Algorithm','interior-point-convex');
options=optimset(options,'Display','iter','Tolfun',1e-10);
x0=[1 0 0 0 0];

for i= 1:1:100
    
    [x,fval,converge]=quadprog(P1Cov,c,Aineq,-r(i),Aeq,Beq,lb,ub,x0,options);
    
    if (converge == 1)
        
        pMean=x'*P1Ret;
        pVar=sqrt(x'*P1Cov*x);
        
        pMeanAnn=(((1+pMean)^360)-1);
        pVarAnn=(pVar*sqrt(360));
        pSharpe=pMeanAnn/pVarAnn;
        
        Output(1,i) = pMean;
        Output(2,i) = pMeanAnn;
        Output(3,i) = pVar;
        Output(4,i) = pVarAnn;
        Output(5,i) = pSharpe;
        Output(7,i) = x(1,1);
        Output(8,i) = x(2,1);
        Output(9,i) = x(3,1);
        Output(10,i) = x(4,1);
        Output(11,i) = x(5,1);
      
        
        pMean=0;
        pVar=0;
        pMeanAnn=0;
        pVarAnn=0;
        pSharpe=0;
        
        continue;
        
    else;
        
        break;
        
    end
end

maxSharpe=max(Output(5,:));
[row,col]=find(maxSharpe == Output);

if length(col)>1
    col=col(1);
    row=row(1);
end
OptiDailyRet = Output(1,col);
OptiDailyVar = Output(3,col);
OptiYearlyRet = Output(2,col);
OptiYearlyVar = Output(4,col);

OptiAllocation=[OptiDailyRet
                OptiDailyVar
                OptiYearlyRet
                OptiYearlyVar
                maxSharpe
                Output(7,col)
                Output(8,col)
                Output(9,col)
                Output(10,col)
                Output(11,col)
                ];
%hold
%plot(output(4,:),output(2,:))
%title('Efficient Frontier')
%xlabel('Portfolio Risk')
%ylabel('Portfolio Return')
%plot(OptiAllocation(4,1),OptiAllocation(3,1),'o');
%print('dpng','-r300','Efficient Frontier');
%plot(P1StdAnn,P1RetAnn,'x');
%axis('on');
%toc
end