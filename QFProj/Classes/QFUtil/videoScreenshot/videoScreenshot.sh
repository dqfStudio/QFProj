# !/bin/bash

#for item in `find . -name '*.mp4' -o -name '*.ts' -o -name '*.mkv' -o -name '*.mpg' -o -name '*.mts'`
#
#do
#    ffmpeg -i $item -ss 00:00:05 -vframes 1 -s 140x80 ${item%.*}.jpeg
#    ffmpeg -i $item -ss 00:00:05 -vframes 1 ${item%.*}.jpeg  //根据原图大小生产图片
#done


#1.截取从某一时间开始那一帧缩略图
#
#for item in `find . -name '*.mp4' -o -name '*.ts' -o -name '*.mkv' -o -name '*.mpg' -o -name '*.mts'`
#
#do
#    ffmpeg -i $item -ss 00:00:05 -vframes 1 -s 140x80 ${item%.*}.jpeg
#done



#2.截取视频所有关键帧缩略图

#for item in `find . -name '*.mp4' -o -name '*.ts' -o -name '*.mkv' -o -name '*.mpg' -o -name '*.mts'`
#do
#    ffmpeg -i $item -vf select='eq(pict_type\,I)' -vsync 2 -s 280x160 -f image2 thumbnails-%02d.jpeg
#
#done

#3.截取某一关键帧缩略图

for item in `find . -name '*.mp4' -o -name '*.ts' -o -name '*.mkv' -o -name '*.mpg' -o -name '*.mts'`
do
    ffmpeg -y -i $item -vf "select=eq(pict_type\\,I)" -vframes 1 -f image2 -s 720x1280 ${item%.*}.jpeg
#    ffmpeg -y -i $item -ss 115 -t 10 -vf "select=eq(pict_type\\,I)" -vframes 1 -f image2 -s 280x160 ${item%.*}.jpeg
done




#ffmpeg -i 1.webp 1.png
#
#cwebp 1.png -o ./222/1.webp
#
#cwebp -q 100 1.png -o 1.webp
#
#ffmpeg -i 屏幕录制.mov 屏幕录制.avi
#ffmpeg -i 屏幕录制.mov 屏幕录制.mp4
#ffmpeg -i 屏幕录制.mov 屏幕录制.flv
#
#ffmpeg -i 屏幕录制.mov 屏幕录制.webm
#ffmpeg -i 屏幕录制.mov 屏幕录制.ogg


#压缩图片
#ffmpeg -i 屏幕录制.png   -codec libwebp -lossless 0  屏幕录制2.png
#ffmpeg -i 屏幕录制.png   -codec libwebp -lossless 0 -quality 100  屏幕录制5.png




#-lossless 是设置无损压缩
#
#-preset 是几个预设的参数
#
#-quality 这个就是主要的参数了，控制压缩率
#
#调整图片大小用-vf scale=iw/3:ih/3，可以指定和原来的比例，也可以指定明确的像素值比如1280:720。
#
#e.g. 单纯调整图片大小，无损压缩把图片宽高缩小3倍iw/3:ih/3。
#
#ffmpeg -i input.png  -vf scale=iw:ih -codec libwebp -lossless 0 -quality 75 out.webp
#
#选择无损压缩时，“-lossless -q 100” 是最佳方案,注意:cwebp 仅仅对png格式的图片使用无损压缩时，会有较为高效的压缩率和图片质量
#选择有损压缩时，“-q 75”是最佳方案（图片质量与体积大小达到均衡）建议其他格式图片使用有损压缩
#无论何种压缩参数，加上“-m 6”都能使得输出的 WebP 图片进一步减少体积，量级是1%~2%，但是会增加耗时
#非png格式的图片选择无损压缩时，“-lossless -q 100” 时编码时间长，图片质量反而极高可能变大，编码时间时间很长，cpu使用率飙升跑满，不建议使用
#建议选择有损压缩时，“-q 75”是最佳方案（图片质量与体积大小达到均衡）建议使用
