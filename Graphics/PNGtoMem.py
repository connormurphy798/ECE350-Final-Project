"""
File for converting images to .mem files for use in graphics memory.
"""

from PIL import Image

def convertPNG(imgfile, w, h):
    """
    converts imgfile of dimensions (w,h) into a .mem file,
    placing it in the Graphics/MemFiles/ directory
    """
    # files
    im  = Image.open("Graphics/Images/" + imgfile + ".png")
    mem = open("Graphics/MemFiles/" + imgfile + ".mem", "w") 
    
    # write to mem file
    for j in range(h):
        currLine = []
        for i in range(w):
            color = im.getpixel((i,j))
            if color[0] > 127:
                currLine.append("1")
            else:
                currLine.append("0")
        mem.write(" ".join(currLine) + "\n")
    mem.close()



if __name__ == "__main__":
    convertPNG("bkg_controllertest", 160, 120)
