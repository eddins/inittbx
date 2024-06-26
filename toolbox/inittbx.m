%INITTBX Initialize a MATLAB toolbox
%   INITTBX(root_name) initialized a basic folder hierarchy and set of
%   files for a MATLAB toolbox, based on the recommendations in MATLAB
%   Toolbox Best Practices (https://github.com/mathworks/toolboxdesign).
%   The folder hierarchy is created in a subfolder of the working folder
%   with the specified name.
%
%   NAMED ARGUMENTS
%
%     OutputFolder   Folder containing the new folder hierarchy. Defaults
%                    to the current working folder.
%
%     FunctionName   Name of the stub MATLAB code file created in the
%                    toolbox subfolder of the hierarchy. Defaults to
%                    "myfunc". 
%
%     ToolboxName    Name of the toolbox. Defaults to "<root_name>
%                    Toolbox". 
%
%     ToolboxVersion Semantic version of the toolbox. Defaults to "1.0.0".
%
%   EXAMPLE
%
%     Create a MATLAB toolbox folder hierarchy named "banana" and then run
%     buildtool to check for code issues, run tests, and package the
%     toolbox.
%
%       inittbx("banana", ToolboxName = "Fruit Toolbox")
%       cd banana
%       buildtool
%
% See also BUILDTOOL

function inittbx(root_name,options)
    arguments
        root_name                 (1,1) string
        options.OutputFolder      (1,1) string = pwd
        options.FunctionName      (1,1) string = defaultFunctionName(root_name)
        options.ToolboxName       (1,1) string = root_name + " Toolbox"
        options.ToolboxVersion    (1,1) string = "1.0.0"
    end

    try
        release_error = isMATLABReleaseOlderThan("R2023b");
    catch
        release_error = true;
    end
    if release_error
        error("inittbx:UnsupportedRelease", ...
            "MATLAB release R2023b or later is required.")
    end    

    % Initialize folder structure
    %
    %    root/
    %    ├─── toolbox/
    %    │       └─── examples/
    %    └─── tests/

    root_folder = fullfile(options.OutputFolder,root_name);
    toolbox_folder = fullfile(root_folder,"toolbox");
    examples_folder = fullfile(toolbox_folder,"examples");
    tests_folder = fullfile(root_folder,"tests");
    
    makeFolder(root_folder);
    makeFolder(toolbox_folder);
    makeFolder(examples_folder);
    makeFolder(tests_folder);

    % Place files in the root folder
    %
    %    root/
    %    ├─── README.md  
    %    ├─── LICENSE.md
    %    ├─── CHECKLIST.md    
    %    ├─── buildfile.m
    %    ├─── packageToolbox.m    
    %    ├─── toolboxOptions.m    
    %    ├─── .gitignore
    %    └─── .gitattributes    
    
    copyTemplateFile("MATLAB.gitignore",root_folder,OutputName = ".gitignore");
    copyTemplateFile("README.md",root_folder);
    copyTemplateFile("LICENSE.md",root_folder);
    copyTemplateFile("CHECKLIST.md",root_folder);
    copyTemplateFile("toolboxOptions.m",root_folder,...
        Replacements = dictionary( ...
        "<toolbox_name>",    options.ToolboxName, ...
        "<toolbox_package_name>", options.ToolboxName, ...
        "<toolbox_version>", options.ToolboxVersion, ...
        "<toolbox_identifier>", matlab.lang.internal.uuid));
    copyTemplateFile("packageToolbox.m",root_folder);
    copyTemplateFile("buildfile.m",root_folder);
    copyTemplateFile("mwgitignore",root_folder,...
        OutputName = ".gitignore");
    copyTemplateFile("mwgitattributes",root_folder,...
        OutputName = ".gitattributes");

    % Place files in the toolbox folder
    %
    %    root/
    %    └─── toolbox/
    %         ├─── <function_name>.m     See options.FunctionName
    %         └─── gettingStarted.mlx

    function_name = erase(options.FunctionName,".m" + textBoundary("end"));
    function_filename = function_name + ".m";
    copyTemplateFile("myfunc.m",toolbox_folder,...
        OutputName = function_filename,...
        Replacements = dictionary("<function_name>",function_name));

    copyTemplateFile("gettingStarted.mlx",toolbox_folder);

    % Place files in the toolbox examples folder
    %
    %    root/
    %    └─── toolbox/
    %         └─── examples/
    %              └───HelpfulExample.mlx

    copyTemplateFile("HelpfulExample.mlx",examples_folder);

    % Place files in the tests folder
    %
    %    root/
    %    └─── tests/
    %         └─── <function_name>_test.m

    test_class_name = function_name + "_test";
    test_class_filename = test_class_name + ".m";
    copyTemplateFile("myfunc_test.m",tests_folder,...
        OutputName = test_class_filename,...
        Replacements = dictionary("<test_class_name>",test_class_name));
end

function makeFolder(folder_path)
    [status,msg,msg_id] = mkdir(folder_path);
    if (status == 0)
        error(msg_id,msg);
    end
end

function p = codePath
    w = which(mfilename);
    p = fileparts(w);
end

function f = templateFolder
    f = fullfile(codePath,"templates");
end

function name = defaultFunctionName(root_name)
    if isvarname(root_name)
        name = root_name;
    else
        name = "myfunction";
    end
end

function copyTemplateFile(template_name,output_folder,options)
    arguments
        template_name (1,1) string
        output_folder (1,1) string
        options.OutputName (1,1) string = template_name
        options.Replacements (1,1) dictionary = dictionary(strings(0,1),strings(0,1))
    end

    full_template_path = fullfile(templateFolder,template_name + "_TEMPLATE");
    full_output_path = fullfile(output_folder,options.OutputName);
    [status,msg,msg_id] = copyfile(full_template_path,full_output_path);
    if (status == 0)
        error(msg_id,msg);
    end

    e = entries(options.Replacements);
    if height(e) > 0
        lines = readlines(full_output_path);
        for k = 1:height(e)
            lines = replace(lines,e.Key(k),e.Value(k));
        end
        writelines(lines,full_output_path);
    end
end
