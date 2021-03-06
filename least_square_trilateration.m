%% Least-squares Sense Localization
close all;
e_vec = [];
e_vec_ind = [];
fig =1;
for i=1:25
    for j=2:7
        figHandle = figure(666);
                                                    
        test_point = [i,j];
        pl_vector = pl(test_point(1), test_point(2), :);
        pl_vector = pl_vector(:);
        d_hat = ldpl(dist, pl_vector, pl_at_center, path_loss_exp, std_measurement);
        d_hat_ind = ldpl(dist, pl_vector, pl_at_center, path_loss_exp_ind, std_measurement);
        % Add the radial distances into the figure
        [max_d, ind] = max(d_hat');
        [max_d_ind, ind_ind] = max(d_hat_ind');
        for k=1:8        
            [x,y] = circle(pos_node_m(k,1), pos_node_m(k,2), d_hat(k,ind(k)), 0:0.001:2*pi);
            plot(y,x); hold on; 
%             xlim([0,8.1]);
%             ylim([0,22.5]);
            view([0, -90]);
        end
        % first anchor node is linearization pivot
        A = [pos_node_m(2:8,1) - pos_node_m(1,1), pos_node_m(2:8,2) - pos_node_m(1,2)];  
        d_sq = d_hat(2:8,:).^2;
        d_sq_ind = d_hat_ind(2:8,:).^2;
        distance_between_an = pdist2(pos_node_m(2:8,:), pos_node_m(1,:)).^2;
%         b = ((d_hat(1)^2 - d_sq + distance_between_an')/2)';
        b = bsxfun(@plus, bsxfun(@minus, d_sq, d_hat(1)^2), distance_between_an)/2;
%         b_ind = ((max_d_ind(1)^2 - d_sq_ind + distance_between_an')/2)';
        b_ind = bsxfun(@plus, bsxfun(@minus, d_sq_ind, d_hat_ind(1)^2), distance_between_an)/2;
        x = (inv(A'*A)*A'*b)';
        x_ind = (inv(A'*A)*A'*b_ind)';
        % Add the ground truth point into the figure
        plot(gcy(j), gcx(i), 'bd', x(:, 2), x(:,1), 'r*', x_ind(:,2), x_ind(:,1), 'r+');
        % Add anchor nodes into the figure
        plot(pos_node_m(:,2), pos_node_m(:,1), 'ro', 'MarkerSize', 8, 'MarkerFaceColor', 'r'); 
        % Add anchor node labels into the figure
        for qq=1:8
            txt = ['   Node ', num2str(qq-1), '     '];
            if (qq<5)
                text(pos_node_m(qq,2),pos_node_m(qq,1),txt, 'HorizontalAlignment','right', 'rotation', 45);
            else
                text(pos_node_m(qq,2),pos_node_m(qq,1),txt, 'HorizontalAlignment','left', 'rotation', 315);
            end
        end
        grid on;
        xlabel('Y');
        ylabel('X');
        ax = gca;
        ax.XAxisLocation = 'top';
        ax.XTick = 0:0.9:8.1;
        ax.YTick = 0:0.9:22.5;
        ax.XTickLabel = {'0','1','2','3','4','5','6','7'};
        ax.YTickLabel = {'0','1','2','3','4','5','6','7','8','9', ...
                        '10','11','12','13','14','15','16','17','18','19', ...
                        '20','21','22','23','24','25'};
        hold off; 
        legend('node 0','node 1','node 2','node 3','node 4','node 5','node 6','node 7', 'x_{gt}', 'x_{joint}', 'x_{ind}');
        view([0, -90]);
        pbaspect([8 25 1]);
        if(save_figures)
            drawnow;
        end
%         test_point = [gcy(j), gcx(i)];
%         e = test_point - x;
%         e_ind = test_point - x_ind;
%         e = sqrt(e(:,1).^2+ e(:,2).^2);
%         e_ind = sqrt(e_ind(:,1).^2+ e_ind(:,2).^2);
%         e_vec = [e_vec, e];
%         e_vec_ind = [e_vec_ind, e_ind];
        if(save_figures)                          
            saveas(figHandle, ['outputest/output_est_', num2str(fig), '.png'],'png');
        end
%         close(666);
        fig = fig+1;
    end
end
% disp('Mean localization error (w/ Joint Path Loss Estimation):');
% disp(mean(e_vec, 'omitnan'));
% disp('Mean localization error (w/ Individual Path Loss Estimation):');
% disp(mean(e_vec_ind, 'omitnan'));
