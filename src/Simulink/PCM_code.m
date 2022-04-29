close all
clc

%% Test Signal

test_frequencies = [1300, 2400, 3200, 5600, 6300];


%% Run Simulation with Parameters

rTime = '1'; % Run Time
maxStep = '1e-5'; % Maximum step size

mdl = 'PCM_System';
load_system(mdl);
cs = getActiveConfigSet(mdl);
mdl_cs = cs.copy;

set_param(mdl_cs,'StopTime', rTime, 'MaxStep', maxStep)

simulation = sim(mdl, mdl_cs);