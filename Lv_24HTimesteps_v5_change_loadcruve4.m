%% 低压台区动态仿真（修正版）
clear; clc; close all;

%% 参数设置（移到循环外部）
fprintf('=== 仿真参数设置 ===\n');
modelName       = 'Lv_topo3';
simulationTime  = 360*2;
intervalTime    = 360*2;
aggIntervalTime = 180;
modelSampleTime = 5e-5;
UserNum         = 16;

% 固定基准功率和负载系数（同上，保持不变）
user_P = [1890 1680 1520 1600 1550 1260 1140 1200 1800 2000 1500 1450 1730 1630 1100 1540];
% ... fixed_k1 到 fixed_k16 保持不变
 %【改动*3*】单独分配单用户负载曲线
fixed_k1 = [0.10, 0.09, 0.09, 0.08, 0.08, 0.12, 0.25, 0.45, 0.60, 0.55, 0.48, ...
            0.44, 0.50, 0.65, 0.72, 0.60, 0.62, 0.78, 0.92, 1.00, 0.90, 0.70, 0.42, 0.22];

fixed_k2 = [0.08, 0.08, 0.08, 0.07, 0.07, 0.10, 0.18, 0.30, 0.45, 0.55, 0.60, ...
            0.65, 0.70, 0.72, 0.65, 0.55, 0.50, 0.58, 0.70, 0.82, 0.90, 0.96, 1.00, 0.85];

fixed_k3 = [0.90, 0.95, 0.85, 0.40, 0.30, 0.20, 0.18, 0.22, 0.28, 0.35, 0.42, ...
            0.50, 0.55, 0.60, 0.58, 0.50, 0.48, 0.55, 0.70, 0.80, 0.75, 0.65, 0.60, 0.95];

fixed_k4 = [0.10, 0.09, 0.09, 0.09, 0.10, 0.15, 0.28, 0.40, 0.55, 0.70, 0.90, ...
            1.00, 0.92, 0.75, 0.60, 0.48, 0.45, 0.55, 0.70, 0.82, 0.76, 0.55, 0.32, 0.18];

fixed_k5 = [0.06, 0.06, 0.06, 0.06, 0.08, 0.20, 0.40, 0.60, 0.80, 0.90, 0.95, ...
            1.00, 0.98, 0.96, 0.92, 0.88, 0.85, 0.80, 0.60, 0.30, 0.15, 0.10, 0.08, 0.06];

fixed_k6 = [0.06, 0.06, 0.06, 0.06, 0.08, 0.15, 0.25, 0.35, 0.55, 0.70, 0.85, ...
            0.95, 0.70, 0.50, 0.55, 0.70, 0.85, 1.00, 0.95, 0.80, 0.55, 0.30, 0.18, 0.10];

fixed_k7 = [0.08, 0.08, 0.08, 0.08, 0.10, 0.30, 0.55, 0.80, 0.95, 1.00, 0.95, ...
            0.90, 0.88, 0.85, 0.80, 0.70, 0.50, 0.30, 0.15, 0.12, 0.10, 0.09, 0.08, 0.08];

fixed_k8 = [0.10, 0.10, 0.10, 0.10, 0.12, 0.18, 0.25, 0.35, 0.45, 0.50, 0.55, ...
            0.60, 0.65, 0.70, 0.80, 0.85, 0.90, 0.95, 1.00, 0.95, 0.85, 0.75, 0.60, 0.40];

fixed_k9 = [0.10, 0.10, 0.10, 0.12, 0.25, 0.50, 0.70, 0.85, 0.90, 0.95, 0.95, ...
            0.95, 0.95, 0.95, 0.92, 0.90, 0.85, 0.80, 0.70, 0.50, 0.30, 0.20, 0.15, 0.12];

fixed_k10 = [0.25, 0.22, 0.20, 0.18, 0.20, 0.30, 0.55, 0.75, 0.80, 0.70, 0.50, ...
             0.35, 0.30, 0.32, 0.45, 0.65, 0.80, 0.90, 0.95, 0.90, 0.70, 0.50, 0.35, 0.28];

fixed_k11 = [0.10, 0.10, 0.10, 0.10, 0.12, 0.18, 0.28, 0.40, 0.55, 0.65, 0.75, ...
             0.85, 0.92, 1.00, 0.98, 0.90, 0.75, 0.60, 0.50, 0.45, 0.40, 0.35, 0.28, 0.20];

fixed_k12 = [0.08, 0.08, 0.08, 0.08, 0.10, 0.35, 0.70, 0.90, 0.70, 0.50, 0.40, ...
             0.35, 0.38, 0.45, 0.55, 0.70, 0.80, 0.85, 0.80, 0.65, 0.50, 0.35, 0.20, 0.12];

fixed_k13 = [0.10, 0.10, 0.10, 0.10, 0.12, 0.20, 0.35, 0.55, 0.80, 0.95, 1.00, ...
             0.92, 0.80, 0.65, 0.55, 0.50, 0.55, 0.65, 0.70, 0.65, 0.55, 0.40, 0.25, 0.15];

fixed_k14 = [0.20, 0.25, 0.35, 0.60, 0.85, 1.00, 0.90, 0.70, 0.50, 0.40, 0.35, ...
             0.30, 0.28, 0.30, 0.35, 0.45, 0.55, 0.65, 0.70, 0.60, 0.45, 0.30, 0.22, 0.20];

fixed_k15 = [0.08, 0.08, 0.08, 0.08, 0.10, 0.15, 0.20, 0.28, 0.40, 0.55, 0.60, ...
             0.62, 0.65, 0.70, 0.75, 0.85, 0.95, 1.00, 0.95, 0.85, 0.70, 0.55, 0.40, 0.25];

fixed_k16 = [0.10, 0.10, 0.30, 0.60, 0.80, 0.50, 0.30, 0.25, 0.30, 0.40, 0.55, ...
             0.70, 0.80, 0.85, 0.75, 0.60, 0.55, 0.60, 0.70, 0.80, 0.70, 0.50, 0.30, 0.15];


fixed_kk = cat(3, fixed_k1(:), fixed_k2(:), fixed_k3(:), fixed_k4(:), ...
    fixed_k5(:), fixed_k6(:), fixed_k7(:), fixed_k8(:), ...
    fixed_k9(:), fixed_k10(:), fixed_k11(:), fixed_k12(:), ...
    fixed_k13(:), fixed_k14(:), fixed_k15(:), fixed_k16(:));

%% 模型加载（只需一次）
if ~exist([modelName '.slx'],'file')
    error('模型文件 %s.slx 未找到！',modelName);
end
load_system(modelName);
set_param(modelName,'FixedStep',num2str(modelSampleTime));
set_param(modelName,'Solver','ode4');

%% 24小时主循环
for ii = 1:24
    fprintf('\n=== 开始第 %02d 小时仿真 ===\n', ii);
    
    %% 当前小时负载计算
    turns = ii;
    current_P = user_P.' .* squeeze(fixed_kk(ii,1,:));
    current_Q = current_P * 0.9;
    
    %% 分时段仿真
    simInput = Simulink.SimulationInput(modelName);
    simInput = simInput.setModelParameter('StopTime','0');
    finalState = [];
    
    % 存储所有步的Uroot数据
    allUrootTime = [];
    allUrootData = [];
    
    for fd = 1:4
        fprintf('正在进行第 %02d/4 步\n', fd);
        
        % 设置负载（带随机扰动）
        for userIdx = 1:UserNum
            c_P = current_P(userIdx) * (1 + (rand * 2 - 1) * 0.08);
            c_Q = c_P * 0.95;
            loadBlock = [modelName '/User' num2str(userIdx) '/U' num2str(userIdx)];
            set_param(loadBlock,'ActivePower',num2str(c_P));
            set_param(loadBlock,'InductivePower',num2str(c_Q));
        end
        
        % 设置仿真时间
        stopTime = (intervalTime/4) * fd;
        simInput = simInput.setModelParameter('StopTime',num2str(stopTime));
        
        if ~isempty(finalState)
            simInput = simInput.setInitialState(finalState);
        end
        
        % 执行仿真
        simOut = sim(simInput);
        
        % 保存最终状态
        if isprop(simOut,'xFinal') && ~isempty(simOut.get('xFinal'))
            finalState = simOut.get('xFinal');
        end
        
        % 保存Uroot数据
        allUrootTime = [allUrootTime; simOut.Uroot.Time(:)];
        allUrootData = [allUrootData; simOut.Uroot.Data];
        
        % 保存步数据到临时文件
        nNew = min(length(simOut.tout), size(simOut.U.Data,1));
        stepData = struct();
        stepData.Time = simOut.tout(1:nNew);
        stepData.U    = simOut.U.Data(1:nNew,:);
        stepData.I    = simOut.I.Data(1:nNew,:);
        stepData.P    = simOut.P.Data(1:nNew,:);
        stepData.Q    = simOut.Q.Data(1:nNew,:);
        
        tempFile = sprintf('temp_hour_%02d_step_%02d.mat', ii, fd);
        save(tempFile, '-struct', 'stepData');
        fprintf('步数据已保存到 %s\n', tempFile);
    end
    
    %% 汇总所有步数据
    fprintf('\n=== 汇总第 %02d 小时数据 ===\n', ii);
    results = struct('Time', [], 'U', [], 'I', [], 'P', [], 'Q', []);
    
    for fd = 1:4
        tempFile = sprintf('temp_hour_%02d_step_%02d.mat', ii, fd);
        if exist(tempFile, 'file')
            part = load(tempFile);
            results.Time = [results.Time; part.Time];
            results.U    = [results.U; part.U];
            results.I    = [results.I; part.I];
            results.P    = [results.P; part.P];
            results.Q    = [results.Q; part.Q];
            delete(tempFile); % 清理临时文件
            fprintf('已加载并删除 %s\n', tempFile);
        else
            warning('文件 %s 缺失！', tempFile);
        end
    end
    
    %% 数据聚合（修正版）
    fprintf('\n=== 数据聚合 ===\n');
    aggInterval = aggIntervalTime;
    timeEdges = 0:aggInterval:simulationTime;
    numIntervals = length(timeEdges) - 1;
    
    aggData = struct('Time', zeros(numIntervals,1),...
        'U', zeros(numIntervals,UserNum),...
        'I', zeros(numIntervals,UserNum),...
        'P', zeros(numIntervals,UserNum),...
        'Q', zeros(numIntervals,UserNum));
    
    for intervalIdx = 1:numIntervals
        tStart = timeEdges(intervalIdx);
        tEnd   = timeEdges(intervalIdx+1);
        aggData.Time(intervalIdx) = tStart;
        
        % 修正：安全的mask处理
        mask = (results.Time >= tStart) & (results.Time < tEnd);
        validIndices = find(mask);
        if length(validIndices) > length(results.Time)
            validIndices = validIndices(1:length(results.Time));
        end
        
        for userIdx = 1:UserNum
            if ~isempty(validIndices)
                aggData.U(intervalIdx,userIdx) = rms(results.U(validIndices,userIdx));
                aggData.I(intervalIdx,userIdx) = rms(results.I(validIndices,userIdx));
                aggData.P(intervalIdx,userIdx) = mean(results.P(validIndices,userIdx));
                aggData.Q(intervalIdx,userIdx) = mean(results.Q(validIndices,userIdx));
            else
                aggData.U(intervalIdx,userIdx) = NaN;
                aggData.I(intervalIdx,userIdx) = NaN;
                aggData.P(intervalIdx,userIdx) = NaN;
                aggData.Q(intervalIdx,userIdx) = NaN;
            end
        end
    end
    
    %% Uroot数据聚合（修正版）
    rootAgg = struct('Time', zeros(numIntervals,1), 'U', zeros(numIntervals,6));
    
    for k = 1:numIntervals
        tStart = timeEdges(k);
        tEnd   = timeEdges(k+1);
        rootAgg.Time(k) = tStart;
        
        mask = (allUrootTime >= tStart) & (allUrootTime < tEnd);
        if any(mask)
            rootAgg.U(k,:) = rms(allUrootData(mask,:), 1);
        else
            rootAgg.U(k,:) = NaN(1,6);
        end
    end
    
    %% 结果保存
    fprintf('\n=== 保存结果 ===\n');
    timeLabels = arrayfun(@(t) sprintf('%02d:%02d', floor(t/60), mod(t,60)), aggData.Time, 'UniformOutput', false);
    
    header = {'Timestamp', 'User1', 'User2', 'User3', 'User4', 'User5', ...
              'User6', 'User7', 'User8', 'User9','User10', 'User11', 'User12', 'User13', 'User14', ...
              'User15', 'User16'};
    
    % 保存各文件
    vFile = sprintf('Voltage_%03d.csv', ii);
    cFile = sprintf('Current_%03d.csv', ii);
    pFile = sprintf('ActivePower_%03d.csv', ii);
    qFile = sprintf('ReactivePower_%03d.csv', ii);
    rootFile = sprintf('RootVoltage_%03d.csv', ii);
    
    writetable(array2table([timeLabels, num2cell(aggData.U)], 'VariableNames', header), vFile);
    writetable(array2table([timeLabels, num2cell(aggData.I)], 'VariableNames', header), cFile);
    writetable(array2table([timeLabels, num2cell(aggData.P)], 'VariableNames', header), pFile);
    writetable(array2table([timeLabels, num2cell(aggData.Q)], 'VariableNames', header), qFile);
    
    rootHeader = {'Timestamp','PhaseA1','PhaseB1','PhaseC1','PhaseA2','PhaseB2','PhaseC2'};
    rootTable = array2table([timeLabels, num2cell(rootAgg.U)], 'VariableNames', rootHeader);
    writetable(rootTable, rootFile);
    
    fprintf('第 %02d 小时仿真完成！结果已保存\n', ii);
    
    % 重要：不要清空所有变量！
    clear results aggData rootAgg stepData part simOut;
end

%% 最终清理
set_param(modelName, 'SaveState', 'off');
close_system(modelName, 0);
fprintf('\n=== 所有24小时仿真完成！ ===\n');