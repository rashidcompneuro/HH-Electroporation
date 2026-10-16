%% DP side
%% 1st group
t1pore = t1; r1pore = zeros(length(t1),1);

if Pore1_formed(1)==0
    some_number=0;
else
    some_number=1;
end

% Add solutions1 columns
for k = 1:10
    dummy_t = solutions1{k}(:,1);
    dummy_r = solutions1{k}(:,12);
    t1pore = [t1pore; dummy_t];
    r1pore = [r1pore; dummy_r];

end
for k = 1:10
    dummy_t = solutions2{k}(:,1);
    dummy_r = solutions2{k}(:,12);
    t1pore = [t1pore; dummy_t];
    r1pore = [r1pore; dummy_r];

end

t1pore = [t1pore; t4]; r1pore = some_number*[r1pore; y4(:,11)];
%% 2nd group
t2pore = t1; r2pore = zeros(length(t1),1);

if Pore1_formed(2)==0
    some_number=0;
else
    some_number=1;
end


for k=1
    dummy_t = solutions1{k}(:,1);
    dummy_r = solutions1{k}(:,12);
    t2pore = [t2pore; dummy_t];
    r2pore = [r2pore; zeros(length(dummy_r),1)];
end 

% Add solutions1 columns
for k = 2:10
    dummy_t = solutions1{k}(:,1);
    dummy_r = solutions1{k}(:,14);
    t2pore = [t2pore; dummy_t];
    r2pore = [r2pore; dummy_r];

end
for k = 1:10
    dummy_t = solutions2{k}(:,1);
    dummy_r = solutions2{k}(:,14);
    t2pore = [t2pore; dummy_t];
    r2pore = [r2pore; dummy_r];

end

t2pore = [t2pore; t4]; r2pore = some_number*[r2pore; y4(:,13)];

%% 3rd group
t3pore = t1; r3pore = zeros(length(t1),1);

if Pore1_formed(3)==0
    some_number=0;
else
    some_number=1;
end

for k=1:2
    dummy_t = solutions1{k}(:,1);
    dummy_r = solutions1{k}(:,12);
    t3pore = [t3pore; dummy_t];
    r3pore = [r3pore; zeros(length(dummy_r),1)];
end 


% Add solutions1 columns
for k = 3:10
    dummy_t = solutions1{k}(:,1);
    dummy_r = solutions1{k}(:,16);
    t3pore = [t3pore; dummy_t];
    r3pore = [r3pore; dummy_r];

end
for k = 1:10
    dummy_t = solutions2{k}(:,1);
    dummy_r = solutions2{k}(:,16);
    t3pore = [t3pore; dummy_t];
    r3pore = [r3pore; dummy_r];

end

t3pore = [t3pore; t4]; r3pore = some_number*[r3pore; y4(:,15)];
%% 4th group
t4pore = t1; r4pore = zeros(length(t1),1);

if Pore1_formed(4)==0
    some_number=0;
else
    some_number=1;
end


for k=1:3
    dummy_t = solutions1{k}(:,1);
    dummy_r = solutions1{k}(:,12);
    t4pore = [t4pore; dummy_t];
    r4pore = [r4pore; zeros(length(dummy_r),1)];
end


% Add solutions1 columns
for k = 4:10
    dummy_t = solutions1{k}(:,1);
    dummy_r = solutions1{k}(:,18);
    t4pore = [t4pore; dummy_t];
    r4pore = [r4pore; dummy_r];

end
for k = 1:10
    dummy_t = solutions2{k}(:,1);
    dummy_r = solutions2{k}(:,18);
    t4pore = [t4pore; dummy_t];
    r4pore = [r4pore; dummy_r];

end

t4pore = [t4pore; t4]; r4pore = some_number*[r4pore; y4(:,17)];
%
%% 5th group
t5pore = t1; r5pore = zeros(length(t1),1);
if Pore1_formed(5)==0
    some_number=0;
else
    some_number=1;
end


for k=1:4
    dummy_t = solutions1{k}(:,1);
    dummy_r = solutions1{k}(:,12);
    t5pore = [t5pore; dummy_t];
    r5pore = [r5pore; zeros(length(dummy_r),1)];
end 

% Add solutions1 columns
for k = 5:10
    dummy_t = solutions1{k}(:,1);
    dummy_r = solutions1{k}(:,20);
    t5pore = [t5pore; dummy_t];
    r5pore = [r5pore; dummy_r];

end
for k = 1:10
    dummy_t = solutions2{k}(:,1);
    dummy_r = solutions2{k}(:,20);
    t5pore = [t5pore; dummy_t];
    r5pore = [r5pore; dummy_r];

end

t5pore = [t5pore; t4]; r5pore = some_number*[r5pore; y4(:,19)];
%% 6th group
t6pore = t1; r6pore = zeros(length(t1),1);

if Pore1_formed(6)==0
    some_number=0;
else
    some_number=1;
end

for k=1:5
    dummy_t = solutions1{k}(:,1);
    dummy_r = solutions1{k}(:,12);
    t6pore = [t6pore; dummy_t];
    r6pore = [r6pore; zeros(length(dummy_r),1)];
end 

% Add solutions1 columns
for k = 6:10
    dummy_t = solutions1{k}(:,1);
    dummy_r = solutions1{k}(:,22);
    t6pore = [t6pore; dummy_t];
    r6pore = [r6pore; dummy_r];

end
for k = 1:10
    dummy_t = solutions2{k}(:,1);
    dummy_r = solutions2{k}(:,22);
    t6pore = [t6pore; dummy_t];
    r6pore = [r6pore; dummy_r];

end

t6pore = [t6pore; t4]; r6pore = some_number*[r6pore; y4(:,21)];
%% 7th group
t7pore = t1; r7pore = zeros(length(t1),1);

if Pore1_formed(7)==0
    some_number=0;
else
    some_number=1;
end
for k=1:6
    dummy_t = solutions1{k}(:,1);
    dummy_r = solutions1{k}(:,12);
    t7pore = [t7pore; dummy_t];
    r7pore = [r7pore; zeros(length(dummy_r),1)];
end 

% Add solutions1 columns
for k = 7:10
    dummy_t = solutions1{k}(:,1);
    dummy_r = solutions1{k}(:,24);
    t7pore = [t7pore; dummy_t];
    r7pore = [r7pore; dummy_r];

end
for k = 1:10
    dummy_t = solutions2{k}(:,1);
    dummy_r = solutions2{k}(:,24);
    t7pore = [t7pore; dummy_t];
    r7pore = [r7pore; dummy_r];

end

t7pore = [t7pore; t4]; r7pore = some_number*[r7pore; y4(:,23)];
%% 8th group
t8pore = t1; r8pore = zeros(length(t1),1);

if Pore1_formed(8)==0
    some_number=0;
else
    some_number=1;
end

for k=1:7
    dummy_t = solutions1{k}(:,1);
    dummy_r = solutions1{k}(:,12);
    t8pore = [t8pore; dummy_t];
    r8pore = [r8pore; zeros(length(dummy_r),1)];
end 

% Add solutions1 columns
for k = 8:10
    dummy_t = solutions1{k}(:,1);
    dummy_r = solutions1{k}(:,26);
    t8pore = [t8pore; dummy_t];
    r8pore = [r8pore; dummy_r];

end
for k = 1:10
    dummy_t = solutions2{k}(:,1);
    dummy_r = solutions2{k}(:,26);
    t8pore = [t8pore; dummy_t];
    r8pore = [r8pore; dummy_r];

end

t8pore = [t8pore; t4]; r8pore = some_number*[r8pore; y4(:,25)];
%% 9th group
t9pore = t1; r9pore = zeros(length(t1),1);

if Pore1_formed(9)==0
    some_number=0;
else
    some_number=1;
end

for k=1:8
    dummy_t = solutions1{k}(:,1);
    dummy_r = solutions1{k}(:,12);
    t9pore = [t9pore; dummy_t];
    r9pore = [r9pore; zeros(length(dummy_r),1)];
end 

% Add solutions1 columns
for k = 9:10
    dummy_t = solutions1{k}(:,1);
    dummy_r = solutions1{k}(:,28);
    t9pore = [t9pore; dummy_t];
    r9pore = [r9pore; dummy_r];

end
for k = 1:10
    dummy_t = solutions2{k}(:,1);
    dummy_r = solutions2{k}(:,28);
    t9pore = [t9pore; dummy_t];
    r9pore = [r9pore; dummy_r];

end

t9pore = [t9pore; t4]; r9pore = some_number*[r9pore; y4(:,27)];
%% 10th group
t10pore = t1; r10pore = zeros(length(t1),1);
if Pore1_formed(10)==0
    some_number=0;
else
    some_number=1;
end

for k=1:9
    dummy_t = solutions1{k}(:,1);
    dummy_r = solutions1{k}(:,12);
    t10pore = [t10pore; dummy_t];
    r10pore = [r10pore; zeros(length(dummy_r),1)];
end 

% Add solutions1 columns
for k = 10
    dummy_t = solutions1{k}(:,1);
    dummy_r = solutions1{k}(:,30);
    t10pore = [t10pore; dummy_t];
    r10pore = [r10pore; dummy_r];

end
for k = 1:10
    dummy_t = solutions2{k}(:,1);
    dummy_r = solutions2{k}(:,30);
    t10pore = [t10pore; dummy_t];
    r10pore = [r10pore; dummy_r];

end

t10pore = [t10pore; t4]; r10pore = some_number*[r10pore; y4(:,29)];
%% 11th group
t11pore = t1; r11pore = zeros(length(t1),1);
if Pore1_formed(11)==0
    some_number=0;
else
    some_number=1;
end

% Add solutions1 columns
for k =1:10
    dummy_t = solutions1{k}(:,1);
    dummy_r = solutions1{k}(:,12);
    t11pore = [t11pore; dummy_t];
    r11pore = [r11pore; zeros(length(dummy_r),1)];
end

for k = 1:10
    dummy_t = solutions2{k}(:,1);
    dummy_r = solutions2{k}(:,32);
    t11pore = [t11pore; dummy_t];
    r11pore = [r11pore; dummy_r];

end

t11pore = [t11pore; t4]; r11pore = some_number*[r11pore; y4(:,31)];

%% 12th group
t12pore = t1; r12pore = zeros(length(t1),1);
if Pore1_formed(12)==0
    some_number=0;
else
    some_number=1;
end

% Add solutions1 columns
for k =1:10
    dummy_t = solutions1{k}(:,1);
    dummy_r = solutions1{k}(:,12);
    t12pore = [t12pore; dummy_t];
    r12pore = [r12pore; zeros(length(dummy_r),1)];
end

for k = 1
    dummy_t = solutions2{k}(:,1);
    dummy_r = solutions2{k}(:,12);
    t12pore = [t12pore; dummy_t];
    r12pore = [r12pore; zeros(length(dummy_r),1)];
end


for k = 2:10
    dummy_t = solutions2{k}(:,1);
    dummy_r = solutions2{k}(:,34);
    t12pore = [t12pore; dummy_t];
    r12pore = [r12pore; dummy_r];

end

t12pore = [t12pore; t4]; r12pore = some_number*[r12pore; y4(:,33)];

%% 13th group
t13pore = t1; r13pore = zeros(length(t1),1);
if Pore1_formed(13)==0
    some_number=0;
else
    some_number=1;
end

% Add solutions1 columns
for k =1:10
    dummy_t = solutions1{k}(:,1);
    dummy_r = solutions1{k}(:,12);
    t13pore = [t13pore; dummy_t];
    r13pore = [r13pore; zeros(length(dummy_r),1)];
end

for k = 1:2
    dummy_t = solutions2{k}(:,1);
    dummy_r = solutions2{k}(:,12);
    t13pore = [t13pore; dummy_t];
    r13pore = [r13pore; zeros(length(dummy_r),1)];
end


for k = 3:10
    dummy_t = solutions2{k}(:,1);
    dummy_r = solutions2{k}(:,36);
    t13pore = [t13pore; dummy_t];
    r13pore = [r13pore; dummy_r];

end

t13pore = [t13pore; t4]; r13pore = some_number*[r13pore; y4(:,35)];
%% 14th group
t14pore = t1; r14pore = zeros(length(t1),1);
if Pore1_formed(14)==0
    some_number=0;
else
    some_number=1;
end

% Add solutions1 columns
for k =1:10
    dummy_t = solutions1{k}(:,1);
    dummy_r = solutions1{k}(:,12);
    t14pore = [t14pore; dummy_t];
    r14pore = [r14pore; zeros(length(dummy_r),1)];
end

for k = 1:3
    dummy_t = solutions2{k}(:,1);
    dummy_r = solutions2{k}(:,12);
    t14pore = [t14pore; dummy_t];
    r14pore = [r14pore; zeros(length(dummy_r),1)];
end


for k = 4:10
    dummy_t = solutions2{k}(:,1);
    dummy_r = solutions2{k}(:,38);
    t14pore = [t14pore; dummy_t];
    r14pore = [r14pore; dummy_r];

end

t14pore = [t14pore; t4]; r14pore = some_number*[r14pore; y4(:,37)];

%% 15th group
t15pore = t1; r15pore = zeros(length(t1),1);
if Pore1_formed(15)==0
    some_number=0;
else
    some_number=1;
end

% Add solutions1 columns
for k =1:10
    dummy_t = solutions1{k}(:,1);
    dummy_r = solutions1{k}(:,12);
    t15pore = [t15pore; dummy_t];
    r15pore = [r15pore; zeros(length(dummy_r),1)];
end

for k = 1:4
    dummy_t = solutions2{k}(:,1);
    dummy_r = solutions2{k}(:,12);
    t15pore = [t15pore; dummy_t];
    r15pore = [r15pore; zeros(length(dummy_r),1)];
end


for k = 5:10
    dummy_t = solutions2{k}(:,1);
    dummy_r = solutions2{k}(:,40);
    t15pore = [t15pore; dummy_t];
    r15pore = [r15pore; dummy_r];

end

t15pore = [t15pore; t4]; r15pore = some_number*[r15pore; y4(:,39)];

%%
figure(5)
hold on
plot(t1pore,r1pore, LineWidth=1.5);
plot(t2pore,r2pore, LineWidth=1.5);
plot(t3pore,r3pore, LineWidth=1.5);
plot(t4pore,r4pore, LineWidth=1.5);
plot(t5pore,r5pore, LineWidth=1.5);
plot(t6pore,r6pore, LineWidth=1.5); 
plot(t7pore,r7pore, LineWidth=1.5);
plot(t8pore,r8pore, LineWidth=1.5);
plot(t9pore,r9pore, LineWidth=1.5);
plot(t10pore,r10pore, LineWidth=1.5);
plot(t11pore,r11pore, LineWidth=1.5);
plot(t12pore,r12pore, LineWidth=1.5);
plot(t13pore,r13pore, LineWidth=1.5);
plot(t14pore,r14pore, LineWidth=1.5);
plot(t15pore,r15pore, LineWidth=1.5);



% xline(5, 'k--',LineWidth=1.5);
% xline(5+tp, 'k--',LineWidth=1.5);
% xline(5+tp+time_constant, 'k--', LineWidth=1.5);
%yline(8e-10, 'k--', LineWidth=1.5);

legend('1','2','3', '4', '5','6','7','8', '9', '10','11','12','13', '14', '15')
% legend('6','7','8', '9', '10','12','13')

xlim([3e0 3e4])
%set(gca, 'YScale', 'log');  % Set x-axis to logarithmic scale
set(gca, 'XScale', 'log');  % Set x-axis to logarithmic scale
title('Pore radius evolution DP side')
%ylim([1e-11 2e-6])

