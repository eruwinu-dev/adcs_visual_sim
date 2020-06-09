function [value_list] = form2val(tag_list)
    value_list = zeros(size(tag_list));
    for x = 1:length(value_list)
        obj = findobj(gcf, 'Tag', tag_list(x));
        obj_string = obj.String;
        value_list(x) = str2double(obj_string);
    end
end

