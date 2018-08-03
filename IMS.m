% javaaddpath C:\Users\rmd\AppData\Local\Apps\HDF_Group\HDFView\2.13.0\lib\slf4j-nop-1.7.5.jar
% javaaddpath C:\Users\rmd\AppData\Local\Apps\HDF_Group\HDFView\2.13.0\lib\slf4j-simple-1.7.5.jar
% javaaddpath C:\Users\rmd\AppData\Local\Apps\HDF_Group\HDFView\2.13.0\lib\fits.jar
% javaaddpath C:\Users\rmd\AppData\Local\Apps\HDF_Group\HDFView\2.13.0\lib\HDFView.jar
% javaaddpath C:\Users\rmd\AppData\Local\Apps\HDF_Group\HDFView\2.13.0\lib\jarhdf-3.2.1.jar
% javaaddpath C:\Users\rmd\AppData\Local\Apps\HDF_Group\HDFView\2.13.0\lib\jarhdf5-3.2.1.jar
% javaaddpath C:\Users\rmd\AppData\Local\Apps\HDF_Group\HDFView\2.13.0\lib\netcdf.jar
% javaaddpath C:\Users\rmd\AppData\Local\Apps\HDF_Group\HDFView\2.13.0\lib\slf4j-api-1.7.5.jar
% java.lang.System.load('C:\Users\rmd\AppData\Local\Apps\HDF_Group\HDFView\2.13.0\lib\jhdf.dll')
% java.lang.System.load('C:\Users\rmd\AppData\Local\Apps\HDF_Group\HDFView\2.13.0\lib\jhdf5.dll')
% java.lang.System.load('C:\Users\rmd\AppData\Local\Apps\HDF_Group\HDFView\2.13.0\lib\msvcp140.dll')
% java.lang.System.load('C:\Users\rmd\AppData\Local\Apps\HDF_Group\HDFView\2.13.0\lib\vcruntime140.dll')

if isequal(sum(cellfun(@(x) ~isempty(strfind(x,'ImarisWriter.jar')),javaclasspath('-all'))),0)
    javaaddpath D:\QMDownload\3\IMSWriter-master\lib\jhdfobj.jar
    javaaddpath D:\QMDownload\3\IMSWriter-master\lib\ImarisWriter.jar
    javaaddpath D:\QMDownload\3\IMSWriter-master\lib\jhdf5.jar
    javaaddpath D:\QMDownload\3\IMSWriter-master\lib\jhdf5obj.jar
    
    java.lang.System.load('D:\QMDownload\3\IMSWriter-master\lib\jhdf5.dll');
    java.lang.System.load('D:\QMDownload\3\IMSWriter-master\lib\jhdf.dll');
    java.lang.System.load('D:\QMDownload\3\IMSWriter-master\lib\win\jhdf5.dll');
    java.lang.System.load('D:\QMDownload\3\IMSWriter-master\lib\win\jhdf.dll');
    
    javaaddpath D:\QMDownload\3\IMSWriter-master\lib\jhdf.jar
    javaaddpath D:\QMDownload\3\IMSWriter-master\lib\jhdf4obj.jar
    javaaddpath D:\QMDownload\3\IMSWriter-master\lib\jhdfview.jar
    javaaddpath D:\QMDownload\3\IMSWriter-master\lib\junit.jar
    javaaddpath D:\QMDownload\3\IMSWriter-master\lib\netcdf.jar
    javaaddpath D:\QMDownload\3\IMSWriter-master\lib\fits.jar
end
% java.lang.System.setProperty('ncsa.hdf.hdf5lib.H5','D:\QMDownload\3\IMSWriter-master\lib\win\jhdf5.dll'); 
% T = javaObject('ncsa.hdf.hdf5lib.H5')

%% old version
if 1 == 2
    dir = tempdir;
    pixelSizeZ = 2.0;
    pixelSizeXY = 1.0;
    slices = 10; %number of z slices
    frames = 1; %number of time points
    channels = 1;
    colors = [];
    width = 512;
    height = 512;
    prefix = 'Test ims file';
    %open writer
    imarisWriter = HDF.ImarisWriter(dir,prefix,width,height,slices,channels,frames,pixelSizeXY,pixelSizeZ,colors);
    %write single slice at a time
    pixels = zeros(width, height);
    %adjust as appropriate for each slice
    slice = 0;
    channel = 0;
    frame = 0;
    date = [];
    time = [];
    imarisWriter.addImage(pixels,slice,channel,frame,date,time);
    %close after all slices written
    imarisWriter.close();
end
%% new version
dir = 'D:\QMDownload\3';
name = 'mytestimaris';
shape = [10, 10, 2];
byte_depth = 2;
num_channels = 2;
num_frames = 3;
pixel_size_xy = 0.5;
pixel_size_z = 1.0;

%% 构建ImarisWriter对象
writer = main.java.ImarisWriter(dir,name,int32(shape(1)),int32(shape(2)),int32(byte_depth),int32(shape(3)),int32(num_channels),int32(num_frames),double(pixel_size_xy),double(pixel_size_z));
% methodsview(writer)

%% 向ImarisWriter对象中不断添加图片层
for time_index = 0 :  num_frames - 1
    for channel_index = 0 :  num_channels - 1
        for z_index = 0 :  shape(3) - 1
            tile = 32767 * rand(1,shape(1)*shape(2));
            elapsed_time_ms = (time_index + 1) * 10;
            % here the tile need to be converted to byte?
            % as seen from python's version class: self.writer.addImage(pixels.tobytes()...
            writer.addImage(int16(tile), int32(z_index), int32(channel_index), int32(time_index), int32(elapsed_time_ms));
            %disp('...writing a slice')
        end
    end
end
disp('...writing ALL slices finished!')
%% 关闭ImarisWriter对象
 writer.close()

%%
% writer.getClass
% writer.toString
% writer.getNumSlicesInQueue
% writer.main()
% writer.ImarisWriter()