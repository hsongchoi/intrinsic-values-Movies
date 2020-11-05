
addpath 'C:\Users\akrishna39\Desktop\office desktop\Courses\Spring 2017\ISyE 6416\Project\Movie project';
rng(22);

data=csvread('data_miss.csv',1,0);
List_ML = [];

%% Initializing

data_size=size(data);
P=data_size(1);
R=data_size(2)-1;
mu_p=randn(P,1)+5;
%mu_r=randn(R,1)-1;
var_p=ones(P,1);
%var_r=ones(R,1);
x_pr=data(:,2:7);

 idx = x_pr~=0;
 non_miss = sum(idx,2);

mu_pr_Y=zeros(P,R);
mu_pr_Z=zeros(P,R);
SIGMA_pr_YY=zeros(P,R);
SIGMA_pr_ZZ=zeros(P,R);

%% Iteration
var_err=2.5;
for k = 1 : 900
%% Define variables

    for i = 1 : P
        for j = 1 : R
             if(x_pr(i,j)==0)
                
                    continue
            end
        mu_pr_Y(i,j) = mu_p(i) + (var_p(i)/(var_p(i) + var_r(j) + var_err))*(x_pr(i,j) - mu_p(i) - mu_r(j));
        mu_pr_Z(i,j) = mu_r(j) + (var_r(j)/(var_p(i) + var_r(j) + var_err))*(x_pr(i,j) - mu_p(i) - mu_r(j));
         SIGMA_pr_YY(i,j) = (1/(var_p(i) + var_r(j) + var_err))*(var_p(i)*(var_r(j)+var_err));
         SIGMA_pr_ZZ(i,j) = (1/(var_p(i) + var_r(j) + var_err))*(var_r(j)*(var_p(i)+var_err));
        end
    end

%% Update the parameters
    mu_p_matrix = repmat( mu_p, 1, R );
  % mu_r_matrix = repmat( mu_r, 1, P )';

    var_p = (mean(SIGMA_pr_YY,2)+mean((mu_pr_Y.^2),2)- ...
            mean(2*mu_pr_Y.*mu_p_matrix,2)+mu_p.^2).*(R./non_miss);
        
  %  var_r = (mean(SIGMA_pr_ZZ,1)+mean((mu_pr_Z.^2),1))'- ...
           % mean(2*mu_pr_Z.*mu_r_matrix,1)'+mu_r.^2;
        
    mu_p = (mean(mu_pr_Y,2)).*(R./non_miss);
  %  mu_r = mean(mu_pr_Z,1)';
    
%% Define Maximum Likelihood Function
    ML=0;
    for i = 1 : P 
         for j = 1 : R
            ML = ML + log(1/var_p(i)*var_r(j))-(1/2*var_p(i))*(SIGMA_pr_YY(i,j)+ ...
                (mu_pr_Y(i,j)^2)-2*mu_pr_Y(i,j)*mu_p(i)+mu_p(i)^2)- ...
                (1/2*var_r(j))*(SIGMA_pr_ZZ(i,j)+(mu_pr_Z(i,j)^2)- ...
                2*mu_pr_Z(i,j)*mu_r(j)+mu_r(j)^2);  
         end
    end
    List_ML = [List_ML,ML];
   
   % List_ML
end
plot(List_ML)
ylim([-250 50])
%[transdat,lambda] = boxcox(xshape)

sd_p=sqrt(var_p)
sd_r=sqrt(var_r)
ci_movie=[mu_p-sd_p*1.96 mu_p+sd_p*1.96]
ci_bias=[mu_r-sd_r*1.96 mu_r+sd_r*1.96]


