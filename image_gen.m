load adversarial_radar_data.mat;

chu_counter = 1;
gol_counter = 1;

presentDir = 'present_images';
absentDir = 'absent_images';


for i = 1:numel(output)
    % Get the label, waveform, and ambg from the struct
    label = output(i).label;
    waveform = output(i).waveform;
    ambg = output(i).ambg;
    % Construct the filename for the image
    figure;
    imagesc(ambg);
    if strcmp(waveform,'chu')
    % Determine the directory based on the label
    if strcmp(label, 'present')
        saveDir = presentDir;
    else
        saveDir = absentDir;
    end
    filename = sprintf('%s_%d.png', waveform, chu_counter);
    chu_counter = chu_counter+1;
      else 
    % Determine the directory based on the label
    if strcmp(label, 'present')
        saveDir = presentDir;
    else
        saveDir = absentDir;
    end
    filename = sprintf('%s_%d.png', waveform, gol_counter);
    gol_counter = gol_counter+1;
      end
    fullFilePath = fullfile(saveDir, filename);
    % Save the image to the appropriate directory
    saveas(gcf, fullFilePath);
    close all;
end
