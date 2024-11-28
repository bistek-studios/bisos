nasm boot.asm -f bin -o boot.bin
nasm stage2.asm -f bin -o stage2.bin
nasm kernel.asm -f bin -o kernel.bin
cat boot.bin stage2.bin > bootloader.bin
cat bootloader.bin kernel.bin > OS.bin
cp OS.bin BisOS.img
truncate -s 1440k BisOS.img

if [ $1 ]

then

if [ $1 = -r ]

then

sudo rm boot.bin
sudo rm kernel.bin
sudo rm stage2.bin
sudo rm OS.bin

fi

fi