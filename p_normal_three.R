library(MASS)
sum1=0
sum2=0
sum3=0
sum4=0


for (z in 1:1000){

library(MASS)
n1=150
n2=160
n3=170
n4 =0
N=list(n1,n2,n3,n4)
n0 = sum(diag(N))
n=n0
p=3
k=3
I=diag(p)
c_start = c(1,9,18)
temp = c(0.1,0.2,0.3)%*%t(c(0.1,0.2,0.3))/10
Sigma1 =(I+temp)
Sigma2 = c_start[2]*Sigma1
Sigma3 = c_start[3]*Sigma1

x1=mvrnorm(n=n1, c(1,2.5,3) ,Sigma1)
x2=mvrnorm(n=n2,c(1,2,3), Sigma2)
x3=mvrnorm(n=n3, c(1,2,3), Sigma3)
x4=mvrnorm(n=n3, c(1.1,2,3), Sigma3)

X=list(x1,x2,x3,x4)

#----------------以下是u统计量方法




yy=0
si=0

for (i in 1:k){
mean_y=apply(X[[i]],MARGIN=2,mean)
sy = cov(X[[i]])
yy = yy+N[[i]]*(n0-N[[i]])/(n0^2)*t(mean_y)%*%mean_y
si = si+N[[i]]*(n0-N[[i]])/(n0^2)*sum(diag(sy))/N[[i]]
}

yx=0
for (i in 1:k){
for (j in 1:k){
if (i!=j){
mean_x=apply(X[[i]],MARGIN=2,mean)
mean_y=apply(X[[j]],MARGIN=2,mean)
yx = yx+N[[i]]*N[[j]]/n0^2*t(mean_x)%*%mean_y
}
}
}
TU = yy-yx-si




mean_y1 =  apply(X[[1]],MARGIN=2,mean)
mean_y2 =  apply(X[[2]],MARGIN=2,mean)
mean_y3 =  apply(X[[3]],MARGIN=2,mean)
mean_y4 =  apply(X[[4]],MARGIN=2,mean)
mean_y = list(mean_y1,mean_y2,mean_y3,mean_y4)
fan4_x = c(0,0,0,0)
fan4x = c(0,0,0,0)
tr_sx = c(0,0,0,0)
for (t in (1:k))
{

for (i in (1:length(X[[t]][,1]))){
for (j in (1:p)){
fan4_x[t] = fan4_x[t] + (X[[t]][i,j]-mean_y[[t]][j])^4
}
}
fan4x[t] = (fan4_x[t])^(1/4)


tr_sx[t] = (N[[t]]-1)/(N[[t]]*(N[[t]]-2)*(N[[t]]-3))*((N[[t]]-1)*(N[[t]]-2)*sum(diag(cov(X[[t]])^2))+
sum(diag(cov(X[[t]])))^2-N[[t]]*fan4x[t]/(N[[t]]-1))
}
trs1=0
trs2=0
for (t in 1:k){
trs1 = trs1+(n0-N[[t]])^2*N[[t]]/(n0^4*(N[[t]]-1))*tr_sx[t]}

for (i in 1:k){
for (j in 1:k){
if (i!=j){
trs2 = trs2 + N[[i]]*N[[j]]/n0^4*sum(diag(cov(X[[i]])*cov(X[[j]])))
}
}
}
sigmaT2=2*(trs1+trs2)

if(TU/(sigmaT2)^(1/2)>=qnorm(0.975)){
sum1=sum1+1
}
if(TU/(sigmaT2)^(1/2)<=qnorm(0.025)){
sum1=sum1+1
}


##---------------------------------以上是u统计量方法
##---------------------------------以下是似然比检验法





#--------初始化tnp
mean_x = list()
si=list()
s=matrix(0,p,p)
for(i in 1:k){
mean_x[[i]] = colMeans(X[[i]])
si[[i]]=(N[[i]]-1)/N[[i]]*cov(X[[i]])

}


hat_lmax = c()
hat_lmin = c()
range_cmin = c()
range_cmax = c()
for( i in 1:k){
hat_lmax[i] = max(eigen(si[[i]])$val)
hat_lmin[i] = min(eigen(si[[i]])$val)
}
for( i in 1:k){
range_cmin[i] = hat_lmin[i]/hat_lmax[1]
range_cmax[i] = hat_lmax[i]/hat_lmax[1]
}
c2 = seq(range_cmin[2],range_cmax[2],0.01)
c3 = seq(range_cmin[3],range_cmax[3],0.01)

Y1=matrix(0,length(c2),length(c3))
Y2=matrix(0,length(c2),length(c3))

for(i in 1:length(c2)){
for(j in 1:length(c3)){
  Y1[i,j] = -1/2*p*n*log(2*pi)-
p/2*(n2*log(c2[i])+n3*log(c3[j]))-
n/2*log(det(1/n*(n1*si[[1]]+n2/c2[i]*si[[2]]+n3/c3[j]*si[[3]])))-
n*p/2-
1/2*(n1*t(mean_x[[1]]-(n1*mean_x[[1]]+n2/c2[i]*mean_x[[2]]+n3/c3[j]*mean_x[[3]])/(n1+n2/c2[i]+n3/c3[j]))%*% solve(1/n*(n1*si[[1]]+n2/c2[i]*si[[2]]+n3/c3[j]*si[[3]])) %*% (mean_x[[1]]-(n1*mean_x[[1]]+n2/c2[i]*mean_x[[2]]+n3/c3[j]*mean_x[[3]])/(n1+n2/c2[i]+n3/c3[j]))+
n2/c2[i]*t(mean_x[[2]]-(n1*mean_x[[1]]+n2/c2[i]*mean_x[[2]]+n3/c3[j]*mean_x[[3]])/(n1+n2/c2[i]+n3/c3[j]))%*% solve(1/n*(n1*si[[1]]+n2/c2[i]*si[[2]]+n3/c3[j]*si[[3]])) %*% (mean_x[[2]]-(n1*mean_x[[1]]+n2/c2[i]*mean_x[[2]]+n3/c3[j]*mean_x[[3]])/(n1+n2/c2[i]+n3/c3[j])) +
n3/c3[j]*t(mean_x[[3]]-(n1*mean_x[[1]]+n2/c2[i]*mean_x[[2]]+n3/c3[j]*mean_x[[3]])/(n1+n2/c2[i]+n3/c3[j]))%*% solve(1/n*(n1*si[[1]]+n2/c2[i]*si[[2]]+n3/c3[j]*si[[3]])) %*% (mean_x[[3]]-(n1*mean_x[[1]]+n2/c2[i]*mean_x[[2]]+n3/c3[j]*mean_x[[3]])/(n1+n2/c2[i]+n3/c3[j]))   )
  
}
}



for(i in 1:length(c2)){
for(j in 1:length(c3)){
 Y2[i,j]  = -1/2*p*n*log(2*pi)-
p/2*(n2*log(c2[i])+n3*log(c3[j]))-
n/2*log(det(1/n*(n1*si[[1]]+n2/c2[i]*si[[2]]+n3/c3[j]*si[[3]])))-n*p/2

}
}
    ln0 = -100000;
    for (i in 1:length(c2)){
        for (j in 1:length(c3)){
            if(ln0<=Y1[i,j]){
                ln0 = Y1[i,j]
            }
       }
    }

     ln1 = -100000;
    for (i in 1:length(c2)){
        for (j in 1:length(c3)){
            if(ln1<=Y2[i,j]){
                ln1 = Y2[i,j]
            }
       }
    }


Ts = 2*(ln1-ln0)

if(Ts>=qchisq(0.95,p*(k-1))){
sum3=sum3+1
}


#tn----------

#--------初始化
s=matrix(0,p,p)
si=matrix(0,p,p)
s_x=matrix(0,p,1)
mean_x = list()
lamada = 0




for(i in 1:k){
mean_x[[i]] = colMeans(X[[i]])
si=(N[[i]]-1)/N[[i]]*cov(X[[i]])
s=s+N[[i]]*solve(si)
s_x = s_x+N[[i]]*solve(si)%*%mean_x[[i]] 
}
mu_mle = solve(s)%*%s_x
for(i in 1:k){
si=(N[[i]]-1)/N[[i]]*cov(X[[i]])
lamada = lamada + N[[i]]*t(mean_x[[i]]-mu_mle)%*%solve(si)%*%(mean_x[[i]]- mu_mle)
}
if(lamada>=qchisq(0.95,p*(k-1))){
sum4=sum4+1
}

}


p1=sum1/1000#u
p3 = sum3/1000#tnp

p4=sum4/1000#tn
p1
p3
p4
