%%%% Code for exploring the ideas in the Kamitani & Tong paper
%%%% by Rajeev Raizada, Oct.2008
%%%%
%%%% Please mail any comments or suggestions to: raizada at cornell dot edu
%%%%
%%%% Probably the best way to look at this program is to read through it
%%%% line by line, and paste each line into the Matlab command window
%%%% in turn. That way, you can see what effect each individual command has.
%%%%
%%%% Alternatively, you can run the program directly by typing 
%%%%
%%%%   explore_kamitani_tong_pattern_based_fMRI
%%%%
%%%% into your Matlab command window. 
%%%% Do not type ".m" at the end
%%%% If you run the program all at once, all the Figure windows
%%%% will get made at once and will be sitting on top of each other.
%%%% You can move them around to see the ones that are hidden beneath.

%%% Links to the relevant papers:
%%% The Kamitani & Tong paper:
% http://www.psy.vanderbilt.edu/tonglab/publications/Kamitani&Tong_NN2005.pdf
%%% Geoff Boynton's commentary, which has the figure
%%% which this code is based on:
% http://faculty.washington.edu/gboynton/publications/boynton-natureneuro05.pdf
%%% Rojer & Schwartz's paper, which showed how to make
%%% patterns which look like V1 by filtering noise:
% http://eslab.bu.edu/publications/articles/1990/rojer1990cat.pdf

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% First of all, we want to make a grid of random orientations.
% Then, we're going to blur those orientations
% by averaging neighbouring orientations together.
% This will make a pattern which looks very much like a real
% V1 orientation map.
%
% However, averaging together orientations is not quite as straightforward
% as just averaging together a bunch of scalar numbers,
% because orientations loop back on themselves.
% (A scalar is a number which has just one dimension.
%  A vector has two or more dimensions, so it has a direction
%  as well as magnitude).
% The average of a 1-degree orientation and a 179 degree-orientation
% is *not* equal to (1+179)/2 = 90 degrees.
% Both 1deg and 179deg are very close to horizontal,
% and the average of them is exactly horizontal, namely 0 degrees.
% So, we have to treat the orientations as vectors
% when we average them together, not just as scalar numbers.


% First, let's make a grid of random orientation angles 
% between 0 and 2*pi ( that's 360 degrees, in radians).

% We'll call the orientations "theta",
% as people usually use that greek letter for orientation
grid_size = 300;
theta = 2*pi*rand(grid_size);

% Turn these angles into vectors with x and y coords
theta_x = cos(theta);
theta_y = sin(theta);

% Make a Gaussian, for blurring the angles together
% Matlab has a useful built-in function for making 2D grids: "meshgrid"
gaussian_grid_step_size = 0.1;
% A Gaussian is pretty much zero by the time
% it gets to 5 standard deviations from the mean
[x_grid,y_grid] = meshgrid( -5 : gaussian_grid_step_size : 5 );

gaussian = exp( -( x_grid.^2 + y_grid.^2 ) );

% Locally average the vector coords with a Gaussian blur
% The 'valid' part at the end tells Matlab to throw away
% the parts of the output where the Gaussian is hanging off an edge
blurred_theta_x = conv2(theta_x,gaussian,'valid'); 
blurred_theta_y = conv2(theta_y,gaussian,'valid');

% Turn these vectors back into angles
tan_of_blurred_theta = blurred_theta_y./(blurred_theta_x); % tan = sin/cos
blurred_theta = atan( tan_of_blurred_theta );

% Let's plot these orientation fields, with the axis scaled
% to be in units of pi
blurred_theta_pi_units = blurred_theta / pi;
theta_pi_units = theta / pi;

figure(1);
clf;
imagesc(theta_pi_units);
colormap hsv; % hsv is a colormap where the max and min are both red
colorbar;
caxis([-0.5 0.5]);
title('Random orientations, before blurring','FontSize',14);

figure(2);
clf;
imagesc(blurred_theta_pi_units);
colormap hsv; 
colorbar;
caxis([-0.5 0.5])
title('Random orientations, after blurring','FontSize',14);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Now we're going to slice the space up into voxels,
%%%% and see what's in each voxel
    
%%% Slice the space up into voxels, and histogram each of these
num_voxels_per_dim = 4;
voxel_size = size(blurred_theta,1) / num_voxels_per_dim;

voxel_contents = zeros(num_voxels_per_dim,num_voxels_per_dim,voxel_size^2);

for x = 1:num_voxels_per_dim,
    for y = 1:num_voxels_per_dim,
        
        this_voxel = blurred_theta( (x-1)*voxel_size + [1:voxel_size], ...
                                    (y-1)*voxel_size + [1:voxel_size] );
        voxel_contents(x,y,:) = this_voxel(:);
    end;
end;

%%%% Put thick black lines showing the voxels on Fig 2
figure(2);
hold on;
for x = 1:(num_voxels_per_dim-1),
    for y = 1:(num_voxels_per_dim-1),
        
        plot(x*voxel_size*[1 1],[0 num_voxels_per_dim*voxel_size],'k-','LineWidth',3);
        plot([0 num_voxels_per_dim*voxel_size],y*voxel_size*[1 1],'k-','LineWidth',3);

    end;
end;

%%% Plot these histograms with the right colors
%%% We'll histogram the voxels into 8 bins
num_orientation_bins = 8;
bin_floors = (pi * [0:(num_orientation_bins-1)]/num_orientation_bins) - pi/2;
bin_ceilings = bin_floors + pi/num_orientation_bins;
bin_centers = (bin_floors + bin_ceilings) / 2;

%%% We'll set the activation of each voxel for each orientation
%%% to be the number of pixels in each orientation-bin in each voxel
%%% First, initialise this to be all zeros
voxel_activations = zeros(num_voxels_per_dim,num_voxels_per_dim,num_orientation_bins);

figure(3);
clf;
colormap hsv;
for x = 1:num_voxels_per_dim,
    for y = 1:num_voxels_per_dim,
        
        subplot(num_voxels_per_dim,num_voxels_per_dim,(x-1)*num_voxels_per_dim+y);
    
        freq = hist(squeeze(voxel_contents(x,y,:)),bin_centers);
        %%% We'll set the activation of each voxel for each orientation
        %%% to be the number of pixels in each orientation-bin in each voxel
        voxel_activations(x,y,:) = freq;

        bar_h = bar(bin_centers,freq);
        
        %%% Set the bar colours using a trick from here:
        %%% http://www.mathworks.com/support/solutions/data/1-1T6UHS.html
        bar_children = get(bar_h,'Children');
        set(bar_children,'CData',bin_centers);
        title([ num2str(x) ',' num2str(y) ]);
        caxis([-pi/2 pi/2]);
        axis('off');
        
    end;
end;

%%%% Set the y-scaling on the histograms to go up to the maximum activation
max_activation = max(voxel_activations(:));
figure(3);
for x = 1:num_voxels_per_dim,
    for y = 1:num_voxels_per_dim,
        subplot(num_voxels_per_dim,num_voxels_per_dim,(x-1)*num_voxels_per_dim+y);
        axis([-pi/2 pi/2 0 max_activation]);
    end;
end;
subplot(4,4,13),
text_handle = text(-2.5,-0.3*max_activation, ...
   'The amount of cortex tuned to each orientation, in each voxel');
set(text_handle,'FontSize',14);

%%%%% Let's draw the orientations corresponding to each histogram bin
figure(4);
clf;
hold on;
hsv_color_mat = colormap(hsv); %%% Colormap matrices have 64 rows
for this_bin = 1:num_orientation_bins,
    this_orientation = bin_centers(this_bin);
    hsv_mat_row = round( 64 * (this_orientation/pi + 0.5) );
    plot(cos(this_orientation)*[-1 1],sin(this_orientation)*[-1 1], ...
        'Color',hsv_color_mat(hsv_mat_row,:),'LineWidth',5);
end;
axis('off');
axis('equal');
title('Which colour stands for which orientation','FontSize',18);
   
%%% Now let's present one orientation at a time,
%%% and look at the activation across the voxels.
%%% We'll show the orientation for each bin

figure(5);
clf;
hsv_with_black_first_row = hsv_color_mat;
hsv_with_black_first_row(1,:) = [ 0 0 0 ];
colormap( hsv_with_black_first_row );  %%% Make the 1st row black

for this_bin = 1:num_orientation_bins,
    
    orientation_floor = bin_floors(this_bin);
    orientation_ceiling = bin_ceilings(this_bin);
    
    activated_pixels =  ( blurred_theta >= orientation_floor ) .* ...
                        ( blurred_theta < orientation_ceiling );

    subplot(3,3,this_bin),
        hsv_mat_row = round( 64 * (bin_centers(this_bin)/pi + 0.5) );
        image( hsv_mat_row * activated_pixels);
    axis('equal');
    axis('off');
    %%%% Put thick black lines showing the voxels onto each subplot
    hold on;
    for x = 1:(num_voxels_per_dim-1),
        for y = 1:(num_voxels_per_dim-1),

            plot(x*voxel_size*[1 1],[0 num_voxels_per_dim*voxel_size],'w-','LineWidth',1);
            plot([0 num_voxels_per_dim*voxel_size],y*voxel_size*[1 1],'w-','LineWidth',1);

        end;
    end;
end;
subplot(3,3,2),
title('The parts of cortex tuned to each orientation','FontSize',14);

%%%%% Let's show the patterns of voxel activation for each orientation
%%%%% which we calculated above
figure(6);
clf;
colormap gray;
for this_bin = 1:num_orientation_bins, 
    subplot(3,3,this_bin),
    imagesc(voxel_activations(:,:,this_bin));
    caxis([0 max_activation]);
    axis('equal');
    axis('off');
end;
subplot(3,3,2),
title('Spatial patterns of voxel activation for each orientation','FontSize',14); 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% Now let's do some basic classification of those spatial patterns,
%%%%% just using correlation.

% Suppose we are given a pattern of voxel fMRI activation.
% Can we figure out which orientation gave rise to it?
% We can do this by calculating the correlation of that pattern
% with each of our original measured activation patterns,
% and see which one it matches best with.

% First, we'll turn each activation-pattern-grid into a vector
activation_vectors = zeros(num_voxels_per_dim^2, num_orientation_bins);

for this_bin = 1:num_orientation_bins,
    this_activation_grid = voxel_activations(:,:,this_bin);
    %%% Putting (:) after a matrix stacks it up into a single vector
    activation_vectors(:,this_bin) = this_activation_grid(:);
end;

%%%% Let's look at the correlation matrix of these vectors
figure(7);
clf;
colormap gray;
imagesc( corr(activation_vectors) );
colorbar;
set(gca,'FontSize',14);
xlabel('Orientation number');
ylabel('Orientation number');
title('Correlations of each orientation''s fMRI-pattern with the others'); 

%%%%% Each pattern is perfectly correlated with itself, of course.
%%%%% Without any noise, we will get perfect classification.
%%%%% But fMRI has lots of noise in it.
%%%%% So, let's add in some noise, and see how the correlations end up.

noise_factor = 0.5;
vec_length = num_voxels_per_dim^2;
noisy_vectors = zeros(vec_length,num_orientation_bins);

for this_bin = 1:num_orientation_bins,
    noise_multiplier = 1 + noise_factor*randn(vec_length,1);
    this_vector = activation_vectors(:,this_bin);
    this_noisy_voxel_vec = this_vector .* noise_multiplier;
    noisy_vectors(:,this_bin) = this_noisy_voxel_vec;
end;

%%%% Let's look at the correlation matrix of the noisy vectors
%%%% with the original activation vectors
figure(8);
clf;
colormap gray;
noisy_corrs = corr(activation_vectors,noisy_vectors);
imagesc( noisy_corrs );
colorbar;
set(gca,'FontSize',14);
xlabel('Orientation number');
ylabel('Orientation number');
title('Correlations of the noisy activation vectors with the originals'); 

%%%% For each noisy vector, figure out which original
%%%% orientation-activation-vector it has the highest correlation with
best_matching_orientations = zeros(1,num_orientation_bins);

for this_bin = 1:num_orientation_bins,
    corrs_of_this_noisy_vector = noisy_corrs(:,this_bin);
    [ max_corr, best_match_ind  ] = max( corrs_of_this_noisy_vector );
    best_matching_orientations( this_bin ) = best_match_ind;
end;

%%%% Now let's do this 100 times, and see how often the best match 
%%%% is correct, for our particualr noise-factor
noise_factor = 1;
num_reps = 100;
best_matches_rec = zeros(num_reps,num_orientation_bins);
for rep_num = 1:num_reps,
    for this_bin = 1:num_orientation_bins,
        noise_multiplier = 1 + noise_factor*randn(vec_length,1);
        this_vector = activation_vectors(:,this_bin);
        this_noisy_voxel_vec = this_vector .* noise_multiplier;
        noisy_vectors(:,this_bin) = this_noisy_voxel_vec;
    end;
    noisy_corrs = corr(activation_vectors,noisy_vectors);
    for this_bin = 1:num_orientation_bins,
        corrs_of_this_noisy_vector = noisy_corrs(:,this_bin);
        [ max_corr, best_match_ind  ] = max( corrs_of_this_noisy_vector );
        best_matching_orientations( this_bin ) = best_match_ind;
    end;
    best_matches_rec(rep_num,:) = best_matching_orientations;
end;
        
%%%% Let's make polar plots of how often each orietnation
%%%% gave the best match, like in Fig.2 of Kamitani & Tong
figure(9);
clf;
for this_bin = 1:num_orientation_bins,
    %%%% First, let's count up the best matches for each orientation
    best_matches_for_this_orientation = best_matches_rec(:,this_bin);
    best_matches_count = hist(best_matches_for_this_orientation, ...
                              [1:num_orientation_bins]-0.5);
    %%%% Now let's plot this as a polar plot 
    %%%% The orientation bins only go from -pi/2 to pi/2,
    %%%% but the polar plot goes from -pi to pi, 
    %%%% so we'll plot it twice back-to-back.
    %%%% Actually, we'll do it three times as a hack,
    %%%% as it makes the plot lines join up into a circle and look nice
    subplot(3,3,this_bin),
        h=polar([bin_centers pi+bin_centers bin_centers],repmat(best_matches_count,1,3));
        set(h,'LineWidth',3);
end;
subplot(3,3,2),
title('How successfully each orientation is decoded','FontSize',14); 

