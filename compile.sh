sudo nasm boot.asm -f bin -o boot.bin
sudo nasm kernel.asm -f bin -o kernel.bin
sudo cat boot.bin kernel.bin > OS.bin
sudo cp OS.bin BisOS.img
sudo truncate -s 1440k BisOS.img

if [ $1 ]

then

if [ $1 = -r ]

then

sudo rm boot.bin
sudo rm kernel.bin
sudo rm OS.bin

fi

fi