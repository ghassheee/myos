myos : myos.nas Makefile
	nask myos.nas myos

myos.img : myos Makefile
	./edimg -i 0.img -o myos.img --addsrc myos 0 0 512

img :
	make -r myos.img

asm : 
	make -r myos

burn :
	make -r asm
	make -r img
	diskutil unmountDisk /dev/disk2
	sudo dd if=./myos.img of=/dev/rdisk2 bs=1m  
