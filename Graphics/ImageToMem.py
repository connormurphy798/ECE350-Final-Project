"""
File for converting images to .mem files for use in graphics memory.
"""

from PIL import Image

def convertImage(imgfile, w, h, type=""):
    """
    converts imgfile of dimensions (w,h) into a .mem file,
    placing it in the Graphics/MemFiles/ directory
    """
    # files
    im  = Image.open("Graphics/Images/" + imgfile + type)
    mem = open("Graphics/MemFiles/" + imgfile + ".mem", "w") 
    print("Generating " + imgfile + ".mem...")
    
    # write to mem file
    for j in range(h):
        currLine = []
        for i in range(w):
            color = im.getpixel((i,j))
            if color[0] > 127 or color[1] > 127 or color[2] > 127:
                currLine.append("1")
            else:
                currLine.append("0")
        mem.write(" ".join(currLine) + "\n")
    mem.close()


def invertMem(memfile, w, h, inPlace=False):
    """
    inverts memfile of dimensions (w,h) such that
    all bits are complemented.
    optionally can invert a file into itself if inPlace=True.
    """
    mem = open("Graphics/MemFiles/" + memfile + ".mem", "r")
    print("Inverting " + memfile + ".mem...")

    # invert into another file
    if not inPlace:
        inv = open("Graphics/MemFiles/" + memfile + "_inv.mem", "w")

        # write to mem file
        for j in range(h):
            rLine = mem.readline().split()
            wLine = []
            for i in range(w):
                num = rLine[i]
                wLine.append(str(1-int(num)))    # 0 -> 1, 1 -> 0
            inv.write(" ".join(wLine) + "\n")
        mem.close()
        inv.close()
    
    # invert into the same file
    else:
        lines = mem.readlines()
        mem.close()
        mem = open("Graphics/MemFiles/" + memfile + ".mem", "w")
        for j in range(h):
            rLine = lines[j].split()
            wLine = []
            for i in range(w):
                num = rLine[i]
                wLine.append(str(1-int(num)))    # 0 -> 1, 1 -> 0
            mem.write(" ".join(wLine) + "\n")
        mem.close()


def combineMem(newfile, memfiles):
    """
    combines a list of memfiles into a single newfile
    """
    newmem = open("Graphics/MemFiles/" + newfile + ".mem", "w")
    for filename in memfiles:
        file = open("Graphics/MemFiles/" + filename + ".mem", "r")
        for line in file:
            newmem.write(line)
        file.close()
    newmem.close()



if __name__ == "__main__":
    pass
    # convertImage("bkg_jump_VICTORY", 160, 120, ".png")
    # convertImage("bkg_jump_DEATH", 160, 120, ".png")
    # convertImage("bkg_jump_JUMP2", 160, 120, ".png")
    # convertImage("bkg_jump_JUMP1", 160, 120, ".png")
    # convertImage("sp_jump_right", 16, 16, ".png")
    # convertImage("sp_jump_dead", 16, 16, ".png")
    # invertMem("", 160, 120, inPlace=True)
    combineMem("sp_jump_gmem", [    "sp_jump_left",
                                    "sp_jump_right",
                                    "sp_jump_dead"  ])
    # convertImage("bkg_maze_WIN", 160, 120, ".png")

