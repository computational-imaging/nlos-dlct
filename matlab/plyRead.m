function [vertices,faces,normals] = plyRead(filename,face_index_start)
%% Parse the Header
fid = fopen(filename,'r');
readFile = true;
ii = 0;
while readFile == true
    fLine = fgetl(fid);
    ii = ii + 1;
    if regexpi(fLine,'element vertex')
        fLine = strsplit(fLine,' ');
        nVertex = str2double(fLine{end});
        continue
    end
    
    if regexpi(fLine,'element face')
        fLine = strsplit(fLine,' ');
        nFace = str2double(fLine{end});
        continue
    end
    
    if regexpi(fLine,'end_header')
        readFile = false;
        endHeader = ii;
        continue
    end    
end
fclose(fid);
%% Textscan the vertex info
delimiter = ' ';
startRow = endHeader+1;
endRow = startRow + nVertex - 1;
formatSpec = '%f%f%f%f%f%f%*s%[^\n\r]';
fid = fopen(filename,'r');
dataArray = textscan(fid, formatSpec, nVertex, 'Delimiter', delimiter, 'MultipleDelimsAsOne', true, 'EmptyValue' ,NaN,'HeaderLines', startRow-1, 'ReturnOnError', false);
fclose(fid);
vertices = [dataArray{1:3}];
normals = [dataArray{4:6}];
%% Textscan the face connectivity
delimiter = ' ';
startRow = endRow + 1;
formatSpec = '%*q%f%f%f%*s%[^\n\r]';
fid = fopen(filename,'r');
dataArray = textscan(fid, formatSpec, 'Delimiter', delimiter, 'MultipleDelimsAsOne', true, 'EmptyValue' ,NaN,'HeaderLines' ,startRow-1, 'ReturnOnError', false);
fclose(fid);
faces = [dataArray{1:end-1}];
faces = faces + face_index_start;