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
