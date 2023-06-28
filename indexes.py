width = 5;
height = 5;

for i in range(0, 25):
    # i < width is on top row
    # i > width * (height - 1) is on bottom row
    # i % width == 0 is on the left wall
    # i % width == width - 1 is on the right wall
    print(f"{i}:{i < width * (height - 1)}")

# 00 01 02 03 04
# 05 06 07 08 09
# 10 11 12 13 14
# 15 16 17 18 19
# 20 21 22 23 24
    