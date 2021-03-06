% %% Train SVM-Regressors
% mdl_x_svm = svm_train(trainingset_normalized, pos_train(:,1), '-s 4 -t 2 -c 100 -n 0.5');
% mdl_y_svm = svm_train(trainingset_normalized, pos_train(:,2), '-s 4 -t 2 -c 100 -n 0.5');
% 
% save(['svm_model_', num2str(cnt)], 'mdl_x_svm', 'mdl_y_svm');
% %% Train Linear Regressor
% mdl_x_lr = fitlm(trainingset_normalized, pos_train(:,1), 'linear');
% mdl_y_lr = fitlm(trainingset_normalized, pos_train(:,2), 'linear');
% save(['lr_model', num2str(cnt)], 'mdl_x_lr', 'mdl_y_lr');
%% Train Neural Network
inputs = trainingset_normalized';
targets = pos_train';
 
% Create a Fitting Network
hiddenLayerSize = [20, 10, 5, 4, 3];
net = fitnet(hiddenLayerSize);

% Set up Division of Data for Training, Validation, Testing
net.divideFcn = 'dividerand';
net.divideParam.trainRatio = 70/100;
net.divideParam.valRatio = 15/100;
net.divideParam.testRatio = 15/100;

net.trainFcn = 'trainbr';
net.trainParam.epochs = 200000;
net.trainParam.showCommandLine = 1;
net.trainParam.max_fail = 0;
net.trainParam.goal = 0.15; 
net.trainParam.show	= 1;

net.trainParam.mu_max = 1*10^40;
net.trainParam.min_grad = 1*10^-6;

net.performFcn='msereg';

% Train the Network
[net,tr] = train(net,inputs,targets,'useParallel','yes','showResources','yes');
% Test the Network
% outputs = net(testingset_normalized');
% [r,m,b] = regression(pos_testing',testingset_normalized')
% plotregression(pos_testing',testingset_normalized')
% performance = perform(net,testingset_normalized',outputs)
 
% View the Network
% view(net)
save(['netNN_model', num2str(cnt)], 'net');
% %% Train a RNN
% netRNN = layrecnet(1:3,hiddenLayerSize);
% % Set up Division of Data for Training, Validation, Testing
% netRNN.divideFcn = 'dividerand';
% netRNN.divideParam.trainRatio = 70/100;
% netRNN.divideParam.valRatio = 15/100;
% netRNN.divideParam.testRatio = 15/100;
% 
% netRNN.trainFcn = 'trainbr';
% netRNN.trainParam.epochs = 200000;
% netRNN.trainParam.showCommandLine = 1;
% netRNN.trainParam.max_fail = 0;
% netRNN.trainParam.goal = 0.15; 
% netRNN.trainParam.show	= 1;
% 
% netRNN.trainParam.mu_max = 1*10^40;
% netRNN.trainParam.min_grad = 1*10^-6;
% 
% netRNN.performFcn='msereg';
% % net.divideParam.trainRatio = 75/100;
% % net.divideParam.valRatio = 20/100;
% % net.divideParam.testRatio = 5/100;
% % net.trainParam.epochs = 2000;
% % netRNN.trainFcn = 'trainbr';
% % netRNN.trainParam.showCommandLine = 1;
% % netRNN.performFcn='msereg';
% [Xs,Xi,Ai,Ts] = preparets(netRNN, con2seq(inputs), con2seq(targets));
% netRNN = train(netRNN,Xs,Ts,Xi,Ai,'useParallel', 'yes', 'showResources', 'yes'); 
% % 
% save(['netRNN_model', num2str(cnt)], 'netRNN');