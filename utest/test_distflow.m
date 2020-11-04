clear; clc; close all;

define_constants;
% option.alpha = 1/2;
% distflow_lossy(mpc, option);

mpc = loadcase('C:\Users\still\Documents\Github\DistributionNetworks-HostingCapacity\case56_sce\case56_sce.m');
nbus = size(mpc.bus,1);
nline = size(mpc.branch,1);

result.ac = runpf(mpc);
% result.dc = rundcpf(mpc);
option.alpha = 1/2;
result.ldistflow = distflow_lossy(mpc, option);
option.alpha = 0.1;
result.distflow0 = distflow_lossy(mpc, option);
option.alpha = 0.9;
result.distflow1 = distflow_lossy(mpc, option);

f_vm = figure;
plot(1:nbus, result.ac.bus(:,VM),'.'), hold on,
plot(1:nbus, result.ldistflow.bus(:,VM),'o'), hold on,
% plot(1:nbus, result.distflow0.bus(:,VM),'.'), hold on,
% plot(1:nbus, result.distflow1.bus(:,VM),'.'), hold on,
% plot(1:nbus, result.dc.bus(:,VM),'.'), hold on,
xlabel('bus index'),ylabel('voltage magnitude (p.u.)')
legend('AC','lDistFlow')
% ,'DistFlow (\alpha=0.1)','DistFlow (\alpha=0.9)'
hold off
print(f_vm,'-dpng','VM-comparison.png')

f_flow = figure;
subplot(2,1,1)
plot(1:nline,result.ac.branch(:,PF)-result.ac.branch(:,PT),'.'), hold on,
plot(1:nline,result.ldistflow.branch(:,PF)-result.ldistflow.branch(:,PT),'o'), hold on,
xlabel('bus index'),ylabel('line flow (MW)')
legend('AC','lDistFlow')
subplot(2,1,2)
plot(1:nline,result.ac.branch(:,QF)-result.ac.branch(:,QT),'.'), hold on,
plot(1:nline,result.ldistflow.branch(:,QF)-result.ldistflow.branch(:,QT),'o'), hold on,
xlabel('bus index'),ylabel('line flow (MVar)')
legend('AC','lDistFlow')
print(f_flow,'-dpng','line-flow-comparison.png')


scales = 1:0.1:5;
vm.ldistflow = NaN*ones(nbus,length(scales));
vm.ac = NaN*ones(nbus,length(scales));
% pf.ldistflow = NaN*ones(nbus,length(scales));
% pf.ac = NaN*ones(nbus,length(scales));
for i = 1:length(scales)
mpci = mpc;
mpci.bus(:,[PD,QD]) = mpc.bus(:,[PD,QD]) * scales(i);
option.alpha = 1/2;
result.ldistflow = distflow_lossy(mpci, option);
result.ac = runpf(mpci);
if result.ldistflow.success
    vm.ldistflow(:,i) = result.ldistflow.bus(:,VM);
end
if result.ac.success
    vm.ac(:,i) = result.ldistflow.bus(:,VM);
end
end

f_converge = figure;
% subplot(2,1,1)
plot(scales,vm.ac(10,:),'.'), hold on,
plot(scales,vm.ldistflow(10,:),'o'), hold on,
legend('AC','lDistFlow')
title('AC pf does not converge, while lDistFlow converges')
xlabel('load scaled up ratio'), ylabel('voltage magnitude at node 10 (p.u.)')
% subplot(2,1,2)
% plot(scales,vm.ac(10,:),'.'), hold on,
% plot(scales,vm.ldistflow(10,:),'o'), hold on,
% legend('AC','lDistFlow')
print(f_converge,'-dpng','convergence-comparison.png')
