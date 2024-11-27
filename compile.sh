nasm boot.asm -f bin -o boot.bin
nasm kernel.asm -f bin -o kernel.bin
cat boot.bin kernel.bin > OS.bin
cp OS.bin BisOS.img
truncate -s 1440k BisOS.img

if [ $1 ]

then

if [ $1 = -r ]

then

rm boot.bin
rm kernel.bin
rm OS.bin

fi

fi