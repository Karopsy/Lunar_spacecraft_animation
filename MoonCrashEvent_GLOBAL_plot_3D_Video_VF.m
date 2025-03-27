clc; clear; close all;

% Define Moon radius in km
moon_radius = 1737.4;

% Load textures
milkyway_texture = imread('/Users/louis/Downloads/2k_stars_milky_way.jpg'); % Update path
moon_texture = imread('/Users/louis/Downloads/2k_moon_equirectangular.jpg'); % Update path

% Spacecraft names and crash site lat/lon
spacecraft_names = {'Luna2','Ranger4','Ranger6','Ranger7','Ranger8','Ranger9','Luna5','Luna7','Luna8','Luna9',...
    'Surveyor1','Surveyor2','LunarOrbiter1','Luna13','Surveyor3','Surveyor5','LunarOrbiter3','LunarOrbiter2',...
    'Surveyor6','Surveyor7','LunarOrbiter5','AP11LMds','Luna15','AP12LMds','AP12LMas','AP13S-IVB','Luna16',...
    'Luna17','Lunokhod1','AP14S-IVB','AP14LMds','AP14LMas','AP15S-IVB','AP15LMds','AP15LMas','Luna18',...
    'Luna20','AP16S-IVB','AP16LMds','AP16subSat','AP17S-IVB','AP17LMds','AP17LMas','Luna21','Lunokhod2',...
    'Luna23','Luna24','Hiten','SMART1','Okina','Change1','Change3','Yutu-Rov','LADEE','Change4','Yutu2',...
    'Beresheet','Longjiang2','Change5','Change5ac','Change5boo','HakutoR','SLIM','Change6', 'BlueGhost',...
    'GrailA', 'GrailB', 'Lunar Prospector', 'Chandra1-MIP', 'Kaguya', 'LCROSS-Centaur', 'LCROSS-S/C',...
    'Vikram', 'Luna25', 'Chandra3', 'IM-1', 'IM-2'};

crash_lat = [30, -15.5, 9.3864, -10.634, 2.6376, -12.8281, -1.35, 9, 9.1, 7.13, -2.4745, 5.5, 6.35, 18.87...
    -3.0162, 1.4551, 14.3, 3, 0.4742, -40.9812, -2.79, 0.67416, 17, -3.0128, -3.94, -2.5550, -0.5137, 38.23764, 38.315... 
    -8.1810, -3.64589, -3.42, -1.2897, 26.13239, 26.36, 3.76, 3.7863, 1.921, -8.9734, 10.16, -4.1681, 20.1911, 19.97...
    25.9994, 25.8323, 12.6667, 12.7142, 34, -34.4, 28.213, -1.5, 44.1214, 44.1208, 11.8494, -45.4561, -45.46, 32.5956...
    16.6956, 43.0576, -30, 5.226, 47.581, -13.316, -41.6385, 18.562...
    75.6088, 75.6508...
    -87.7, -89, -65.5, -84.6796, -84.719, -70.8810, -69.545, -69.3741, -80.13, -84.7906];  

crash_lon = [0, -130.7, 21.4806, -20.6770, 24.7881, -2.3884, -25.48, -49, -63.3, -64.37, -43.3398, -12 ...
    160.71, -62.05, -23.418, 23.1943, -92.7, 119.1, -1.4275, -11.5127, -83.04, 23.47314, 60, -23.4219, -21.2, -27.8875... 
    56.3638, -35.00163, -35.0081, -26.0305, -17.47194, -19.67, -11.8245, 3.63330, 0.25, 56.66, 56.6242, -24.623, 15.5011...
    111.9, -12.3307, 30.7723, 30.49, 30.4076, 30.9222, 62.1511, 62.2129, 55.3, -46.2, -159.033, 52.36, -19.5117, -19.5122... 
    -93.2494, 177.5885, 177.59, 19.3496, 159.517, -51.9161, 0, -125.514, 44.094, 25.2510, -153.9852, 61.81...
    -26.5940, -26.8341...
    42.0, -30, 80.4, -48.7093, -49.61, 22.7840, 43.544, 32.32, 1.44, 29.1957];

% Convert lat/lon to radians
lat_rad = deg2rad(crash_lat);
lon_rad = deg2rad(crash_lon);

% Convert to Cartesian coordinates
x = moon_radius * cos(lat_rad) .* cos(lon_rad);
y = moon_radius * cos(lat_rad) .* sin(lon_rad);
z = moon_radius * sin(lat_rad);

% Radial offset to keep labels above surface
offset_factor = 250; % Adjust as needed
x_text = x * (1 + offset_factor / moon_radius);
y_text = y * (1 + offset_factor / moon_radius);
z_text = z * (1 + offset_factor / moon_radius);

% Compute pairwise distances
num_labels = length(spacecraft_names);
for iter = 1:100  % Apply repulsion for 10 iterations
    distances = squareform(pdist([x_text', y_text', z_text']));
    for i = 1:num_labels
        for j = i+1:num_labels
            if distances(i, j) < 350  % If too close, push apart
                % Compute direction vector
                dir_vec = [x_text(i) - x_text(j), y_text(i) - y_text(j), z_text(i) - z_text(j)];
                dir_vec = dir_vec / norm(dir_vec); % Normalize
                
                % Apply small displacement
                move_amount = 50;  % Adjust spread strength
                x_text(i) = x_text(i) + move_amount * dir_vec(1);
                y_text(i) = y_text(i) + move_amount * dir_vec(2);
                z_text(i) = z_text(i) + move_amount * dir_vec(3);
                
                x_text(j) = x_text(j) - move_amount * dir_vec(1);
                y_text(j) = y_text(j) - move_amount * dir_vec(2);
                z_text(j) = z_text(j) - move_amount * dir_vec(3);
            end
        end
    end
end

% --- Plot the Moon and Labels ---
% Create Moon sphere
[xm, ym, zm] = sphere(100);
xm = xm * moon_radius;
ym = ym * moon_radius;
zm = zm * moon_radius;

% Create figure with Milky Way background
fig = figure('Color', 'k', 'Position', [100, 100, 800, 800]);
axes('Position', [0 0 1 1]);
imshow(milkyway_texture);
hold on;

% Create 3D Moon plot
ax = axes('Parent', fig);
hold on;
surf(xm, ym, zm, 'FaceColor', 'texturemap', 'CData', moon_texture, 'EdgeColor', 'none');

% Plot crash sites
scatter3(x, y, z, 75, 'r', 'filled');

% Add labels with leader lines
for i = 1:length(spacecraft_names)
    plot3([x(i), x_text(i)], [y(i), y_text(i)], [z(i), z_text(i)], 'w-', 'LineWidth', 1);
    text(x_text(i), y_text(i), z_text(i), spacecraft_names{i}, 'FontSize', 12, 'Color', 'w', ...
         'HorizontalAlignment', 'right', 'VerticalAlignment', 'middle', 'FontWeight', 'bold');
end

% Adjust visualization
set(gca, 'Color', 'none'); 
axis equal;
axis off;  
grid off;  
rotate3d on;

% Send background to back
uistack(ax, 'top'); 

hold off;

%% To create the video (v4 - vfinal)

% Camera settings for animation
frames = 200; % Number of frames in the animation
duration = 15; % Duration of the video in seconds
azimuth_start = 300; % Start azimuth angle (rotation along the equator)
elevation_start = 65; % Start elevation angle (equator view)
azimuth_end = -10; % End azimuth angle (complete rotation)
elevation_end = -65; % End elevation angle (tilting to see south pole)
zoom_factor = 1.005; % Fixed zoom level to keep the Moon larger throughout

% Create VideoWriter object
video_filename = '/Users/louis/Downloads/moon_rotation_spacecraft_sites_V2.mp4'; % Name of the video file
v = VideoWriter(video_filename, 'MPEG-4'); % Create video object with mp4 format
v.FrameRate = frames / duration; % Set the frame rate
open(v); % Open the video file for writing

% Create the animation
for i = 1:frames
    % Linearly interpolate azimuth and elevation (constant motion)
    t = i / frames;
    azimuth = azimuth_start + (azimuth_end - azimuth_start) * t;
    elevation = elevation_start + (elevation_end - elevation_start) * t;

    % Update the camera view
    view(azimuth, elevation);
    camzoom(zoom_factor); % Apply fixed zoom

    % Capture the current frame for the video
    frame = getframe(gcf); % Capture the current figure as a frame
    
    % Write the frame to the video
    writeVideo(v, frame);
    
    % Pause for smooth animation
    pause(duration / frames);
end

% Close the video file
close(v);

disp(['Video saved as ', video_filename]);