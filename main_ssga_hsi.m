% main.m
%
% This script implements the SSGA for unsupervised HSI band selection.
%

%% 清空环境变量
clear;close all;clc;
warning off;
addpath(genpath(pwd));
t_start = clock;
%% params for data
data_type = 'IP';    % 待处理的数据类型 - 'IP' or 'PU' or 'PC' or 'SA'
num_classes = 16;    % 数据的类别数目 - 16 or 9 or 9 or 16
num_bands = 200;    % 200 or 103 or 102 or 204
data_name = [data_type,'_',num2str(num_classes)];

Num_sp = 300;    % 300 or 500 or 700 or 900
num_bands_set = [5:20, 30:10:60];
bands_sel_file = fullfile(pwd, ['bands_select_info_', data_name, '_SP_', num2str(Num_sp)]);
mkdir(bands_sel_file);

%% load data
[data_vec, img_PCA, label_inds] = load_data_func(data_type, num_classes);
% superpixel
SP_Map = superpixel_func(img_PCA, Num_sp);
SP_vec = SP_Map(:);
SP_vec = SP_vec(label_inds);

for ii_trial = 1:5
    for ii_num_bands = num_bands_set
        %% params for GA setting
        NSel = ii_num_bands;                        % Number of bands selected
        NIND = 100;                                 % Number of individuals per subpopulations
        MAXGEN = 100;                               % maximum Number of generations
        GGAP = .9;                                  % Generation gap, how many new individuals are created
        NVAR1 = num_bands;                          % Number of variables for data
        rate_NumPm = 0.2;                           
        
        opts.NVAR1 = NVAR1;
        
        data_obj.data_vec = data_vec;
        data_obj.sp_vec = SP_vec;
        
        %% GA
        % Initialise population
        Chrom1 = ga_crtbp(NIND, NVAR1, NSel);
        Chrom = Chrom1;
        
        % Reset counters
        Best = NaN*ones(MAXGEN,1);	% best in current population
        gen = 1;			% generational counter
        
        % Evaluate initial population
        ObjV = objfun_UL(Chrom, data_obj, opts);
        
        % Track best individual and display convergence
        Best(gen) = min(ObjV);
        
        if ispc
            plot(Best, 'b-*'); xlabel('generation'); ylabel('fit');
            text(0.5, 0.95, ['Best = ', num2str(Best(gen))], 'Units', 'normalized');
            drawnow;
        elseif isunix
            fprintf('Num_SP -> %d, Num_Trial -> %d, Num_Bands -> %02d, Iteration %03d/%03d : Best Cost = %g ...\n', Num_sp, ii_trial, ii_num_bands ,gen, MAXGEN, Best(gen));
        end
        % Generational loop
        Pm_min = 0.02;    % initial mutation probability
        Pm_max = 0.1;    % ultimate mutation probability
        n_Pm = ceil(NSel * rate_NumPm);
        best_objv = Best(gen);
        gen_threshold = round(MAXGEN * 0.5);
        gen_patient = 0;
        while gen < MAXGEN
            
            % Assign fitness-value to entire population
            FitnV = ranking(ObjV);    % ObjV more smaller FintV more bigger
            
            % Select individuals for breeding
            SelCh = select('sus', Chrom, FitnV, GGAP);
            
            %%
            % % Recombine selected individuals (crossover)
            % SelCh = recombin('xovsp',SelCh,0.7);
            % % Perform mutation on offspring
            % SelCh = mut(SelCh);
            
            %%
            % Recombine selected individuals (crossover)
            SelCh = ga_cross('xovsp', SelCh, opts, 0.9999);
            % Perform mutation on offspring
            Pm = Pm_min + (gen / MAXGEN) * (Pm_max - Pm_min);
            SelCh = ga_mut(SelCh, opts, Pm, n_Pm);
            
            %%
            % Evaluate offspring, call objective function
            ObjVSel = objfun_UL(SelCh, data_obj, opts);
            
            % Reinsert offspring into current population
            [Chrom, ObjV] = reins(Chrom, SelCh, 1, 1, ObjV, ObjVSel);
            
            % Increment generational counter
            gen = gen + 1;
            
            % Update display and record current best individual
            Best(gen) = min(ObjV);
            
            if ispc
                plot(Best, 'b-*'); xlabel('generation'); ylabel('fit');
                text(0.5, 0.95, ['Best = ', num2str(Best(gen))], 'Units', 'normalized');
                drawnow;
            elseif isunix
                fprintf('Num_SP -> %d, Num_Trial -> %d, Num_Bands -> %02d, Iteration %03d/%03d : Best Cost = %g ...\n', Num_sp, ii_trial, ii_num_bands ,gen, MAXGEN, Best(gen));
            end
            
            if Best(gen) < best_objv
                best_objv = Best(gen);
                gen_patient = 0;
            else
                gen_patient = gen_patient + 1;
            end
            if gen_patient >= gen_threshold
                break;
            end
        end
        % End of GA
        
        %% selected band set
        [~, best_idx] = min(ObjV);
        best_chrom = Chrom(best_idx, :);
        var_sel = find(best_chrom(1:opts.NVAR1) == 1);
        
        %% save bands selected
        bands_info_save_file = fullfile(bands_sel_file, ['bands_sel_info_', num2str(ii_num_bands), '_', num2str(ii_trial), '_',data_name, '.csv']);
        csvwrite(bands_info_save_file, var_sel(:));
        
        t_end = clock;
        fprintf('Elapsed time is %.6f seconds\n', etime(t_end, t_start));
    end
end

