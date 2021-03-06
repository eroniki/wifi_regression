%% Visualization 
p = [pos_node, repmat(-20, [8,1])];
%% 3-D
[xx, yy] = meshgrid(1:25,1:8);
figure;
for i=1:8
    subplot(4,2,i); surf(xx,yy, reshape(propagation_maps(:,:,i), [25,8])'); hold on;
    title(['WiFi Anchor Node:', num2str(i-1)]);
    stem3(p(:,2), p(:,1), p(:,3), 'filled', 'color', 'red');
end
%
figure;
for i=1:8
    subplot(4,2,i); surf(xx,yy, reshape(propagation_maps(:,:,i+8), [25,8])'); hold on;
    title(['BT Anchor Node:', num2str(i-1)]);
    stem3(p(:,2), p(:,1), p(:,3));
end

figure;
for i=1:8
    subplot(4,2,i); surf(xx,yy, reshape(propagation_maps(:,:,i+16), [25,8])'); hold on;
    title(['LoRa Anchor Node:', num2str(i-1)]);
    stem3(p(:,2), p(:,1), p(:,3), 'filled', 'color', 'red');
end
%% 2-D
for i=1:8
    figure; 
    plot(pos_node(i,2), pos_node(i,1), 'r*'); grid on;
    title(['Anchor Node ', num2str(i-1), ' WiFi Propagation Map']);
    hold on;
    imagesc(reshape(propagation_maps(:,:,i), [25,8]));   
    colorbar;
    hold off;
    view([0, -90]);
end

for i=9:16
    figure; 
    plot(pos_node(i-8,1), pos_node(i-8,2), 'r*'); grid on;
    title(['Anchor Node ', num2str(mod(i-1, 8)), ' BT Propagation Map']);
    hold on;
    imagesc(reshape(propagation_maps(:,:,i), [25,8]));
    colorbar;
    hold off;
    view([0, -90]);
end

for i=17:24
    figure;
    plot(pos_node(i-16,1), pos_node(i-16,2), 'r*'); grid on;
    title(['Anchor Node ', num2str(mod(i-1, 8)), ' LoRa Propagation Map']);
    hold on;
    imagesc(reshape(propagation_maps(:,:,i), [25,8]));
    colorbar;
    hold off;
    view([0, -90]);
end
%% Visualize the error metrics
% Plot Path Loss
for i=1:8
    figure;
    plot(pos_node(i,1), pos_node(i,2), 'r*'); grid on;
    title(['Anchor Node ', num2str(i-1), ' LoRa Path Loss Map']);
    hold on;
    imagesc(reshape(pl(:,:,i), [25,7]));
    colorbar;
    hold off;
    view([0, -90]);
end
% Plot the error map
for i=1:8
    figure;
    plot(pos_node(i,1), pos_node(i,2), 'r*'); grid on;
    title(['Anchor Node ', num2str(i-1), ' LoRa Error Map (w/ Joint PLE)']);
    hold on;
    imagesc(reshape(error_map(:,:,i), [25,7]));
    colorbar;
    hold off;
    view([0, -90]);
end
% Plot the error map
for i=1:8
    figure;
    plot(pos_node(i,1), pos_node(i,2), 'r*'); grid on;
    title(['Anchor Node ', num2str(i-1), ' LoRa Error Map (w/ Ind. PLE)']);
    hold on;
    imagesc(reshape(error_map_ind(:,:,i), [25,7]));
    colorbar;
    hold off;
    view([0, -90]);
end
% Plot CDF and histogram of error
[cdf, counts, bins] = localization_cdf(e_vec(:), 50);
[cdf_ind, counts_ind, bins_ind] = localization_cdf(e_vec_ind(:), 50);
figure; plot(bins, cdf, 'r', bins_ind, cdf_ind, 'b'); grid on; grid minor; 
figure; bar(bins, counts); grid on;


%% Save Figures
if save_figures
    n = get(gcf,'Number');

    for i=1:n
        saveas(i, ['output/output_', num2str(i), '.png'],'png');
    end
end
