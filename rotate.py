import pygame as pg
import os

homePath = "c:/Users/Ben/StudioProjects/untitled2"

segment = "corridor"
theme = "default"
folder = f"{homePath}/assets/{theme}/{segment}/"
refFile = f"{homePath}/refAssets/{theme}/{segment}/"


def save(file, i):
    img = pg.image.load(f"{refFile}{file}.png")
    pg.image.save(pg.transform.rotate(img, 90 * i), f"{folder}{lastFileCount + i}.png")

for file in range(0, 5):
    lastFileCount = len(os.listdir(folder))
    if (file == 0):
        for i in range(0, 1):
            save(file, i)
    if (file == 1):
        for i in range(0, 4):
            save(file, i)
    if (file == 2):
        for i in range(0, 2):
            save(file, i)
    if (file == 3):
        for i in range(0, 4):
            save(file, i)
    if (file == 4):
        for i in range(0, 4):
            save(file, i)
