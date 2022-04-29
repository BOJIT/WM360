close all
clc

%% Test Signal

test_frequencies = [1300, 2400, 5100, 5600, 6300];


%% Run Simulation with Parameters

rTime = '0.1'; % Run Time
maxStep = '1e-5'; % Maximum step size

mdl = 'PCM_System';
load_system(mdl);
cs = getActiveConfigSet(mdl);
mdl_cs = cs.copy;

set_param(mdl_cs,'StopTime', rTime, 'MaxStep', maxStep)

simulation = sim(mdl, mdl_cs);