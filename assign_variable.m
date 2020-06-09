function assign_variable(tag, variable)
    % tag, variable must be string
    obj = findobj(gcf, 'Tag', tag);
    val = str2double(obj.String);
    assignin('base', variable, val);
end