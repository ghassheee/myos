myos : myos.nas Makefile
	nask myos.nas myos

myos.img : myos Makefile
	./edimg -i 0.img -o myos.img --addsrc myos 0 0 512

img :
	make -r myos.img

asm : 
	make -r myos

burn : 
	diskutil unmount /dev/disk2
	sudo dd if=./myos.img of=/dev/disk2 bs=4096  
